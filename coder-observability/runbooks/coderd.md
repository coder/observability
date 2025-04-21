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

## CoderdReplicas

One or more Coderd replicas are down. This may cause availability problems and elevated
response times for user and agent API calls.

To resolve this issue, review the Coder deployment for possible `CrashLoopBackOff`
instances or re-adjust alarm levels based on the actual number of replicas.

## CoderdWorkspaceBuildFailures

A few workspace build errors have been recently observed.

Review Prometheus metrics to identify failed jobs. Check the workspace build logs
to determine if there is a relationship with a new template version or a buggy
Terraform plugin.

## CoderdLicenseSeats

Your Enterprise license is approaching or has exceeded the number of seats purchased.

Please contact your Coder sales contact, or visit https://coder.com/contact/sales.

## CoderdIneligiblePrebuilds

Prebuilds only become eligible to be claimed by users once the workspace's agent is a) running and b) all of its startup
scripts have completed.

If a prebuilt workspace is not eligible, view its agent logs to diagnose the problem.

## CoderdUnprovisionedPrebuiltWorkspaces

The number of running prebuilt workspaces is lower than the desired instances. This could be for several reasons,
ordered by likehood:

### Experiment/License

The prebuilds feature is currently gated behind an experiment *and* a premium license.

Ensure that the prebuilds experiment is enabled with `CODER_EXPERIMENTS=workspace-prebuilds`, and that you have a premium
license added.

### Preset Validation Issue

Templates which have prebuilds configured will require a configured preset defined, with ALL of the required parameters
set in the preset. If any of these are missing, or any of the parameters - as defined - fail validation, then the prebuilds
subsystem will refuse to attempt a workspace build.

Consult the coderd logs for more information; look out for errors or warnings from the prebuilds subsystem.

### Template Misconfiguration or Error

Prebuilt workspaces cannot be provisioned due to some issue at `terraform apply`-time. This could be due to misconfigured
cloud resources, improper authorization, or any number of other issues.

Visit the Workspaces page, change the search term to `owner:prebuilds`, and view on the previously failed builds. The
error will likely be quite obvious.

### Provisioner Latency

If your provisioners are overloaded and cannot process provisioner jobs quickly enough, prebuilt workspaces may be affected.
There is no prioritization at present for prebuilt workspace jobs.

Ensure your provisioners are appropriately resources (i.e. you have enough instances) to handle the concurrent build demand.

### Use of Workspace Tags

If you are using `coder_workspace_tags` ([docs](https://coder.com/docs/admin/templates/extending-templates/workspace-tags))
in your template, chances are you do not have any provisioners running or they are under-resourced (see **Provisioner Latency**).

Ensure your running provisioners are configured with your desired tags.

### Reconciliation Loop Issue

The prebuilds subsystem runs a _reconciliation loop_ which monitors the state of prebuilt workspaces to ensure the desired
number of instances are present at all times. Workspace Prebuilds is currently a BETA feature and so there could be a bug
in this _reconciliation loop_, which should be reported to Coder.

Examine your coderd logs for any errors or warnings relating to prebuilds.