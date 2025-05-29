# STEP 3: templates/_helpers.tpl - Helper Templates
# ================================================
# This file contains reusable template functions that generate common labels,
# names, and other repetitive template code. It follows Helm best practices.

{{/*
Expand the name of the chart.
This generates a name based on the chart name or nameOverride value.
Usage: {{ include "crud-app.name" . }}
*/}}
{{- define "crud-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
This combines the release name with the chart name to create unique resource names.
If fullnameOverride is set, use that instead.
Usage: {{ include "crud-app.fullname" . }}
*/}}
{{- define "crud-app.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
This is used in labels to identify which chart version deployed the resource.
Usage: {{ include "crud-app.chart" . }}
*/}}
{{- define "crud-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels that should be applied to all resources.
These labels help with resource identification and management.
Usage: {{ include "crud-app.labels" . | nindent 4 }}
*/}}
{{- define "crud-app.labels" -}}
helm.sh/chart: {{ include "crud-app.chart" . }}
{{ include "crud-app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels that are used to match pods to services.
These labels must be stable and not change between upgrades.
Usage: {{ include "crud-app.selectorLabels" . }}
*/}}
{{- define "crud-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "crud-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Component-specific labels for MySQL
Usage: {{ include "crud-app.mysql.labels" . | nindent 4 }}
*/}}
{{- define "crud-app.mysql.labels" -}}
{{ include "crud-app.labels" . }}
app.kubernetes.io/component: mysql
{{- end }}

{{/*
MySQL selector labels
Usage: {{ include "crud-app.mysql.selectorLabels" . }}
*/}}
{{- define "crud-app.mysql.selectorLabels" -}}
{{ include "crud-app.selectorLabels" . }}
app.kubernetes.io/component: mysql
{{- end }}

{{/*
Component-specific labels for Auth Service
Usage: {{ include "crud-app.auth-service.labels" . | nindent 4 }}
*/}}
{{- define "crud-app.auth-service.labels" -}}
{{ include "crud-app.labels" . }}
app.kubernetes.io/component: auth-service
{{- end }}

{{/*
Auth Service selector labels
Usage: {{ include "crud-app.auth-service.selectorLabels" . }}
*/}}
{{- define "crud-app.auth-service.selectorLabels" -}}
{{ include "crud-app.selectorLabels" . }}
app.kubernetes.io/component: auth-service
{{- end }}

{{/*
Component-specific labels for Command Service
Usage: {{ include "crud-app.command-service.labels" . | nindent 4 }}
*/}}
{{- define "crud-app.command-service.labels" -}}
{{ include "crud-app.labels" . }}
app.kubernetes.io/component: command-service
{{- end }}

{{/*
Command Service selector labels
Usage: {{ include "crud-app.command-service.selectorLabels" . }}
*/}}
{{- define "crud-app.command-service.selectorLabels" -}}
{{ include "crud-app.selectorLabels" . }}
app.kubernetes.io/component: command-service
{{- end }}

{{/*
Component-specific labels for React App
Usage: {{ include "crud-app.react-app.labels" . | nindent 4 }}
*/}}
{{- define "crud-app.react-app.labels" -}}
{{ include "crud-app.labels" . }}
app.kubernetes.io/component: react-app
{{- end }}

{{/*
React App selector labels
Usage: {{ include "crud-app.react-app.selectorLabels" . }}
*/}}
{{- define "crud-app.react-app.selectorLabels" -}}
{{ include "crud-app.selectorLabels" . }}
app.kubernetes.io/component: react-app
{{- end }}

{{/*
Component-specific labels for Elasticsearch
Usage: {{ include "crud-app.elasticsearch.labels" . | nindent 4 }}
*/}}
{{- define "crud-app.elasticsearch.labels" -}}
{{ include "crud-app.labels" . }}
app.kubernetes.io/component: elasticsearch
{{- end }}

{{/*
Elasticsearch selector labels
Usage: {{ include "crud-app.elasticsearch.selectorLabels" . }}
*/}}
{{- define "crud-app.elasticsearch.selectorLabels" -}}
{{ include "crud-app.selectorLabels" . }}
app.kubernetes.io/component: elasticsearch
{{- end }}

{{/*
Component-specific labels for Kibana
Usage: {{ include "crud-app.kibana.labels" . | nindent 4 }}
*/}}
{{- define "crud-app.kibana.labels" -}}
{{ include "crud-app.labels" . }}
app.kubernetes.io/component: kibana
{{- end }}

{{/*
Kibana selector labels
Usage: {{ include "crud-app.kibana.selectorLabels" . }}
*/}}
{{- define "crud-app.kibana.selectorLabels" -}}
{{ include "crud-app.selectorLabels" . }}
app.kubernetes.io/component: kibana
{{- end }}

{{/*
Component-specific labels for Logstash
Usage: {{ include "crud-app.logstash.labels" . | nindent 4 }}
*/}}
{{- define "crud-app.logstash.labels" -}}
{{ include "crud-app.labels" . }}
app.kubernetes.io/component: logstash
{{- end }}

{{/*
Logstash selector labels
Usage: {{ include "crud-app.logstash.selectorLabels" . }}
*/}}
{{- define "crud-app.logstash.selectorLabels" -}}
{{ include "crud-app.selectorLabels" . }}
app.kubernetes.io/component: logstash
{{- end }}

{{/*
Component-specific labels for Prometheus
Usage: {{ include "crud-app.prometheus.labels" . | nindent 4 }}
*/}}
{{- define "crud-app.prometheus.labels" -}}
{{ include "crud-app.labels" . }}
app.kubernetes.io/component: prometheus
{{- end }}

{{/*
Prometheus selector labels
Usage: {{ include "crud-app.prometheus.selectorLabels" . }}
*/}}
{{- define "crud-app.prometheus.selectorLabels" -}}
{{ include "crud-app.selectorLabels" . }}
app.kubernetes.io/component: prometheus
{{- end }}

{{/*
Component-specific labels for Grafana
Usage: {{ include "crud-app.grafana.labels" . | nindent 4 }}
*/}}
{{- define "crud-app.grafana.labels" -}}
{{ include "crud-app.labels" . }}
app.kubernetes.io/component: grafana
{{- end }}

{{/*
Grafana selector labels
Usage: {{ include "crud-app.grafana.selectorLabels" . }}
*/}}
{{- define "crud-app.grafana.selectorLabels" -}}
{{ include "crud-app.selectorLabels" . }}
app.kubernetes.io/component: grafana
{{- end }}

{{/*
Component-specific labels for Zipkin
Usage: {{ include "crud-app.zipkin.labels" . | nindent 4 }}
*/}}
{{- define "crud-app.zipkin.labels" -}}
{{ include "crud-app.labels" . }}
app.kubernetes.io/component: zipkin
{{- end }}

{{/*
Zipkin selector labels
Usage: {{ include "crud-app.zipkin.selectorLabels" . }}
*/}}
{{- define "crud-app.zipkin.selectorLabels" -}}
{{ include "crud-app.selectorLabels" . }}
app.kubernetes.io/component: zipkin
{{- end }}

{{/*
Generate the image name with registry prefix if specified
Usage: {{ include "crud-app.image" (dict "image" .Values.images.authService "global" .Values.global) }}
*/}}
{{- define "crud-app.image" -}}
{{- if .global.imageRegistry -}}
{{- printf "%s/%s:%s" .global.imageRegistry .image.repository .image.tag -}}
{{- else -}}
{{- printf "%s:%s" .image.repository .image.tag -}}
{{- end -}}
{{- end }}

{{/*
Generate MySQL connection string
Usage: {{ include "crud-app.mysql.connectionString" . }}
*/}}
{{- define "crud-app.mysql.connectionString" -}}
{{- printf "jdbc:mysql://%s-mysql:3306/%s" (include "crud-app.fullname" .) .Values.mysql.database -}}
{{- end }}

{{/*
Generate Elasticsearch URL
Usage: {{ include "crud-app.elasticsearch.url" . }}
*/}}
{{- define "crud-app.elasticsearch.url" -}}
{{- printf "http://%s-elasticsearch:9200" (include "crud-app.fullname" .) -}}
{{- end }}

{{/*
Generate Prometheus URL
Usage: {{ include "crud-app.prometheus.url" . }}
*/}}
{{- define "crud-app.prometheus.url" -}}
{{- printf "http://%s-prometheus:9090" (include "crud-app.fullname" .) -}}
{{- end }}

{{/*
Create the name of the service account to use
Usage: {{ include "crud-app.serviceAccountName" . }}
*/}}
{{- define "crud-app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "crud-app.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Determine if we should create storage class
Usage: {{ include "crud-app.createStorageClass" . }}
*/}}
{{- define "crud-app.createStorageClass" -}}
{{- if and .Values.global.storageClass (not (eq .Values.global.storageClass "default")) -}}
true
{{- else -}}
false
{{- end -}}
{{- end }}