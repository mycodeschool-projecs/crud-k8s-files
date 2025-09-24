# STEP 3: templates/_helpers.tpl - Helper Templates
# ================================================
# This file contains reusable template functions that generate common labels,
# names, and other repetitive template code. It follows Helm best practices.

{{/*
Expand the name of the chart.
This generates a name based on the chart name or nameOverride value.
Usage: {{ include "crud-proj.name" . }}
*/}}
{{- define "crud-proj.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
This combines the release name with the chart name to create unique resource names.
If fullnameOverride is set, use that instead.
Usage: {{ include "crud-proj.fullname" . }}
*/}}
{{- define "crud-proj.fullname" -}}
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
Usage: {{ include "crud-proj.chart" . }}
*/}}
{{- define "crud-proj.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels that should be applied to all resources.
These labels help with resource identification and management.
Usage: {{ include "crud-proj.labels" . | nindent 4 }}
*/}}
{{- define "crud-proj.labels" -}}
helm.sh/chart: {{ include "crud-proj.chart" . }}
{{ include "crud-proj.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels that are used to match pods to services.
These labels must be stable and not change between upgrades.
Usage: {{ include "crud-proj.selectorLabels" . }}
*/}}
{{- define "crud-proj.selectorLabels" -}}
app.kubernetes.io/name: {{ include "crud-proj.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Component-specific labels for MySQL
Usage: {{ include "crud-proj.mysql.labels" . | nindent 4 }}
*/}}
{{- define "crud-proj.mysql.labels" -}}
{{ include "crud-proj.labels" . }}
app.kubernetes.io/component: mysql
{{- end }}

{{/*
Generate the image name with registry prefix if specified
Usage: {{ include "crud-proj.image" (dict "image" .Values.images "global" .Values.global) }}
*/}}
{{- define "crud-proj.image" -}}
{{- if .global.imageRegistry -}}
{{- printf "%s/%s:%s" .global.imageRegistry .image.repository .image.tag -}}
{{- else -}}
{{- printf "%s:%s" .image.repository .image.tag -}}
{{- end -}}
{{- end }}

{{/*
MySQL selector labels
Usage: {{ include "crud-proj.mysql.selectorLabels" . }}
*/}}
{{- define "crud-proj.mysql.selectorLabels" -}}
{{ include "crud-proj.selectorLabels" . }}
app.kubernetes.io/component: mysql
{{- end }}

{{/*
Component-specific labels for Command Service
Usage: {{ include "crud-proj.command-service.labels" . | nindent 4 }}
*/}}
{{- define "crud-proj.command-service.labels" -}}
{{ include "crud-proj.labels" . }}
app.kubernetes.io/component: command-service
{{- end }}

{{/*
Command Service selector labels
Usage: {{ include "crud-proj.command-service.selectorLabels" . }}
*/}}
{{- define "crud-proj.command-service.selectorLabels" -}}
{{ include "crud-proj.selectorLabels" . }}
app.kubernetes.io/component: command-service
{{- end }}