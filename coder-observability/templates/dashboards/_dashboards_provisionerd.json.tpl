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
          "expr": "sum(coderd_provisionerd_num_daemons)",
          "hide": false,
          "instant": true,
          "legendFormat": "Capacity",
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
        "content": "The maximum number of simultaneous builds is equivalent to the number of `provisionerd` daemons running.\n\nThe \"Capacity\" panel shows the how many simultaneous builds are possible.",
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
          "fieldMinMax": false,
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "text",
                "value": null
              }
            ]
          },
          "unit": "s"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 7,
        "w": 6,
        "x": 0,
        "y": 7
      },
      "id": 23,
      "options": {
        "colorMode": "value",
        "graphMode": "none",
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
          "expr": "histogram_quantile(0.5, sum by(le) (rate(coderd_provisionerd_job_timings_seconds_bucket[$__range])))",
          "hide": false,
          "instant": true,
          "legendFormat": "Median",
          "range": false,
          "refId": "B"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "prometheus"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "histogram_quantile(0.9, sum by(le) (rate(coderd_provisionerd_job_timings_seconds_bucket[$__range])))",
          "hide": false,
          "instant": true,
          "legendFormat": "90th Percentile",
          "range": false,
          "refId": "A"
        }
      ],
      "title": "Build Times",
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
        "y": 7
      },
      "id": 24,
      "options": {
        "code": {
          "language": "plaintext",
          "showLineNumbers": false,
          "showMiniMap": false
        },
        "content": "TODO",
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
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "bars",
            "fillOpacity": 100,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "normal"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "decimals": 0,
          "fieldMinMax": false,
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "text",
                "value": null
              }
            ]
          },
          "unit": "short"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byName",
              "options": "failed"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "orange",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Failure"
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "success"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "green",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Success"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 7,
        "w": 6,
        "x": 12,
        "y": 7
      },
      "id": 25,
      "interval": "1h",
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "multi",
          "sort": "none"
        }
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
          "expr": "sum by (status) (increase(coderd_provisionerd_job_timings_seconds_count[$__interval]))",
          "hide": false,
          "instant": false,
          "interval": "1h",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Build Count Per Hour",
      "type": "timeseries"
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
        "y": 7
      },
      "id": 26,
      "options": {
        "code": {
          "language": "plaintext",
          "showLineNumbers": false,
          "showMiniMap": false
        },
        "content": "_NOTE: this will not show the current hour._",
        "mode": "markdown"
      },
      "pluginVersion": "10.4.0",
      "transparent": true,
      "type": "text"
    },
    {
      "datasource": {
        "type": "loki",
        "uid": "loki"
      },
      "gridPos": {
        "h": 18,
        "w": 24,
        "x": 0,
        "y": 14
      },
      "id": 27,
      "options": {
        "dedupStrategy": "exact",
        "enableLogDetails": true,
        "prettifyLogMessage": false,
        "showCommonLabels": false,
        "showLabels": false,
        "showTime": true,
        "sortOrder": "Descending",
        "wrapLogMessage": false
      },
      "targets": [
        {
          "datasource": {
            "type": "loki",
            "uid": "loki"
          },
          "editorMode": "code",
          "expr": "{pod=~\"coder-provisioner.*\"}",
          "queryType": "range",
          "refId": "A"
        }
      ],
      "title": "Logs",
      "type": "logs"
    }
  ],
  "refresh": "30s",
  "schemaVersion": 39,
  "tags": [],
  "templating": {
    "list": []
  },
  "time": {
    "from": "now-24h",
    "to": "now"
  },
  "timepicker": {},
  "timezone": "browser",
  "title": "Provisioners",
  "uid": "provisionerd",
  "version": 8,
  "weekStart": ""
}
{{ end }}