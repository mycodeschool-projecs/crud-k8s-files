{{/* Common metadata block for resources */}}
{{- define "app.metadata" -}}
name: {{ .Values.appName | default "ingress" }}
namespace: {{ .Values.namespace }}
{{- end }}
