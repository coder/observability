{{ define "coderd-dashboard.json" }}
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
  "id": 30,
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
                "color": "red",
                "value": null
              },
              {
                "color": "green",
                "value": 1
              }
            ]
          }
        },
        "overrides": [
          {
            "matcher": {
              "id": "byName",
              "options": "Down"
            },
            "properties": [
              {
                "id": "thresholds",
                "value": {
                  "mode": "absolute",
                  "steps": [
                    {
                      "color": "green",
                      "value": null
                    },
                    {
                      "color": "red",
                      "value": 1
                    }
                  ]
                }
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 6,
        "w": 8,
        "x": 0,
        "y": 0
      },
      "id": 10,
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
          "expr": "count(up{{- $coderd }} == 1) or vector(0)",
          "instant": true,
          "legendFormat": "Up",
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
          "expr": "count(up{{- $coderd }} == 0) or vector(0)",
          "hide": false,
          "instant": true,
          "legendFormat": "Down",
          "range": false,
          "refId": "B"
        }
      ],
      "title": "Coder Replicas",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "prometheus"
      },
      "description": "",
      "gridPos": {
        "h": 6,
        "w": 16,
        "x": 8,
        "y": 0
      },
      "id": 18,
      "options": {
        "code": {
          "language": "plaintext",
          "showLineNumbers": false,
          "showMiniMap": false
        },
        "content": "# coderd\n\nOne or more replicas are required to be running in order to serve the control-plane.\n\nSee [High Availability](https://coder.com/docs/v2/latest/admin/high-availability) for details on how to\nrun multiple `coderd` replicas.",
        "mode": "markdown"
      },
      "pluginVersion": "10.4.0",
      "type": "text",
      "transparent": true
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
        "h": 6,
        "w": 8,
        "x": 0,
        "y": 6
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
          "expr": "sum(coderd_provisionerd_num_daemons{{- $coderd -}})",
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
          "expr": "sum(coderd_provisionerd_num_daemons{{- $provisionerd -}})",
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
        "h": 6,
        "w": 16,
        "x": 8,
        "y": 6
      },
      "id": 20,
      "options": {
        "code": {
          "language": "plaintext",
          "showLineNumbers": false,
          "showMiniMap": false
        },
        "content": "## Provisioners\n\nProvisioners are responsible for building workspaces.\n\n`coderd` runs built-in provisioners by default. Control this with the `CODER_PROVISIONER_DAEMONS` environment variable or `--provisioner-daemons` flag.\n\nYou can also consider [External Provisioners](https://coder.com/docs/v2/latest/admin/provisioners). Running both built-in and external provisioners is perfectly valid.\nThe number of provisioners defines the maximum number of workspaces which can be built simultaneously.",
        "mode": "markdown"
      },
      "pluginVersion": "10.4.0",
      "type": "text",
      "transparent": true
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "prometheus"
      },
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
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          },
          "unit": "s"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byName",
              "options": "Errors"
            },
            "properties": [
              {
                "id": "unit",
                "value": "short"
              },
              {
                "id": "thresholds",
                "value": {
                  "mode": "absolute",
                  "steps": [
                    {
                      "color": "green",
                      "value": null
                    },
                    {
                      "color": "red",
                      "value": 1
                    }
                  ]
                }
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 3,
        "w": 6,
        "x": 0,
        "y": 12
      },
      "id": 16,
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "center",
        "orientation": "auto",
        "reduceOptions": {
          "calcs": [
            "mean"
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
          "expr": "quantile(0.5, coder_pubsub_send_latency_seconds)",
          "instant": false,
          "legendFormat": "Send",
          "range": true,
          "refId": "A"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "prometheus"
          },
          "editorMode": "code",
          "expr": "quantile(0.5, coder_pubsub_receive_latency_seconds)",
          "hide": false,
          "instant": false,
          "legendFormat": "Receive",
          "range": true,
          "refId": "B"
        }
      ],
      "title": "Pubsub Latency (Median)",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "prometheus"
      },
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
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          },
          "unit": "s"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byName",
              "options": "Errors"
            },
            "properties": [
              {
                "id": "unit",
                "value": "short"
              },
              {
                "id": "thresholds",
                "value": {
                  "mode": "absolute",
                  "steps": [
                    {
                      "color": "green",
                      "value": null
                    },
                    {
                      "color": "red",
                      "value": 1
                    }
                  ]
                }
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 6,
        "w": 2,
        "x": 6,
        "y": 12
      },
      "id": 22,
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "center",
        "orientation": "auto",
        "reduceOptions": {
          "calcs": [
            "mean"
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
          "expr": "(\n  sum(increase(coder_pubsub_latency_measure_errs_total[$__range]))\n  / count(coder_pubsub_latency_measure_errs_total)\n) or vector(0)",
          "hide": false,
          "instant": false,
          "legendFormat": "Errors",
          "range": true,
          "refId": "B"
        }
      ],
      "title": "Pubsub Errors",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "prometheus"
      },
      "description": "",
      "gridPos": {
        "h": 6,
        "w": 16,
        "x": 8,
        "y": 12
      },
      "id": 19,
      "options": {
        "code": {
          "language": "plaintext",
          "showLineNumbers": false,
          "showMiniMap": false
        },
        "content": "## Pubsub Latency\n\n`coderd` uses Postgres for passing messages between subcomponents for coordination and signalling;\nthis is called \"pubsub\" (or publish-subscribe).\n\nWe measure the amount of time messages take to be sent and received. Latencies higher than 500ms will likely lead to\nyour Coder deployment feeling sluggish. High latency is usually an indication that your Postgres server is under-resourced on CPU.\n\nBoth the median and the 90th percentile latencies are represented here. High values for median should be concerning,\nwhile the 90th percentile shows the outliers.",
        "mode": "markdown"
      },
      "pluginVersion": "10.4.0",
      "type": "text",
      "transparent": true
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "prometheus"
      },
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
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          },
          "unit": "s"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byName",
              "options": "Errors"
            },
            "properties": [
              {
                "id": "unit",
                "value": "short"
              },
              {
                "id": "thresholds",
                "value": {
                  "mode": "absolute",
                  "steps": [
                    {
                      "color": "green",
                      "value": null
                    },
                    {
                      "color": "red",
                      "value": 1
                    }
                  ]
                }
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 3,
        "w": 6,
        "x": 0,
        "y": 15
      },
      "id": 21,
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "center",
        "orientation": "auto",
        "reduceOptions": {
          "calcs": [
            "mean"
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
          "expr": "quantile(0.9, coder_pubsub_send_latency_seconds)",
          "instant": false,
          "legendFormat": "Send",
          "range": true,
          "refId": "A"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "prometheus"
          },
          "editorMode": "code",
          "expr": "quantile(0.9, coder_pubsub_receive_latency_seconds)",
          "hide": false,
          "instant": false,
          "legendFormat": "Receive",
          "range": true,
          "refId": "B"
        }
      ],
      "title": "Pubsub Latency (P90)",
      "type": "stat"
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
  "title": "Coder Control-plane",
  "uid": "coderd",
  "version": 1,
  "weekStart": ""
}
{{ end }}