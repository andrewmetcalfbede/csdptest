{{/* vim: set filetype=mustache: */}}

{{/*
Cronjob Name
*/}}
{{- define "dashboard-cronjob.name" -}}
{{- required "A Valid .Values.cronjob.name is required!" .Values.cronjob.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Cronjob Schedule
*/}}
{{- define "dashboard-cronjob.schedule" -}}
{{ default "" .Values.cronjob.schedule | quote }}
{{- end -}}

{{/*
Cronjob Labels
*/}}
{{- define "dashboard-cronjob.labels" -}}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/name: {{ include "dashboard-cronjob.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Metadata
*/}}
{{- define "dashboard-cronjob.metadata" -}}
name: {{ include "dashboard-cronjob.name" . }}
namespace: {{ .Release.Namespace }}
labels:
  {{- include "dashboard-cronjob.labels" . | nindent 4 }}
annotations:
  maintainer: {{ default "Bede" .Values.cronjob.maintainer }}
  slackChannel: {{ default "guild-fabric" .Values.cronjob.slackChannel }}
  gitRepo: {{ default "http://github.com/bedegaming" .Values.cronjob.repository }}
{{- end -}}

{{/*
Image Name in the form <repo>/<image_name>:<image_tag>
*/}}
{{- define "dashboard-cronjob.image" -}}
{{- $repo := required ".Values.container.repository is required!" .Values.container.repository -}}
{{- $name := required ".Values.container.imageName is required!" .Values.container.imageName -}}
{{- $version := default .Chart.AppVersion .Values.cronjob.version -}}
{{- printf "%s/%s:%s" $repo $name $version -}}
{{- end -}}