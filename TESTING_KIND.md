# Using kind to test observability

First create a kind cluster with the following command:

```bash
kind create cluster --name observability
```

## Launch `coder` in a namespace

Install `coder` to the namespaced `coder` following these docs: https://coder.com/docs/install/kubernetes

In the `values.yaml` file, set `CODER_ACCESS_URL` to the empty string to get a public `try` url. Also turn on prometheus scraping.
```yaml
coder:
  podAnnotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "2112"
  env:
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

# Install the observability stack

```bash
# Placing it into the `coder-observability` namespace
helm install --namespace coder-observability --create-namespace observe .
# Set kubectl default namespace to `coder-observability` for easier usage
kubectl config set-context --current --namespace=coder-observability
```

## To update

```bash
helm upgrade --namespace coder-observability --create-namespace observe .
```

## To port-forward services

- Prometheus: `kubectl -n coder-observability port-forward svc/prometheus 3000:80`
- Grafana: `kubectl -n coder-observability port-forward svc/grafana 3000:80`