#!/bin/bash

# Script to create a comprehensive Helm chart structure
# Usage: ./create-helm-chart-structure.sh [chart-name]

CHART_NAME=${1:-"crud-app-chart"}

echo "Creating Helm chart structure: $CHART_NAME"

# Create main chart directory
mkdir -p "$CHART_NAME"
cd "$CHART_NAME"

# Create main chart files
touch Chart.yaml
touch values.yaml

# Create templates directory and subdirectories
mkdir -p templates
touch templates/_helpers.tpl
touch templates/configmap.yaml
touch templates/secrets.yaml
touch templates/storageclass.yaml
touch templates/pvc.yaml
touch templates/ingress.yaml

# MySQL components
mkdir -p templates/mysql
touch templates/mysql/statefulset.yaml
touch templates/mysql/service.yaml

# Auth service
mkdir -p templates/auth-service
touch templates/auth-service/deployment.yaml
touch templates/auth-service/service.yaml

# Command service
mkdir -p templates/command-service
touch templates/command-service/deployment.yaml
touch templates/command-service/service.yaml

# React app
mkdir -p templates/react-app
touch templates/react-app/deployment.yaml
touch templates/react-app/service.yaml

# Elasticsearch
mkdir -p templates/elasticsearch
touch templates/elasticsearch/statefulset.yaml
touch templates/elasticsearch/service.yaml

# Kibana
mkdir -p templates/kibana
touch templates/kibana/deployment.yaml
touch templates/kibana/service.yaml

# Logstash
mkdir -p templates/logstash
touch templates/logstash/deployment.yaml
touch templates/logstash/service.yaml

# Zipkin
mkdir -p templates/zipkin
touch templates/zipkin/deployment.yaml
touch templates/zipkin/service.yaml

# Prometheus
mkdir -p templates/prometheus
touch templates/prometheus/deployment.yaml
touch templates/prometheus/service.yaml

# Grafana
mkdir -p templates/grafana
touch templates/grafana/deployment.yaml
touch templates/grafana/service.yaml

# Jobs directory
mkdir -p templates/jobs
touch templates/jobs/kibana-setup.yaml

echo "✅ Helm chart structure created successfully!"
echo ""
echo "Directory structure:"
find . -type d | sort | sed 's/^/  /'
echo ""
echo "Files created:"
find . -type f | sort | sed 's/^/  /'
echo ""
echo "Next steps:"
echo "1. Edit Chart.yaml with your chart metadata"
echo "2. Configure values.yaml with default values"
echo "3. Populate the template files with your Kubernetes manifests"
echo "4. Use 'helm install <release-name> ./$CHART_NAME' to deploy"