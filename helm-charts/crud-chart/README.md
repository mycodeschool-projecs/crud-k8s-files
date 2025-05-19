# CRUD Chart

This chart packages the Kubernetes manifests from `k8s-files-raw` into a Helm chart.

## Usage

```sh
helm install crud-release ./crud-chart --namespace default
```

Set the namespace with the `namespace` value if required:

```sh
helm install crud-release ./crud-chart --set namespace=custom
```
