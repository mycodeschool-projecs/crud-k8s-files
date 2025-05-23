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

The helmfile is configured with a default timeout of 10 minutes, which gives
pods extra time to become Ready. If your cluster is particularly slow you can
override this with the `--timeout` flag:

```bash
helmfile --timeout 15m sync
```

By default all charts install into the `default` namespace and use the `local-path` storage class. These can be adjusted by overriding the `namespace` and `storageClass` values for each release.

```bash
helmfile -e myenv sync
```

## Performance

All charts now request more CPU and memory by default (200m CPU / 256Mi memory). Limits are set to 400m CPU / 512Mi memory, and Elasticsearch uses 1Gi memory. Container images use `IfNotPresent` pull policy to avoid unnecessary downloads. Override these values in each chart if your cluster has different resource requirements.

## Charts

See the `charts/` directory for individual chart values.
