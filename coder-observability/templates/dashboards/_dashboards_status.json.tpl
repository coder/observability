{{ define "status-dashboard.json" }}
{
  "annotations": {
    "list": [
      {
        "builtIn": 1,
        "datasource": {
          "type": "grafana",
          "uid": "-- Grafana --"
        },
        "enable": false,
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
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 0
      },
      "id": 9,
      "title": "Application",
      "type": "row"
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
        "h": 7,
        "w": 4,
        "x": 0,
        "y": 1
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
          "expr": "count(up{ {{- include "coderd-selector" . -}} } == 1) or vector(0) > 0",
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
          "expr": "count(up{ {{- include "coderd-selector" . -}} } == 0) or vector(0) > 0",
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
        "overrides": []
      },
      "gridPos": {
        "h": 7,
        "w": 4,
        "x": 4,
        "y": 1
      },
      "id": 16,
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
          "expr": "sum(coderd_provisionerd_num_daemons{ {{- include "coderd-selector" . -}} })",
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
          "expr": "sum(coderd_provisionerd_num_daemons{ {{- include "provisionerd-selector" . -}} })",
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
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            }
          },
          "mappings": []
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
                "value": "Failed"
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
        "w": 4,
        "x": 8,
        "y": 1
      },
      "id": 17,
      "options": {
        "displayLabels": [
          "name",
          "value"
        ],
        "legend": {
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true,
          "values": [
            "percent"
          ]
        },
        "pieType": "pie",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
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
          "expr": "round(sum by (status) (increase(coderd_provisionerd_job_timings_seconds_count{pod!=``}[$__range])))",
          "instant": true,
          "legendFormat": {{ printf "{{status}}" | quote }},
          "range": false,
          "refId": "A"
        }
      ],
      "title": "Workspace Builds",
      "type": "piechart"
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
        "w": 4,
        "x": 12,
        "y": 1
      },
      "id": 18,
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "auto",
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
          "expr": "count(kube_pod_status_ready{condition=\"true\", {{ include "workspaces-selector" . -}}} == 1)\nor\nsum(max by (workspace_owner, template_name, template_version) (coderd_workspace_latest_build_status{status=\"succeeded\", workspace_transition=\"start\"}))\nor\nvector(0)",
          "instant": true,
          "legendFormat": "__auto",
          "range": false,
          "refId": "A"
        }
      ],
      "title": "Running Workspaces",
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
            "mode": "thresholds"
          },
          "decimals": 0,
          "mappings": [
            {
              "options": {
                "0": {
                  "color": "red",
                  "index": 1,
                  "text": "Down"
                },
                "1": {
                  "color": "green",
                  "index": 0,
                  "text": "Up"
                }
              },
              "type": "value"
            },
            {
              "options": {
                "match": "null",
                "result": {
                  "color": "orange",
                  "index": 2,
                  "text": "Unknown"
                }
              },
              "type": "special"
            },
            {
              "options": {
                "match": "empty",
                "result": {
                  "color": "orange",
                  "index": 3,
                  "text": "Unknown"
                }
              },
              "type": "special"
            },
            {
              "options": {
                "match": "null+nan",
                "result": {
                  "index": 4,
                  "text": "Unknown"
                }
              },
              "type": "special"
            }
          ],
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
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*RAM/"
            },
            "properties": [
              {
                "id": "unit",
                "value": "bytes"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 7,
        "w": 4,
        "x": 16,
        "y": 1
      },
      "id": 15,
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "auto",
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
          "expr": "sum(\n    max_over_time(\n        rate(container_cpu_usage_seconds_total{ {{- include "coderd-selector" . -}} }[1h:1m])\n        [$__range:]\n    )\n)",
          "instant": true,
          "legendFormat": "Control Plane CPU",
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
          "expr": "sum(\n    max_over_time(\n        rate(container_cpu_usage_seconds_total{ {{- include "provisionerd-selector" . -}} }[1h:1m])\n        [$__range:]\n    )\n)",
          "hide": false,
          "instant": true,
          "legendFormat": "Provisioner CPU",
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
          "expr": "sum(\n    max_over_time(\n        container_memory_working_set_bytes{ {{- include "coderd-selector" . -}} }\n        [$__range:]\n    )\n)",
          "hide": false,
          "instant": true,
          "legendFormat": "Control Plane RAM",
          "range": false,
          "refId": "C"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "prometheus"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "sum(\n    max_over_time(\n        container_memory_working_set_bytes{ {{- include "provisionerd-selector" . -}} }\n        [$__range:]\n    )\n)",
          "hide": false,
          "instant": true,
          "legendFormat": "Provisioner RAM",
          "range": false,
          "refId": "D"
        }
      ],
      "title": "Resource Usage High Watermark (Cumulative)",
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
            "mode": "thresholds"
          },
          "mappings": [
            {
              "options": {
                "0": {
                  "color": "red",
                  "index": 1,
                  "text": "Down"
                },
                "1": {
                  "color": "green",
                  "index": 0,
                  "text": "Up"
                }
              },
              "type": "value"
            },
            {
              "options": {
                "match": "null",
                "result": {
                  "color": "orange",
                  "index": 2,
                  "text": "Unknown"
                }
              },
              "type": "special"
            },
            {
              "options": {
                "match": "empty",
                "result": {
                  "color": "orange",
                  "index": 3,
                  "text": "Unknown"
                }
              },
              "type": "special"
            },
            {
              "options": {
                "match": "null+nan",
                "result": {
                  "index": 4,
                  "text": "Unknown"
                }
              },
              "type": "special"
            }
          ],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "red",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 7,
        "w": 4,
        "x": 20,
        "y": 1
      },
      "id": 19,
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "auto",
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
          "expr": "min(pg_up) or vector(0)",
          "instant": true,
          "legendFormat": "__auto",
          "range": false,
          "refId": "A"
        }
      ],
      "title": "Postgres",
      "type": "stat"
    },
    {
      "collapsed": false,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 8
      },
      "id": 3,
      "panels": [],
      "title": "Observability Tools",
      "type": "row"
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
          "mappings": [
            {
              "options": {
                "0": {
                  "color": "red",
                  "index": 1,
                  "text": "Down"
                },
                "1": {
                  "color": "green",
                  "index": 0,
                  "text": "Up"
                }
              },
              "type": "value"
            },
            {
              "options": {
                "match": "null",
                "result": {
                  "color": "orange",
                  "index": 2,
                  "text": "Unknown"
                }
              },
              "type": "special"
            },
            {
              "options": {
                "match": "empty",
                "result": {
                  "color": "orange",
                  "index": 3,
                  "text": "Unknown"
                }
              },
              "type": "special"
            },
            {
              "options": {
                "match": "null+nan",
                "result": {
                  "index": 4,
                  "text": "Unknown"
                }
              },
              "type": "special"
            }
          ],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "red",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 0,
        "y": 9
      },
      "id": 1,
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "auto",
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
          "expr": "min(up{job=\"{{- include "prometheus-job" . -}}\"}) or vector(0)",
          "instant": true,
          "legendFormat": "__auto",
          "range": false,
          "refId": "A"
        }
      ],
      "title": "Prometheus",
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
            "mode": "thresholds"
          },
          "mappings": [
            {
              "options": {
                "0": {
                  "color": "red",
                  "index": 1,
                  "text": "Down"
                },
                "1": {
                  "color": "green",
                  "index": 0,
                  "text": "Up"
                }
              },
              "type": "value"
            },
            {
              "options": {
                "match": "null",
                "result": {
                  "color": "orange",
                  "index": 2,
                  "text": "Unknown"
                }
              },
              "type": "special"
            },
            {
              "options": {
                "match": "empty",
                "result": {
                  "color": "orange",
                  "index": 3,
                  "text": "Unknown"
                }
              },
              "type": "special"
            },
            {
              "options": {
                "match": "null+nan",
                "result": {
                  "index": 4,
                  "text": "Unknown"
                }
              },
              "type": "special"
            }
          ],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "red",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 4,
        "y": 9
      },
      "id": 4,
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "auto",
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
          "expr": "min(up{job=\"{{- include "loki-job" . -}}/write\"}) or vector(0)",
          "instant": true,
          "legendFormat": "__auto",
          "range": false,
          "refId": "A"
        }
      ],
      "title": "Loki Write Path",
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
            "mode": "thresholds"
          },
          "mappings": [
            {
              "options": {
                "0": {
                  "color": "red",
                  "index": 1,
                  "text": "Down"
                },
                "1": {
                  "color": "green",
                  "index": 0,
                  "text": "Up"
                }
              },
              "type": "value"
            },
            {
              "options": {
                "match": "null",
                "result": {
                  "color": "orange",
                  "index": 2,
                  "text": "Unknown"
                }
              },
              "type": "special"
            },
            {
              "options": {
                "match": "empty",
                "result": {
                  "color": "orange",
                  "index": 3,
                  "text": "Unknown"
                }
              },
              "type": "special"
            },
            {
              "options": {
                "match": "null+nan",
                "result": {
                  "index": 4,
                  "text": "Unknown"
                }
              },
              "type": "special"
            }
          ],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "red",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 8,
        "y": 9
      },
      "id": 5,
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "auto",
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
          "expr": "min(up{job=\"{{- include "loki-job" . -}}/read\"}) or vector(0)",
          "instant": true,
          "legendFormat": "__auto",
          "range": false,
          "refId": "A"
        }
      ],
      "title": "Loki Read Path",
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
            "mode": "thresholds"
          },
          "mappings": [
            {
              "options": {
                "0": {
                  "color": "red",
                  "index": 1,
                  "text": "Down"
                },
                "1": {
                  "color": "green",
                  "index": 0,
                  "text": "Up"
                }
              },
              "type": "value"
            },
            {
              "options": {
                "match": "null",
                "result": {
                  "color": "orange",
                  "index": 2,
                  "text": "Unknown"
                }
              },
              "type": "special"
            },
            {
              "options": {
                "match": "empty",
                "result": {
                  "color": "orange",
                  "index": 3,
                  "text": "Unknown"
                }
              },
              "type": "special"
            },
            {
              "options": {
                "match": "null+nan",
                "result": {
                  "index": 4,
                  "text": "Unknown"
                }
              },
              "type": "special"
            }
          ],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "red",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 12,
        "y": 9
      },
      "id": 6,
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "auto",
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
          "expr": "min(up{job=\"{{- include "loki-job" . -}}/backend\", container=\"loki\"}) or vector(0)",
          "instant": true,
          "legendFormat": "__auto",
          "range": false,
          "refId": "A"
        }
      ],
      "title": "Loki Backend",
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
            "mode": "thresholds"
          },
          "mappings": [
            {
              "options": {
                "0": {
                  "color": "red",
                  "index": 1,
                  "text": "Down"
                },
                "1": {
                  "color": "green",
                  "index": 0,
                  "text": "Up"
                }
              },
              "type": "value"
            },
            {
              "options": {
                "match": "null",
                "result": {
                  "color": "orange",
                  "index": 2,
                  "text": "Unknown"
                }
              },
              "type": "special"
            },
            {
              "options": {
                "match": "empty",
                "result": {
                  "color": "orange",
                  "index": 3,
                  "text": "Unknown"
                }
              },
              "type": "special"
            },
            {
              "options": {
                "match": "null+nan",
                "result": {
                  "index": 4,
                  "text": "Unknown"
                }
              },
              "type": "special"
            }
          ],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "red",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 16,
        "y": 9
      },
      "id": 7,
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "auto",
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
          "expr": "min(up{job=\"{{- include "loki-job" . -}}/canary\"}) or vector(0)",
          "instant": true,
          "legendFormat": "__auto",
          "range": false,
          "refId": "A"
        }
      ],
      "title": "Loki Canary",
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
            "mode": "thresholds"
          },
          "mappings": [
            {
              "options": {
                "0": {
                  "color": "red",
                  "index": 1,
                  "text": "Down"
                },
                "1": {
                  "color": "green",
                  "index": 0,
                  "text": "Up"
                }
              },
              "type": "value"
            },
            {
              "options": {
                "match": "null",
                "result": {
                  "color": "orange",
                  "index": 2,
                  "text": "Unknown"
                }
              },
              "type": "special"
            },
            {
              "options": {
                "match": "empty",
                "result": {
                  "color": "orange",
                  "index": 3,
                  "text": "Unknown"
                }
              },
              "type": "special"
            },
            {
              "options": {
                "match": "null+nan",
                "result": {
                  "index": 4,
                  "text": "Unknown"
                }
              },
              "type": "special"
            }
          ],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "red",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 20,
        "y": 9
      },
      "id": 8,
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "auto",
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
          "expr": "min(up{job=\"{{- include "grafana-agent-job" . -}}\"}) or vector(0)",
          "instant": true,
          "legendFormat": "__auto",
          "range": false,
          "refId": "A"
        }
      ],
      "title": "Grafana Agent",
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
            "mode": "thresholds"
          },
          "mappings": [
            {
              "options": {
                "0": {
                  "color": "red",
                  "index": 1,
                  "text": "Unhealthy"
                },
                "1": {
                  "color": "green",
                  "index": 0,
                  "text": "Healthy"
                }
              },
              "type": "value"
            },
            {
              "options": {
                "match": "null",
                "result": {
                  "color": "orange",
                  "index": 2,
                  "text": "Unknown"
                }
              },
              "type": "special"
            },
            {
              "options": {
                "match": "empty",
                "result": {
                  "color": "orange",
                  "index": 3,
                  "text": "Unknown"
                }
              },
              "type": "special"
            },
            {
              "options": {
                "match": "null+nan",
                "result": {
                  "index": 4,
                  "text": "Unknown"
                }
              },
              "type": "special"
            }
          ],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "red",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 0,
        "y": 14
      },
      "id": 12,
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "auto",
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
          "expr": "prometheus_config_last_reload_successful{job=\"{{- include "prometheus-job" . -}}\"}",
          "instant": true,
          "legendFormat": "__auto",
          "range": false,
          "refId": "A"
        }
      ],
      "title": "Prometheus Config",
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
            "mode": "thresholds"
          },
          "mappings": [
            {
              "options": {
                "0": {
                  "color": "red",
                  "index": 1,
                  "text": "Unhealthy"
                },
                "1": {
                  "color": "green",
                  "index": 0,
                  "text": "Healthy"
                }
              },
              "type": "value"
            },
            {
              "options": {
                "match": "null",
                "result": {
                  "color": "orange",
                  "index": 2,
                  "text": "Unknown"
                }
              },
              "type": "special"
            },
            {
              "options": {
                "match": "empty",
                "result": {
                  "color": "orange",
                  "index": 3,
                  "text": "Unknown"
                }
              },
              "type": "special"
            },
            {
              "options": {
                "match": "null+nan",
                "result": {
                  "index": 4,
                  "text": "Unknown"
                }
              },
              "type": "special"
            }
          ],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "red",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 4,
        "y": 14
      },
      "id": 14,
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "auto",
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
          "expr": "min(loki_runtime_config_last_reload_successful) or vector(0)",
          "instant": true,
          "legendFormat": "__auto",
          "range": false,
          "refId": "A"
        }
      ],
      "title": "Loki Config",
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
            "mode": "thresholds"
          },
          "mappings": [
            {
              "options": {
                "0": {
                  "color": "red",
                  "index": 1,
                  "text": "Unhealthy"
                },
                "1": {
                  "color": "green",
                  "index": 0,
                  "text": "Healthy"
                }
              },
              "type": "value"
            },
            {
              "options": {
                "match": "null",
                "result": {
                  "color": "orange",
                  "index": 2,
                  "text": "Unknown"
                }
              },
              "type": "special"
            },
            {
              "options": {
                "match": "empty",
                "result": {
                  "color": "orange",
                  "index": 3,
                  "text": "Unknown"
                }
              },
              "type": "special"
            },
            {
              "options": {
                "match": "null+nan",
                "result": {
                  "index": 4,
                  "text": "Unknown"
                }
              },
              "type": "special"
            }
          ],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "red",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 8,
        "y": 14
      },
      "id": 13,
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "auto",
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
          "expr": "min(agent_config_last_load_successful{job=\"{{- include "grafana-agent-job" . -}}\"}) or vector(0)",
          "instant": true,
          "legendFormat": "__auto",
          "range": false,
          "refId": "A"
        }
      ],
      "title": "Grafana Agent Config",
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
          "unit": "percentunit"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byName",
              "options": "Retention Limit"
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
          },
          {
            "matcher": {
              "id": "byName",
              "options": "Write-Ahead Log"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "purple",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "Storage"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#f9f9fb",
                  "mode": "fixed"
                }
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 12,
        "y": 14
      },
      "id": 11,
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "auto",
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
          "expr": "(\n    prometheus_tsdb_wal_storage_size_bytes{job=\"{{- include "prometheus-job" . -}}\"} +\n    prometheus_tsdb_storage_blocks_bytes{job=\"{{- include "prometheus-job" . -}}\"} +\n    prometheus_tsdb_symbol_table_size_bytes{job=\"{{- include "prometheus-job" . -}}\"}\n)\n/\nprometheus_tsdb_retention_limit_bytes{job=\"{{- include "prometheus-job" . -}}\"}",
          "instant": false,
          "legendFormat": "Retention limit used",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Prometheus Storage",
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
            "mode": "thresholds"
          },
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
          "unit": "none"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 16,
        "y": 14
      },
      "id": 20,
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
        "text": {
          "titleSize": 20,
          "valueSize": 35
        },
        "textMode": "auto",
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
          "expr": "sum(kube_pod_container_resource_requests{namespace=\"{{- .Release.Namespace -}}\", resource=\"cpu\"})",
          "hide": false,
          "instant": true,
          "legendFormat": "Requested",
          "range": false,
          "refId": "C"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "prometheus"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "sum(\n    max_over_time(\n        rate(container_cpu_usage_seconds_total{namespace=\"{{- .Release.Namespace -}}\"}[$__rate_interval])\n        [$__range:]\n    )\n)",
          "hide": false,
          "instant": true,
          "legendFormat": "High Watermark",
          "range": false,
          "refId": "D"
        }
      ],
      "title": "CPU",
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
            "mode": "thresholds"
          },
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
          "unit": "bytes"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 20,
        "y": 14
      },
      "id": 21,
      "options": {
        "colorMode": "none",
        "graphMode": "area",
        "justifyMode": "center",
        "orientation": "vertical",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "text": {
          "titleSize": 20,
          "valueSize": 35
        },
        "textMode": "value_and_name",
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
          "expr": "sum(kube_pod_container_resource_requests{namespace=\"{{- .Release.Namespace -}}\", resource=\"memory\"})",
          "hide": false,
          "instant": true,
          "legendFormat": "Requested",
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
          "expr": "sum(\n    max_over_time(container_memory_working_set_bytes{namespace=\"{{- .Release.Namespace -}}\"}[$__range])\n)",
          "instant": true,
          "legendFormat": "High Watermark",
          "range": false,
          "refId": "A"
        }
      ],
      "title": "RAM",
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
    "from": "now-24h",
    "to": "now"
  },
  "timepicker": {},
  "timezone": "browser",
  "title": "Coder Status",
  "uid": "coder-status",
  "version": 1,
  "weekStart": ""
}
{{ end }}
