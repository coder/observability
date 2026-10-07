#!/usr/bin/env python3
"""Smoke-test the default chart, or a packaged chart, with its rendered image."""

import json
import pathlib
import shutil
import ssl
import subprocess
import sys
import tempfile
import time
import urllib.error
import urllib.request


def run(*args, **kwargs):
    return subprocess.run(args, check=True, text=True, **kwargs)


def output(*args, **kwargs):
    try:
        return run(*args, capture_output=True, **kwargs).stdout.strip()
    except subprocess.CalledProcessError as error:
        print(error.stdout + error.stderr, file=sys.stderr)
        raise


def check(chart):
    with tempfile.TemporaryDirectory(prefix="prometheus-smoke-") as tmp:
        root = pathlib.Path(tmp)
        manifest = output(
            "helm", "template", "coder-observability", chart,
            "--namespace", "coder-observability",
        )
        # Only parse the outer manifests. Re-serializing prometheus.yml here
        # could silently remove the duplicate YAML keys we need promtool to catch.
        resources = json.loads(output(
            "yq", "eval-all", "-o=json", "[.]", "-", input=manifest,
        ))
        configmaps = {
            resource["metadata"]["name"]: resource["data"]
            for resource in resources if resource and resource["kind"] == "ConfigMap"
        }
        pod = next(
            resource["spec"]["template"]["spec"] for resource in resources
            if resource and resource["kind"] == "StatefulSet"
            and resource["metadata"]["name"] == "prometheus"
        )
        server = next(c for c in pod["containers"] if c["name"] == "prometheus-server")
        image = server["image"]
        print(f"Testing {chart} with {image}", flush=True)

        config = root / "config"
        alerts = config / "alerts"
        config.mkdir()
        alerts.mkdir()
        for name, content in configmaps["prometheus"].items():
            # The chart's extra alerts mount shadows this legacy ConfigMap key.
            if name == "alerts":
                continue
            (config / name).write_text(content)
        for name, content in configmaps["coder-metrics-alerts"].items():
            (alerts / name).write_text(content)

        # Keep the rendered Kubernetes discovery config intact. Supply local
        # service-account fixtures, but never contact a real Kubernetes cluster.
        serviceaccount = root / "serviceaccount"
        serviceaccount.mkdir()
        (serviceaccount / "token").write_text("smoke-test-only\n")
        (serviceaccount / "namespace").write_text("coder-observability\n")
        shutil.copyfile(ssl.get_default_verify_paths().cafile, serviceaccount / "ca.crt")
        mounts = [
            "-v", f"{config}:/etc/config:ro",
            "-v", f"{serviceaccount}:/var/run/secrets/kubernetes.io/serviceaccount:ro",
        ]
        # Use the same image that will run in the cluster, including its promtool.
        # Validate the real alert rules too, not just the config's YAML syntax.
        run("docker", "run", "--rm", *mounts, "--entrypoint", "/bin/promtool",
            image, "check", "config", "/etc/config/prometheus.yml")

        container = output(
            "docker", "run", "-d", *mounts, "--tmpfs", "/data:rw,mode=1777",
            "-p", "127.0.0.1::9090",
            "-e", "KUBERNETES_SERVICE_HOST=127.0.0.1",
            "-e", "KUBERNETES_SERVICE_PORT=9",
            image, *server["args"],
        )
        try:
            address = output("docker", "port", container, "9090/tcp")
            base_url = f"http://{address}"
            deadline = time.monotonic() + 30
            while True:
                try:
                    with urllib.request.urlopen(f"{base_url}/-/ready", timeout=1) as response:
                        if response.status == 200:
                            break
                except (urllib.error.URLError, TimeoutError, ConnectionError):
                    pass
                if output("docker", "inspect", "-f", "{{.State.Running}}", container) != "true":
                    raise RuntimeError("Prometheus exited before becoming ready")
                if time.monotonic() >= deadline:
                    raise RuntimeError("Prometheus did not become ready within 30 seconds")
                time.sleep(0.5)

            with urllib.request.urlopen(f"{base_url}/api/v1/targets", timeout=5) as response:
                targets = json.load(response)["data"]
            if targets["activeTargets"] or targets["droppedTargets"]:
                raise RuntimeError(f"Expected scraping to be left to the collector: {targets}")

            # Exercise ingestion and queryability, rather than checking specific
            # flags or just testing whether the HTTP endpoint exists.
            run(
                "docker", "exec", "-i", container, "/bin/promtool", "push", "metrics",
                "--timeout=5s", "http://127.0.0.1:9090",
                input="# TYPE observability_smoke_test gauge\nobservability_smoke_test 42\n",
            )
            with urllib.request.urlopen(
                f"{base_url}/api/v1/query?query=observability_smoke_test", timeout=5,
            ) as response:
                result = json.load(response)["data"]["result"]
            if len(result) != 1 or float(result[0]["value"][1]) != 42:
                raise RuntimeError(f"Remote-written metric was not queryable: {result}")
            print("PASS: config and rules valid; server ready; no scrape targets; metric written and queried")
        except Exception:
            subprocess.run(["docker", "logs", container], check=False)
            raise
        finally:
            run("docker", "rm", "-f", container, stdout=subprocess.DEVNULL)


if __name__ == "__main__":
    check(sys.argv[1] if len(sys.argv) > 1 else "coder-observability")
