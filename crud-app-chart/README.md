# CRUD Application Helm Chart

## Overview

This Helm chart deploys a comprehensive CRUD (Create, Read, Update, Delete) application with a complete monitoring and logging stack on Kubernetes. The application consists of microservices built with Spring Boot for the backend, a React frontend, and a MySQL database, along with an observability stack including ELK (Elasticsearch, Logstash, Kibana), Prometheus, Grafana, and Zipkin.

## Chart Structure

```
crud-app-chart/
├── Chart.yaml             # Chart metadata
├── values.yaml            # Default configuration values
└── templates/             # Kubernetes resource templates
    ├── _helpers.tpl       # Helper functions
    ├── configmap.yaml     # ConfigMap resources
    ├── secrets.yaml       # Secret resources
    ├── pvc.yaml           # Persistent Volume Claims
    ├── storageclass.yaml  # Storage Class definition
    ├── ingress.yaml       # Ingress configuration
    ├── auth-service/      # Authentication service resources
    ├── command-service/   # Command service resources
    ├── react-app/         # Frontend application resources
    ├── mysql/             # Database resources
    ├── elasticsearch/     # Elasticsearch resources
    ├── kibana/            # Kibana resources
    ├── logstash/          # Logstash resources
    ├── prometheus/        # Prometheus resources
    ├── grafana/           # Grafana resources
    ├── zipkin/            # Zipkin resources
    └── jobs/              # Initialization jobs
```

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- PV provisioner support in the underlying infrastructure
- LoadBalancer support or Ingress Controller installed

## Installation

### Add the repository

```bash
helm repo add myrepo https://github.com/yourusername/crud-app-chart
helm repo update
```

### Install the chart

```bash
helm install my-crud-app myrepo/crud-app
```

Or install from local directory:

```bash
helm install my-crud-app ./crud-app-chart
```

### Upgrade an existing installation

```bash
helm upgrade my-crud-app myrepo/crud-app
```

## Architecture

The chart deploys the following components:

### Core Application

- **Auth Service**: Spring Boot authentication service
- **Command Service**: Spring Boot command service
- **React App**: Frontend application
- **MySQL**: Database backend using StatefulSet

### Observability Stack

- **ELK Stack**:
  - Elasticsearch: For log storage and indexing
  - Logstash: For log processing
  - Kibana: For log visualization
- **Prometheus & Grafana**: For metrics collection and visualization
- **Zipkin**: For distributed tracing

## Configuration

The following table lists the configurable parameters of the chart and their default values. See the `values.yaml` file for more details.

### Global Settings

| Parameter | Description | Default |
|-----------|-------------|---------|
| `global.namespace` | Target Kubernetes namespace | `default` |
| `global.storageClass` | Storage class for persistent volumes | `local-path` |
| `global.imageRegistry` | Global image registry prefix | `""` |
| `global.imagePullSecrets` | Image pull secrets | `[]` |

### Feature Flags

| Parameter | Description | Default |
|-----------|-------------|---------|
| `features.monitoring` | Enable Prometheus + Grafana | `true` |
| `features.logging` | Enable ELK stack | `true` |
| `features.tracing` | Enable Zipkin | `true` |
| `features.database` | Enable MySQL | `true` |

### Application Images

| Parameter | Description | Default |
|-----------|-------------|---------|
| `images.authService.repository` | Auth service image repository | `mycodeschool/crud-auth-api` |
| `images.authService.tag` | Auth service image tag | `29.03.2025.16.35.52` |
| `images.commandService.repository` | Command service image repository | `mycodeschool/crud-command-api` |
| `images.commandService.tag` | Command service image tag | `29.03.2025.16.35.20` |
| `images.reactApp.repository` | React app image repository | `mycodeschool/crud-client-api` |
| `images.reactApp.tag` | React app image tag | `16.03.2025.08.35.19` |

### MySQL Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `mysql.enabled` | Enable MySQL deployment | `true` |
| `mysql.database` | Database name | `testdb` |
| `mysql.user` | Database user | `testuser` |
| `mysql.password` | Database password | `testpass` |
| `mysql.rootPassword` | Root password | `testpass` |
| `mysql.storage.size` | Persistent volume size | `5Gi` |

### Ingress Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `ingress.enabled` | Enable ingress | `true` |
| `ingress.className` | Ingress class name | `nginx` |
| `ingress.paths.reactApp` | Path for React app | `/` |
| `ingress.paths.authService` | Path for Auth service | `/api` |
| `ingress.paths.commandService` | Path for Command service | `/ms1` |

## Usage Examples

### Basic Installation

```bash
helm install my-crud-app ./crud-app-chart
```

### Custom Configuration

Create a custom values file:

```yaml
# custom-values.yaml
global:
  namespace: crud-app
  storageClass: standard

mysql:
  password: mySecurePassword
  rootPassword: mySecureRootPassword
  storage:
    size: 10Gi

ingress:
  hosts:
    - crud-app.example.com
```

Install with custom values:

```bash
helm install my-crud-app ./crud-app-chart -f custom-values.yaml
```

### Disable Components

To disable the monitoring stack:

```bash
helm install my-crud-app ./crud-app-chart --set features.monitoring=false
```

## Accessing the Application

After the chart is deployed, you can access the application at:

- Frontend: http://your-ingress-host/
- Auth API: http://your-ingress-host/api
- Command API: http://your-ingress-host/ms1
- Kibana: http://your-ingress-host/kibana
- Grafana: http://your-ingress-host/grafana
- Zipkin: http://your-ingress-host/zipkin

## Uninstalling the Chart

```bash
helm uninstall my-crud-app
```

## Troubleshooting

### Common Issues

1. **PVC Creation Failure**: Ensure your Kubernetes cluster has a storage provisioner that supports the specified storage class.
2. **Ingress Not Working**: Verify that an Ingress Controller is installed in your cluster.
3. **Services Not Starting**: Check the logs of the pods to identify any startup issues.

### Viewing Logs

```bash
kubectl logs -l app.kubernetes.io/name=crud-app,app.kubernetes.io/component=auth-service
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This chart is licensed under the MIT License - see the LICENSE file for details.