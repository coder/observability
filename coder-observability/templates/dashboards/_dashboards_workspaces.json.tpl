{{ define "workspaces-dashboard.json" }}
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
        "type": "loki",
        "uid": "loki"
      },
      "description": "",
      "gridPos": {
        "h": 1.2,
        "w": 24,
        "x": 0,
        "y": 0
      },
      "id": 28,
      "options": {
        "code": {
          "language": "plaintext",
          "showLineNumbers": false,
          "showMiniMap": false
        },
        "content": "<small>**HINT**: use the dropdowns above to filter by specific workspaces and/or templates.</small>",
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
            "pointSize": 1,
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
          "unit": "short"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byName",
              "options": "DESTROY"
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
              "options": "STOP"
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
          },
          {
            "matcher": {
              "id": "byName",
              "options": "START"
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
          }
        ]
      },
      "gridPos": {
        "h": 8,
        "w": 10,
        "x": 0,
        "y": 1.2
      },
      "id": 2,
      "interval": "5m",
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "multi",
          "sort": "desc"
        }
      },
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "prometheus"
          },
          "editorMode": "code",
          "expr": "sum by (workspace_transition) (\n    (\n      # Since new series are created and are initially set to a value of 1, we cannot use \"increase\" (because an increase from <nothing> to 1 does not yield 1).\n      # So we compare the current series to an interval ago to see if we have any new series and then sum the series we find. \n      (\n        coderd_workspace_builds_total{status=\"success\", workspace_name=~\"$workspace_name\", template_name=~\"$template_name\"} - \n        coderd_workspace_builds_total{status=\"success\", workspace_name=~\"$workspace_name\", template_name=~\"$template_name\"} offset $__interval\n      ) >= 0) \n      or coderd_workspace_builds_total{status=\"success\", workspace_name=~\"$workspace_name\", template_name=~\"$template_name\"}\n) > 0",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "B"
        }
      ],
      "title": "Successful Builds by State",
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
          "unit": "short"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byName",
              "options": "DESTROY"
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
              "options": "STOP"
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
              "options": "START"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "blue",
                  "mode": "fixed"
                }
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 8,
        "w": 10,
        "x": 10,
        "y": 1.2
      },
      "id": 1,
      "interval": "5m",
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "multi",
          "sort": "desc"
        }
      },
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "prometheus"
          },
          "editorMode": "code",
          "expr": "sum by (workspace_transition) (\n    (\n      # Since new series are created and are initially set to a value of 1, we cannot use \"increase\" (because an increase from <nothing> to 1 does not yield 1).\n      # So we compare the current series to an interval ago to see if we have any new series and then sum the series we find. \n      (\n        coderd_workspace_builds_total{status=\"failed\", workspace_name=~\"$workspace_name\", template_name=~\"$template_name\"} - \n        coderd_workspace_builds_total{status=\"failed\", workspace_name=~\"$workspace_name\", template_name=~\"$template_name\"} offset $__interval\n      ) >= 0) \n      or coderd_workspace_builds_total{status=\"failed\", workspace_name=~\"$workspace_name\", template_name=~\"$template_name\"}\n) > 0",
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Unsuccessful Builds by State",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "prometheus"
      },
      "description": "",
      "gridPos": {
        "h": 8,
        "w": 4,
        "x": 20,
        "y": 1.2
      },
      "id": 20,
      "options": {
        "code": {
          "language": "plaintext",
          "showLineNumbers": false,
          "showMiniMap": false
        },
        "content": "Workspaces \"transition\" between `STOP`, `START`, and `DESTROY` states.\n\nWorkspaces transition between states when a \"build\" is initiated, which is an execution of `terraform` against the chosen template.\n\nUse the \"Build Count\" table to identify workspace owners which may be struggling with template builds, in order to proactively reach out to them with assistance.\n\nConsult the [Template documentation](https://coder.com/docs/v2/latest/templates) for more information.",
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
          "custom": {
            "align": "auto",
            "cellOptions": {
              "type": "auto"
            },
            "filterable": true,
            "inspect": false
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
          "unit": "short"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byName",
              "options": "status"
            },
            "properties": [
              {
                "id": "custom.cellOptions",
                "value": {
                  "type": "color-text"
                }
              },
              {
                "id": "mappings",
                "value": [
                  {
                    "options": {
                      "failed": {
                        "color": "orange",
                        "index": 1,
                        "text": "Failure"
                      },
                      "success": {
                        "color": "green",
                        "index": 0,
                        "text": "Success"
                      }
                    },
                    "type": "value"
                  }
                ]
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "Workspace Transition"
            },
            "properties": [
              {
                "id": "custom.cellOptions",
                "value": {
                  "type": "color-text"
                }
              },
              {
                "id": "mappings",
                "value": [
                  {
                    "options": {
                      "DESTROY": {
                        "color": "red",
                        "index": 0
                      },
                      "START": {
                        "color": "blue",
                        "index": 1
                      },
                      "STOP": {
                        "color": "purple",
                        "index": 2
                      }
                    },
                    "type": "value"
                  }
                ]
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 10,
        "w": 20,
        "x": 0,
        "y": 9.2
      },
      "id": 6,
      "interval": "1m",
      "options": {
        "cellHeight": "sm",
        "footer": {
          "countRows": false,
          "enablePagination": true,
          "fields": [],
          "reducer": [
            "sum"
          ],
          "show": false
        },
        "showHeader": true,
        "sortBy": [
          {
            "desc": true,
            "displayName": "Time"
          }
        ]
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
          "expr": "sum by (workspace_name, workspace_owner, status, template_name, template_version, workspace_transition) (\n  # Since new series are created and are initially set to a value of 1, we cannot use \"increase\" (because an increase from <nothing> to 1 does not yield 1).\n  # So we compare the current series to an interval ago to see if we have any new series and then sum the series we find. \n  ((\n    coderd_workspace_builds_total{workspace_name=~\"$workspace_name\", template_name=~\"$template_name\"} - \n    coderd_workspace_builds_total{workspace_name=~\"$workspace_name\", template_name=~\"$template_name\"} offset $__interval\n  ) >= 0) \n  or coderd_workspace_builds_total{workspace_name=~\"$workspace_name\", template_name=~\"$template_name\"}\n) > 0",
          "format": "table",
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Build Log",
      "transformations": [
        {
          "disabled": true,
          "id": "groupBy",
          "options": {
            "fields": {
              "Count": {
                "aggregations": [
                  "sum"
                ],
                "operation": "aggregate"
              },
              "Status": {
                "aggregations": [],
                "operation": "groupby"
              },
              "Template Name": {
                "aggregations": [],
                "operation": "groupby"
              },
              "Template Version": {
                "aggregations": [],
                "operation": "groupby"
              },
              "Total": {
                "aggregations": [
                  "sum"
                ],
                "operation": "aggregate"
              },
              "Value": {
                "aggregations": [
                  "sum"
                ],
                "operation": "aggregate"
              },
              "Workspace Name": {
                "aggregations": [],
                "operation": "groupby"
              },
              "Workspace Ownert": {
                "aggregations": [],
                "operation": "groupby"
              },
              "Workspace Transition": {
                "aggregations": [],
                "operation": "groupby"
              },
              "status": {
                "aggregations": [],
                "operation": "groupby"
              },
              "template_name": {
                "aggregations": [],
                "operation": "groupby"
              },
              "template_version": {
                "aggregations": [],
                "operation": "groupby"
              },
              "workspace_name": {
                "aggregations": [],
                "operation": "groupby"
              },
              "workspace_owner": {
                "aggregations": [],
                "operation": "groupby"
              },
              "workspace_transition": {
                "aggregations": [],
                "operation": "groupby"
              }
            }
          }
        },
        {
          "id": "sortBy",
          "options": {
            "fields": {},
            "sort": [
              {
                "desc": true,
                "field": "Value"
              }
            ]
          }
        },
        {
          "id": "organize",
          "options": {
            "excludeByName": {
              "Time": false
            },
            "includeByName": {},
            "indexByName": {},
            "renameByName": {
              "Value": "Count",
              "Value (sum)": "Total",
              "status": "Status",
              "template_name": "Template Name",
              "template_version": "Template Version",
              "workspace_name": "Workspace Name",
              "workspace_owner": "Workspace Owner",
              "workspace_transition": "Workspace Transition"
            }
          }
        }
      ],
      "type": "table"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "prometheus"
      },
      "description": "",
      "gridPos": {
        "h": 10,
        "w": 4,
        "x": 20,
        "y": 9.2
      },
      "id": 29,
      "options": {
        "code": {
          "language": "plaintext",
          "showLineNumbers": false,
          "showMiniMap": false
        },
        "content": "This table shows a reverse-chronological log of all workspace builds.\n\nThe \"Total\" field shows the count of events which occurred within a minute.",
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
            "mode": "palette-classic"
          },
          "custom": {
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            }
          },
          "mappings": [],
          "unit": "short"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 7,
        "w": 5,
        "x": 0,
        "y": 19.2
      },
      "id": 8,
      "interval": "1h",
      "options": {
        "displayLabels": [
          "name"
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
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "prometheus"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "count by (workspace_owner) (coderd_workspace_latest_build_status{template_name=~\"$template_name\"})",
          "instant": true,
          "legendFormat": "__auto",
          "range": false,
          "refId": "A"
        }
      ],
      "title": "Workspace by User",
      "type": "piechart"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "prometheus"
      },
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
          "mappings": [],
          "unit": "short"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 7,
        "w": 5,
        "x": 5,
        "y": 19.2
      },
      "id": 9,
      "interval": "1h",
      "options": {
        "displayLabels": [
          "name"
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
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "prometheus"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "count by (workspace_owner, template_name) (coderd_workspace_latest_build_status{template_name=~\"$template_name\"})",
          "instant": true,
          "legendFormat": "{{workspace_owner}}:{{template_name}}",
          "range": false,
          "refId": "A"
        }
      ],
      "title": "Workspace by User/Template",
      "type": "piechart"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "prometheus"
      },
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
          "mappings": [],
          "unit": "short"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 7,
        "w": 5,
        "x": 10,
        "y": 19.2
      },
      "id": 4,
      "interval": "1h",
      "options": {
        "displayLabels": [
          "name"
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
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "prometheus"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "count by (template_name) (coderd_workspace_latest_build_status{template_name=~\"$template_name\"})",
          "instant": true,
          "legendFormat": "__auto",
          "range": false,
          "refId": "A"
        }
      ],
      "title": "Template Usage",
      "type": "piechart"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "prometheus"
      },
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
          "mappings": [],
          "unit": "short"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 7,
        "w": 5,
        "x": 15,
        "y": 19.2
      },
      "id": 5,
      "interval": "1h",
      "options": {
        "displayLabels": [],
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
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "prometheus"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "count by (template_name, template_version) (coderd_workspace_latest_build_status{template_name=~\"$template_name\"})",
          "instant": true,
          "legendFormat": "{{template_name}}:{{template_version}}",
          "range": false,
          "refId": "A"
        }
      ],
      "title": "Template Version Usage",
      "type": "piechart"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "prometheus"
      },
      "description": "",
      "gridPos": {
        "h": 7,
        "w": 4,
        "x": 20,
        "y": 19.2
      },
      "id": 24,
      "options": {
        "code": {
          "language": "plaintext",
          "showLineNumbers": false,
          "showMiniMap": false
        },
        "content": "These charts show the distribution of workspaces and templates.\n\nUse these charts to identify which users have outdated templates, and which templates are the most/least popular in your organisation.",
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
        "h": 10,
        "w": 20,
        "x": 0,
        "y": 26.2
      },
      "id": 7,
      "options": {
        "dedupStrategy": "exact",
        "enableLogDetails": true,
        "prettifyLogMessage": false,
        "showCommonLabels": false,
        "showLabels": false,
        "showTime": false,
        "sortOrder": "Descending",
        "wrapLogMessage": true
      },
      "targets": [
        {
          "datasource": {
            "type": "loki",
            "uid": "loki"
          },
          "editorMode": "code",
          "expr": "{pod=~\"coder.*\", logger=~\"(.*runner|terraform|provisioner.*)\"} |~ \"$workspace_name\" or \"$template_name\"",
          "queryType": "range",
          "refId": "A"
        }
      ],
      "title": "Logs",
      "type": "logs"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "prometheus"
      },
      "description": "",
      "gridPos": {
        "h": 10,
        "w": 4,
        "x": 20,
        "y": 26.2
      },
      "id": 22,
      "links": [
        {
          "title": "Provisioners Dashboard",
          "url": "/d/provisionerd/provisioners?${__url_time_range}"
        }
      ],
      "options": {
        "code": {
          "language": "plaintext",
          "showLineNumbers": false,
          "showMiniMap": false
        },
        "content": "These are the logs produced by the [Provisioners](/d/provisionerd/provisioners?${__url_time_range}).\n\nUse the dropdowns at the top to filter the logs down to a specific workspace and/or template.",
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
    "list": [
      {
        "allValue": "",
        "current": {
          "selected": true,
          "text": [
            "All"
          ],
          "value": [
            "$__all"
          ]
        },
        "datasource": {
          "type": "prometheus",
          "uid": "prometheus"
        },
        "definition": "label_values(coderd_workspace_builds_total,workspace_name)",
        "hide": 0,
        "includeAll": true,
        "label": "Workspace Name Filter",
        "multi": true,
        "name": "workspace_name",
        "options": [],
        "query": {
          "qryType": 1,
          "query": "label_values(coderd_workspace_builds_total,workspace_name)",
          "refId": "PrometheusVariableQueryEditor-VariableQuery"
        },
        "refresh": 2,
        "regex": "",
        "skipUrlSync": false,
        "sort": 1,
        "type": "query"
      },
      {
        "allValue": "",
        "current": {
          "selected": true,
          "text": [
            "All"
          ],
          "value": [
            "$__all"
          ]
        },
        "datasource": {
          "type": "prometheus",
          "uid": "prometheus"
        },
        "definition": "label_values(coderd_workspace_builds_total,template_name)",
        "hide": 0,
        "includeAll": true,
        "label": "Template Name Filter",
        "multi": true,
        "name": "template_name",
        "options": [],
        "query": {
          "qryType": 1,
          "query": "label_values(coderd_workspace_builds_total,template_name)",
          "refId": "PrometheusVariableQueryEditor-VariableQuery"
        },
        "refresh": 2,
        "regex": "",
        "skipUrlSync": false,
        "sort": 1,
        "type": "query"
      }
    ]
  },
  "time": {
    "from": "now-1h",
    "to": "now"
  },
  "timepicker": {},
  "timezone": "browser",
  "title": "Workspaces",
  "uid": "workspaces",
  "version": 3,
  "weekStart": ""
}
{{ end }}