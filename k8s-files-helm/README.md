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
