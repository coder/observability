{{/*TODO: replace hardcoded pod names & namespaces*/}}
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
        "w": 6,
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
          "expr": "count(up{pod=~`coder.*`, pod!~`.*provisioner.*`} == 1) or vector(0)",
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
          "expr": "(count(up{pod=~`coder.*`, pod!~`.*provisioner.*`} == 0) or vector(0)) > 0",
          "hide": false,
          "instant": true,
          "legendFormat": "Down",
          "range": false,
          "refId": "B"
        }
      ],
      "title": "Replicas",
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
        "w": 6,
        "x": 6,
        "y": 0
      },
      "id": 18,
      "options": {
        "code": {
          "language": "plaintext",
          "showLineNumbers": false,
          "showMiniMap": false
        },
        "content": "One or more replicas are required to be running in order to serve the control-plane.\n\nSee [High Availability](https://coder.com/docs/v2/latest/admin/high-availability) for details on how to\nrun multiple `coderd` replicas.",
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
                "color": "green",
                "value": null
              },
              {
                "color": "#EAB839",
                "value": 0.9
              },
              {
                "color": "red",
                "value": 1
              }
            ]
          },
          "unit": "percentunit"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byName",
              "options": "Enabled"
            },
            "properties": [
              {
                "id": "mappings",
                "value": [
                  {
                    "options": {
                      "0": {
                        "index": 1,
                        "text": "No"
                      },
                      "1": {
                        "index": 0,
                        "text": "Yes"
                      }
                    },
                    "type": "value"
                  },
                  {
                    "options": {
                      "result": {
                        "color": "orange",
                        "index": 2,
                        "text": "Unknown"
                      }
                    },
                    "type": "special"
                  }
                ]
              },
              {
                "id": "thresholds",
                "value": {
                  "mode": "absolute",
                  "steps": [
                    {
                      "color": "text",
                      "value": null
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
        "w": 6,
        "x": 12,
        "y": 0
      },
      "id": 32,
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
          "expr": "max(coderd_license_user_limit_enabled)",
          "instant": true,
          "legendFormat": "Enabled",
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
          "expr": "(\n  max(coderd_license_active_users) / max(coderd_license_limit_users)\n) > 0",
          "hide": false,
          "instant": false,
          "legendFormat": "Usage",
          "range": true,
          "refId": "B"
        }
      ],
      "title": "Enterprise License",
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
        "w": 6,
        "x": 18,
        "y": 0
      },
      "id": 33,
      "options": {
        "code": {
          "language": "plaintext",
          "showLineNumbers": false,
          "showMiniMap": false
        },
        "content": "If you would like to try Coder's [Enterprise features](https://coder.com/docs/v2/latest/enterprise), you can [request a trial license](https://coder.com/docs/v2/latest/faqs#how-do-i-add-an-enterprise-license).",
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
            "showPoints": "never",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
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
          },
          "unit": "s"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/(Requested|Limit)/"
            },
            "properties": [
              {
                "id": "custom.lineStyle",
                "value": {
                  "dash": [
                    0,
                    10
                  ],
                  "fill": "dot"
                }
              },
              {
                "id": "custom.fillOpacity",
                "value": 5
              },
              {
                "id": "custom.drawStyle",
                "value": "line"
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "Requested"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "green",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "Limit"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "orange",
                  "mode": "fixed"
                }
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 6,
        "w": 6,
        "x": 0,
        "y": 6
      },
      "id": 25,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "single",
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
          "expr": "sum by (pod) (rate(container_cpu_usage_seconds_total{pod=~`coder.*`, pod!~`.*provisioner.*`}[$__rate_interval]))",
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "prometheus"
          },
          "editorMode": "code",
          "expr": "max(kube_pod_container_resource_limits{pod=~`coder.*`, pod!~`.*provisioner.*`, resource=\"cpu\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "Limit",
          "range": true,
          "refId": "C"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "prometheus"
          },
          "editorMode": "code",
          "expr": "max(kube_pod_container_resource_requests{pod=~`coder.*`, pod!~`.*provisioner.*`, resource=\"cpu\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "Requested",
          "range": true,
          "refId": "B"
        }
      ],
      "title": "CPU Usage Seconds",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "prometheus"
      },
      "description": "",
      "gridPos": {
        "h": 6,
        "w": 6,
        "x": 6,
        "y": 6
      },
      "id": 26,
      "options": {
        "code": {
          "language": "plaintext",
          "showLineNumbers": false,
          "showMiniMap": false
        },
        "content": "The cumulative CPU used per core-second. If `coderd` was using a full CPU core, that would be represented as 1 second.\n\nRequests & limits are shown if set.",
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
            "fixedColor": "red",
            "mode": "shades"
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
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "decimals": 0,
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
          },
          "unit": "short"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byName",
              "options": "Requested"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "green",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "Limit"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "red",
                  "mode": "fixed"
                }
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 6,
        "w": 4,
        "x": 12,
        "y": 6
      },
      "id": 30,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "single",
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
          "expr": "sum by (reason) (\n  count_over_time(kube_pod_container_status_terminated_reason{pod=~`coder.*`, pod!~`.*provisioner.*`, namespace=\"coder\"}[$__interval])\n)",
          "hide": false,
          "instant": false,
          "legendFormat": {{ printf "{{reason}}" | quote }},
          "range": true,
          "refId": "C"
        }
      ],
      "title": "Terminations",
      "type": "timeseries"
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
          "decimals": 0,
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
                "value": 0.0001
              }
            ]
          },
          "unit": "short"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 6,
        "w": 2,
        "x": 16,
        "y": 6
      },
      "id": 34,
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
          "exemplar": false,
          "expr": "sum(increase(kube_pod_container_status_restarts_total{pod=~\"coder.*\", pod!~\".*provisioner.*\", namespace=\"coder\"}[$__range]))",
          "hide": false,
          "instant": true,
          "legendFormat": "__auto",
          "range": false,
          "refId": "B"
        }
      ],
      "title": "Restarts",
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
        "w": 6,
        "x": 18,
        "y": 6
      },
      "id": 31,
      "options": {
        "code": {
          "language": "plaintext",
          "showLineNumbers": false,
          "showMiniMap": false
        },
        "content": "Pods can be terminated for several reasons:\n- `OOMKilled`: pod exceeded its defined memory limit or was terminated by the OS for using excessive memory (if no limit defined)\n- `Error`: usually attributeable to a configuration problem\n- `Evicted`: pod has been evicted from node for overusing resources and will be rescheduled on another node is possible",
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
            "showPoints": "never",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
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
          },
          "unit": "bytes"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/(Requested|Limit)/"
            },
            "properties": [
              {
                "id": "custom.lineStyle",
                "value": {
                  "dash": [
                    0,
                    10
                  ],
                  "fill": "dot"
                }
              },
              {
                "id": "custom.fillOpacity",
                "value": 5
              },
              {
                "id": "custom.drawStyle",
                "value": "line"
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "Requested"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "green",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "Limit"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "orange",
                  "mode": "fixed"
                }
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 6,
        "w": 6,
        "x": 0,
        "y": 12
      },
      "id": 29,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "single",
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
          "expr": "max by (pod) (container_memory_working_set_bytes{pod=~`coder.*`, pod!~`.*provisioner.*`})",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "prometheus"
          },
          "editorMode": "code",
          "expr": "max(kube_pod_container_resource_limits{pod=~`coder.*`, pod!~`.*provisioner.*`, resource=\"memory\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "Limit",
          "range": true,
          "refId": "C"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "prometheus"
          },
          "editorMode": "code",
          "expr": "max(kube_pod_container_resource_requests{pod=~`coder.*`, pod!~`.*provisioner.*`, resource=\"memory\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "Requested",
          "range": true,
          "refId": "B"
        }
      ],
      "title": "RAM Usage",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "prometheus"
      },
      "description": "",
      "gridPos": {
        "h": 6,
        "w": 6,
        "x": 6,
        "y": 12
      },
      "id": 28,
      "options": {
        "code": {
          "language": "plaintext",
          "showLineNumbers": false,
          "showMiniMap": false
        },
        "content": "This shows the total memory used by each `coderd` container; it is the same metric which the [OOM killer](https://www.kernel.org/doc/gorman/html/understand/understand016.html) uses.\n\nRequests & limits are shown if set.",
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
                "color": "orange",
                "value": 100
              },
              {
                "color": "red",
                "value": 500
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
        "w": 4,
        "x": 12,
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
        "x": 16,
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
        "w": 6,
        "x": 18,
        "y": 12
      },
      "id": 19,
      "options": {
        "code": {
          "language": "plaintext",
          "showLineNumbers": false,
          "showMiniMap": false
        },
        "content": "`coderd` uses Postgres for passing messages between subcomponents for coordination and signalling;\nthis is called \"pubsub\" (or publish-subscribe).\n\nWe measure the time for messages to be sent and received. Latencies higher than 500ms will likely lead to\nyour Coder deployment feeling sluggish. High latency is usually an indication that your Postgres server is under-resourced on CPU.\n\nHigh values for median should be concerning,\nwhile the 90th percentile shows the outliers.",
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
                "color": "orange",
                "value": 100
              },
              {
                "color": "red",
                "value": 500
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
        "w": 4,
        "x": 12,
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
            "lineWidth": 0,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "never",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
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
          },
          "unit": "reqps"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 6,
        "w": 6,
        "x": 0,
        "y": 18
      },
      "id": 35,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "single",
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
          "expr": "sum by(pod) (rate(coderd_api_requests_processed_total{pod=~`coder.*`, pod!~`.*provisioner.*`}[$__rate_interval]))",
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "API Requests",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "prometheus"
      },
      "description": "",
      "gridPos": {
        "h": 6,
        "w": 6,
        "x": 6,
        "y": 18
      },
      "id": 36,
      "options": {
        "code": {
          "language": "plaintext",
          "showLineNumbers": false,
          "showMiniMap": false
        },
        "content": "This shows the number of requests per second each `coderd` replica is handling.\n\nHeavy skewing towards a single `coderd` replica indicates faulty loadbalancing.",
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
    "from": "now-24h",
    "to": "now"
  },
  "timepicker": {},
  "timezone": "browser",
  "title": "Control Plane",
  "uid": "coderd",
  "version": 6,
  "weekStart": ""
}
{{ end }}