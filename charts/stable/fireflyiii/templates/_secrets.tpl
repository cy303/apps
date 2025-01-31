{{/* Define the secrets */}}
{{- define "fireflyiii.secrets" -}}

---
apiVersion: v1
kind: Secret
metadata:
  name: {{ .Release.Name }}-dbcreds
{{- $previous := lookup "v1" "Secret" .Release.Namespace ( ( printf "%v-%v"  .Release.Name "dbcreds" ) | quote ) }}
{{- $dbPass := "" }}
data:
{{- if $previous }}
  {{- $dbPass = ( index $previous.data "postgresql-password" ) | b64dec  }}
  postgresql-password: {{ ( index $previous.data "postgresql-password" ) }}
  postgresql-postgres-password: {{ ( index $previous.data "postgresql-postgres-password" ) }}
{{- else }}
  {{- $dbPass = randAlphaNum 50 }}
  postgresql-password: {{ $dbPass | b64enc | quote }}
  postgresql-postgres-password: {{ randAlphaNum 50 | b64enc | quote }}
{{- end }}
  url: {{ ( printf "%v%v:%v@%v-%v:%v/%v" "postgresql://" .Values.postgresql.postgresqlUsername $dbPass .Release.Name "postgresql" "5432" .Values.postgresql.postgresqlDatabase  ) | b64enc | quote }}
  postgresql_host: {{ ( printf "%v-%v" .Release.Name "postgresql" ) | b64enc | quote }}
type: Opaque

{{- end -}}
