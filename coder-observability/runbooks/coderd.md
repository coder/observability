# Coderd Runbooks

## CoderdCPUUsage

The CPU usage of one or more Coder pods has been close to the limit defined for
the deployment. This can cause slowness in the application, workspaces becoming
unavailable, and may lead to the application failing its liveness probes and
being restarted.

To resolve this issue, increase the CPU limits of the Coder deployment.

If you find this occurring frequently, you may wish to check your Coder
deployment against [Coder's Reference Architectures](https://coder.com/docs/v2/latest/admin/architectures).

## CoderdMemoryUsage

The memory usage of one or more Coder pods has been close to the limit defined
for the deployment. When the memory usage exceeds the limit, the pod(s) will be
restarted by Kubernetes. This will interrupt all connections to workspaces being
handled by the affected pod(s).

To resolve this issue, increase the memory limits of the Coder deployment.

If you find this occurring frequently, check the memory usage over a longer
period of time. If it appears to be increasing monotonically, this is likely a
memory leak and should be considered a bug.

## CoderdRestarts

One or more Coder pods have been restarting multiple times in the last 10
minutes. This may be due to a number of issues, including:

- Failure to connect to the configured database: Coder requires a reachable
  PostgreSQL database to function. If it fails to connect, you will see an error
  similar to the following:

  ```console
  [warn]  ping postgres: retrying  error="dial tcp 10.43.94.60:5432: connect: connection refused"  try=3
  ```

- Out-Of-Memory (OOM) kills due to memory usage (see [above](#codermemoryusage)),
- An unexpected bug causing the application to exit with an error.

If Coder is not restarting due to excessive memory usage, check the logs:

1. Check the logs of the deployment for any errors,

  ```console
  kubectl -n <coder namespace> logs deployment/coder --previous
  ```

2. Check any Kubernetes events related to the deployment,

  ```console
  kubectl -n <coder namespace> events --watch
  ```