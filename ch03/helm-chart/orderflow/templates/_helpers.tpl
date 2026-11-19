{{- define "orderflow.commonLabels" -}}
app.kubernetes.io/part-of: orderflow
app.kubernetes.io/managed-by: helm
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version }}
{{- end }}

{{- define "orderflow.configData" -}}
{{- $ns := .Release.Namespace }}
{{- $dbHost := printf "orderflow-db.%s.svc.cluster.local" $ns }}
{{- $cacheHost := printf "orderflow-cache.%s.svc.cluster.local" $ns }}
PODINFO_LEVEL: {{ .Values.orderService.config.level | quote }}
PODINFO_UI_MESSAGE: {{ .Values.orderService.config.uiMessage | quote }}
DB_HOST: {{ $dbHost | quote }}
CACHE_HOST: {{ $cacheHost | quote }}
{{- end }}

{{- define "orderflow.configHash" -}}
{{- include "orderflow.configData" . | sha256sum | trunc 8 -}}
{{- end }}
