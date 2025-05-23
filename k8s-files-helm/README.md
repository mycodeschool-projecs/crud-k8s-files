# Helmfile Deployment

This directory contains multiple Helm charts that compose the CRUD application stack. Each release is orchestrated via `helmfile.yaml`.

## Prerequisites

* [Helm](https://helm.sh/) installed
* [helmfile](https://github.com/helmfile/helmfile) installed
* A Kubernetes cluster with persistent storage support

## Installation

```bash
helmfile sync
```

By default all charts install into the `default` namespace and use the `local-path` storage class. These can be adjusted by overriding the `namespace` and `storageClass` values for each release.

```bash
helmfile -e myenv sync
```

## Charts

See the `charts/` directory for individual chart values.

Environment variables for each deployment can be supplied directly via the
`containerEnvVars` list or loaded from existing ConfigMaps and Secrets using
`containerEnvFrom`. This allows an entire ConfigMap or Secret to be exposed to
the Pod without listing each variable individually.
