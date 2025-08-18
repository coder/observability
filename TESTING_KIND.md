# Using kind to test observability

<details>
  <summary>If using nix</summary>

    `nix-shell -p kind kubernetes-helm kubectl`

</details>

To test the observability chart locally without a kubernetes cluster, you can use [`kind` (Kubernetes in Docker)](https://kind.sigs.k8s.io/). This allows you to create a local Kubernetes cluster that can be used for testing purposes.

```bash
kind create cluster --name observability
# To clean everything up, you can delete the cluster with:
# kind delete cluster --name observability
```

First a `coder` deployment is required, as the observability stack is designed to monitor `coder` deployments.

## Launch `coder` in a namespace

Install `coder` to the namespaced `coder` following these docs: https://coder.com/docs/install/kubernetes

In the `values.yaml` file, set `CODER_ACCESS_URL` to the empty string to get a public `try` url. Also turn on prometheus scraping.
```yaml
coder:
  podAnnotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "2112"
    pyroscope.io/scrape: "true"
    pyroscope.io/port: '6060'
  env:
    - name: CODER_PPROF_ADDRESS
      value: "0.0.0.0:6060"
    - name: CODER_PPROF_ENABLE
      value: "true"
    - name: CODER_PROMETHEUS_ENABLE
      value: "true"
    - name: CODER_PG_CONNECTION_URL
      valueFrom:
        secretKeyRef:
          name: coder-db-url
          key: url
    - name: CODER_OAUTH2_GITHUB_DEFAULT_PROVIDER_ENABLE
      value: "false"
    - name: CODER_ACCESS_URL
      # Keep this an empty string to get a public `try` url
      value: ""
```

### Verify `coder` installation

Check the pods are running:

```bash
$ kubectl get pods -n coder
NAME                   READY   STATUS    RESTARTS   AGE
coder-76d47f8b-qhjvj   1/1     Running   0          28s
postgresql-0           1/1     Running   0          76m
```

### Access `coder`

The IP address of `coder` will be behind the docker container hosting the kind cluster. You can get the IP address of the coder deployment like so:

```bash
$ docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' <kind_cluster_container_name>
172.18.0.2
```

And to know what port to access, find the load balancer service:

```bash
$ kubectl get svc -n coder
NAME            TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
coder           LoadBalancer   10.96.255.11   <pending>     80:31332/TCP   12m
```

So coder can be accessed at `http://172.18.0.2:31332`. After making an account, the public URL will be available at http://172.18.0.2:31332/deployment/overview. This will give you an https publicly accessible URL that you can use to access the coder deployment, and not have to use the IP address directly.

# Install the observability stack (testing the chart!)

Install the local observability chart using Helm into its own namespace.

```bash
# Set kubectl default namespace to `coder-observability` for easier usage
kubectl config set-context --current --namespace=coder-observability
# This will install the local observability chart into the `coder-observability` namespace

helm install --namespace coder-observability --create-namespace observe .
```

## To update

```bash
helm upgrade --namespace coder-observability -force --create-namespace observe .
```

Sometimes the config maps do not take. A quick way to reset the helm installation is just to uninstall and install.

```bash
helm uninstall observe
# Install using the `helm install ...` command from above.
```

## To port-forward services

To view the monitoring services, you can port forward their UI's.

- Grafana: `kubectl -n coder-observability port-forward svc/grafana 3000:80`
- Prometheus: `kubectl -n coder-observability port-forward svc/prometheus 3001:80`
- Pyroscope: `kubectl port-forward svc/pyroscope 3002:4040`
- Grafana Agent: `kubectl port-forward svc/grafana-agent 3003:80`