{{/*
TODO: add panel for build timings
      I was having some trouble getting a valid result from histogram queries for `coderd_provisionerd_job_timings_seconds_bucket`,
      for some reason
*/}}
{{ define "provisionerd-dashboard.json" }}
{{ $ns := .Release.Namespace }}
{{ $metrics := .Values.metrics.server.fullnameOverride }}
{{ $logs := .Values.logs.fullnameOverride }}
{{ $collector := .Values.collector.fullnameOverride }}
{{ $coderd := .Values.global.coder.coderdSelector }}
{{ $provisionerd := .Values.global.coder.provisionerdSelector }}
{
  "annotations": {
    "list": [
      {
        "builtIn": 1,
        "datasource": {
          "type": "grafana",
          "uid": "-- Grafana --"
        },
        "enable": true,
        "hide": true,
        "iconColor": "rgba(0, 211, 255, 1)",
        "name": "Annotations & Alerts",
        "target": {
          "limit": 100,
          "matchAny": false,
          "tags": [],
          "type": "dashboard"
        },
        "type": "dashboard"
      }
    ]
  },
  "editable": true,
  "fiscalYearStartMonth": 0,
  "graphTooltip": 0,
  "links": [],
  "panels": [
    {
      "datasource": {
        "type": "prometheus",
        "uid": "prometheus"
      },
      "description": "",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "text",
                "value": null
              },
              {
                "color": "green",
                "value": 1
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 7,
        "w": 6,
        "x": 0,
        "y": 0
      },
      "id": 17,
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "center",
        "orientation": "auto",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "textMode": "value_and_name",
        "wideLayout": false
      },
      "pluginVersion": "10.4.0",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "prometheus"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "sum(coderd_provisionerd_num_daemons{pod=~`coder.*`, pod!~`.*provisioner.*`})",
          "instant": true,
          "legendFormat": "Built-in",
          "range": false,
          "refId": "A"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "prometheus"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "sum(coderd_provisionerd_num_daemons{pod=~`coder-provisioner.*`})",
          "hide": false,
          "instant": true,
          "legendFormat": "External",
          "range": false,
          "refId": "B"
        }
      ],
      "title": "Provisioners",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "prometheus"
      },
      "description": "",
      "gridPos": {
        "h": 7,
        "w": 6,
        "x": 6,
        "y": 0
      },
      "id": 20,
      "options": {
        "code": {
          "language": "plaintext",
          "showLineNumbers": false,
          "showMiniMap": false
        },
        "content": "Provisioners are responsible for building workspaces.\n\n`coderd` runs built-in provisioners by default. Control this with the `CODER_PROVISIONER_DAEMONS` environment variable or `--provisioner-daemons` flag.\n\nYou can also consider [External Provisioners](https://coder.com/docs/v2/latest/admin/provisioners). Running both built-in and external provisioners is perfectly valid,\nalthough dedicated (external) provisioners will generally give the best build performance.",
        "mode": "markdown"
      },
      "pluginVersion": "10.4.0",
      "transparent": true,
      "type": "text"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "prometheus"
      },
      "description": "",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "text",
                "value": null
              },
              {
                "color": "green",
                "value": 1
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 7,
        "w": 6,
        "x": 12,
        "y": 0
      },
      "id": 21,
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "center",
        "orientation": "auto",
        "reduceOptions": {
          "calcs": [
            "last"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "textMode": "auto",
        "wideLayout": true
      },
      "pluginVersion": "10.4.0",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "prometheus"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "(sum(coderd_provisionerd_jobs_current) > 0) or vector(0)",
          "instant": false,
          "legendFormat": "Current",
          "range": true,
          "refId": "A"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "prometheus"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "max_over_time(\n    sum(sum_over_time(coderd_provisionerd_jobs_current[1m]))[$__range:]\n)",
          "hide": false,
          "instant": true,
          "legendFormat": "Max Concurrent",
          "range": false,
          "refId": "B"
        }
      ],
      "title": "Builds",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "prometheus"
      },
      "description": "",
      "gridPos": {
        "h": 7,
        "w": 6,
        "x": 18,
        "y": 0
      },
      "id": 22,
      "options": {
        "code": {
          "language": "plaintext",
          "showLineNumbers": false,
          "showMiniMap": false
        },
        "content": "The maximum number of simultaneous builds is equivalent to the number of `provisionerd` daemons running.\n\nThe \"Max Concurrent\" panel shows the highest number of simultaneous builds within the current time range.",
        "mode": "markdown"
      },
      "pluginVersion": "10.4.0",
      "transparent": true,
      "type": "text"
    }
  ],
  "refresh": "30s",
  "schemaVersion": 39,
  "tags": [],
  "templating": {
    "list": []
  },
  "time": {
    "from": "now-1h",
    "to": "now"
  },
  "timepicker": {},
  "timezone": "browser",
  "title": "Provisioners",
  "uid": "provisionerd",
  "version": 2,
  "weekStart": ""
}
{{ end }}