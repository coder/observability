{{ define "workspace-detail-dashboard.json" }}
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
        "content": "<small>**HINT**: use the dropdowns above to filter by specific workspace(s).</small>",
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
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "blue",
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
              "options": "CPUs Requested"
            },
            "properties": [
              {
                "id": "unit",
                "value": "none"
              },
              {
                "id": "decimals",
                "value": 2
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "RAM Requested"
            },
            "properties": [
              {
                "id": "unit",
                "value": "bytes"
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "PVC Capacity"
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
        "h": 4,
        "w": 20,
        "x": 0,
        "y": 1.2
      },
      "id": 29,
      "options": {
        "colorMode": "none",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "vertical",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "/.*/",
          "values": false
        },
        "showPercentChange": false,
        "text": {
          "titleSize": 20,
          "valueSize": 40
        },
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
          "expr": "group by (template_name) (coderd_agents_up{workspace_name=~\"$workspace_name\"})",
          "format": "table",
          "hide": false,
          "instant": true,
          "legendFormat": "Template Name",
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
          "expr": "group by (template_version) (coderd_agents_up{workspace_name=~\"$workspace_name\"})",
          "format": "table",
          "hide": false,
          "instant": true,
          "legendFormat": "Template Version",
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
          "expr": "group by (username) (coderd_agents_up{workspace_name=~\"$workspace_name\"})",
          "format": "table",
          "hide": false,
          "instant": true,
          "legendFormat": "Owner",
          "range": false,
          "refId": "C"
        }
      ],
      "title": "Details",
      "transformations": [
        {
          "id": "concatenate",
          "options": {}
        },
        {
          "id": "organize",
          "options": {
            "excludeByName": {
              "Time": true,
              "Value #A": true,
              "Value #B": true,
              "Value #C": true,
              "Value #D": true
            },
            "includeByName": {},
            "indexByName": {
              "CPUs Requested": 7,
              "PVC Capacity": 9,
              "RAM Requested": 8,
              "Time": 0,
              "Value #A": 5,
              "Value #B": 3,
              "Value #C": 6,
              "template_name": 2,
              "template_version": 4,
              "username": 1
            },
            "renameByName": {
              "Value #C": "",
              "lifecycle_state": "Agent State",
              "template_name": "Template",
              "template_version": "Template Version",
              "username": "Owner"
            }
          }
        }
      ],
      "type": "stat"
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
      "id": 38,
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
        "content": "Essential information about the selected workspace.",
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
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "blue",
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
              "options": "CPUs Requested"
            },
            "properties": [
              {
                "id": "unit",
                "value": "none"
              },
              {
                "id": "decimals",
                "value": 2
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "RAM Requested"
            },
            "properties": [
              {
                "id": "unit",
                "value": "bytes"
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "PVC Capacity"
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
        "h": 4,
        "w": 20,
        "x": 0,
        "y": 5.2
      },
      "id": 36,
      "options": {
        "reduceOptions": {
          "values": false,
          "calcs": [
            "lastNotNull"
          ],
          "fields": "/.*/"
        },
        "orientation": "vertical",
        "textMode": "value_and_name",
        "wideLayout": false,
        "colorMode": "none",
        "graphMode": "none",
        "justifyMode": "center",
        "showPercentChange": false,
        "text": {
          "titleSize": 20,
          "valueSize": 40
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
          "expr": "sum(kube_pod_container_resource_requests{pod=~\".*$workspace_name.*\", {{ include "workspaces-selector" . -}}, resource=\"cpu\"})",
          "format": "time_series",
          "hide": false,
          "instant": true,
          "legendFormat": "CPUs Requested",
          "range": false,
          "refId": "D"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "prometheus"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "sum(kube_pod_container_resource_requests{pod=~\".*$workspace_name.*\", {{ include "workspaces-selector" . -}}, resource=\"memory\"})",
          "format": "time_series",
          "hide": false,
          "instant": true,
          "legendFormat": "RAM Requested",
          "range": false,
          "refId": "E"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "prometheus"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "sum(\n  kube_pod_spec_volumes_persistentvolumeclaims_info{pod=~\".*$workspace_name.*\", {{- include "workspaces-selector" . -}} }\n  * on(persistentvolumeclaim) group_right\n  group by (persistentvolumeclaim, persistentvolume) (\n      label_replace(\n          kube_persistentvolume_claim_ref,\n          \"persistentvolumeclaim\",\n          \"$1\",\n          \"name\",\n          \"(.+)\"\n      )\n  )\n  * on (persistentvolume)\n  kube_persistentvolume_capacity_bytes\n)",
          "format": "time_series",
          "hide": false,
          "instant": true,
          "legendFormat": "PVC Capacity",
          "range": false,
          "refId": "F"
        }
      ],
      "title": "Resources",
      "transformations": [
        {
          "id": "concatenate",
          "options": {}
        },
        {
          "id": "organize",
          "options": {
            "excludeByName": {
              "Time": true,
              "Value #A": true,
              "Value #B": true,
              "Value #C": true,
              "Value #D": true
            },
            "includeByName": {},
            "indexByName": {
              "CPUs Requested": 7,
              "PVC Capacity": 9,
              "RAM Requested": 8,
              "Time": 0,
              "Value #A": 5,
              "Value #B": 3,
              "Value #C": 6,
              "template_name": 2,
              "template_version": 4,
              "username": 1
            },
            "renameByName": {
              "Value #C": "",
              "lifecycle_state": "Agent State",
              "template_name": "Template",
              "template_version": "Template Version",
              "username": "Owner"
            }
          }
        }
      ],
      "type": "stat",
      "description": ""
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "prometheus"
      },
      "description": "",
      "fieldConfig": {
        "defaults": {
          "mappings": [
            {
              "options": {
                "created": {
                  "color": "light-blue",
                  "index": 1,
                  "text": "Created"
                },
                "off": {
                  "color": "text",
                  "index": 8,
                  "text": "Off"
                },
                "ready": {
                  "color": "green",
                  "index": 0,
                  "text": "Ready"
                },
                "shutdown_error": {
                  "color": "red",
                  "index": 7,
                  "text": "Shutdown Error"
                },
                "shutdown_timeout": {
                  "color": "purple",
                  "index": 6,
                  "text": "Shutdown Timeout"
                },
                "shutting_down": {
                  "color": "light-purple",
                  "index": 5,
                  "text": "Shutting Down"
                },
                "start_error": {
                  "color": "red",
                  "index": 4,
                  "text": "Start Error"
                },
                "start_timeout": {
                  "color": "orange",
                  "index": 3,
                  "text": "Start Timeout"
                },
                "starting": {
                  "color": "super-light-green",
                  "index": 2,
                  "text": "Starting"
                }
              },
              "type": "value"
            },
            {
              "options": {
                "match": "empty",
                "result": {
                  "color": "text",
                  "index": 9,
                  "text": "Unknown"
                }
              },
              "type": "special"
            },
            {
              "options": {
                "match": "null",
                "result": {
                  "color": "text",
                  "index": 10,
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
          "unit": "short"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 6,
        "w": 4,
        "x": 0,
        "y": 9.2
      },
      "id": 35,
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "auto",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "/^lifecycle_state$/",
          "values": false
        },
        "showPercentChange": false,
        "text": {
          "valueSize": 50
        },
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
          "expr": "max by (lifecycle_state) (coderd_agents_connections{workspace_name=~\"$workspace_name\"})",
          "format": "table",
          "hide": false,
          "instant": true,
          "legendFormat": "__auto",
          "range": false,
          "refId": "D"
        }
      ],
      "title": "Agent Lifecycle State",
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
          "mappings": [
            {
              "options": {
                "-1": {
                  "color": "light-orange",
                  "index": 0,
                  "text": "Not completed yet"
                }
              },
              "type": "value"
            }
          ],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "#EAB839",
                "value": 60
              },
              {
                "color": "red",
                "value": 120
              }
            ]
          },
          "unit": "s"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 6,
        "w": 3,
        "x": 4,
        "y": 9.2
      },
      "id": 33,
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "auto",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "/^Value$/",
          "values": false
        },
        "showPercentChange": false,
        "text": {
          "valueSize": 50
        },
        "textMode": "value",
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
          "expr": "max(coderd_agentstats_startup_script_seconds{workspace_name=~\"$workspace_name\"}) or vector(-1)",
          "format": "table",
          "hide": false,
          "instant": true,
          "legendFormat": "__auto",
          "range": false,
          "refId": "C"
        }
      ],
      "title": "Agent Startup Script Execution Time",
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
                "color": "green",
                "value": null
              }
            ]
          },
          "unit": "short"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 6,
        "w": 3,
        "x": 7,
        "y": 9.2
      },
      "id": 39,
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "/.*/",
          "values": false
        },
        "showPercentChange": false,
        "text": {
          "titleSize": 20,
          "valueSize": 50
        },
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
          "expr": "max by (app) (\n    label_replace(\n        {workspace_name=~\"$workspace_name\", __name__=~\"coderd_agentstats_session_count_.*\"},\n        \"app\",\n        \"$1\",\n        \"__name__\",\n        \"coderd_agentstats_session_count_(.*)\"\n    )\n)>0",
          "format": "time_series",
          "hide": false,
          "instant": true,
          "legendFormat": {{ printf "{{app}}" | quote }},
          "range": false,
          "refId": "C"
        }
      ],
      "title": "App Session Counts",
      "transformations": [
        {
          "id": "concatenate",
          "options": {}
        },
        {
          "id": "organize",
          "options": {
            "excludeByName": {
              "Time": true
            },
            "includeByName": {},
            "indexByName": {},
            "renameByName": {}
          }
        }
      ],
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
                "color": "green",
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
              "options": "/.*Bytes/"
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
        "h": 6,
        "w": 10,
        "x": 10,
        "y": 9.2
      },
      "id": 34,
      "options": {
        "colorMode": "none",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "vertical",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "/.*/",
          "values": false
        },
        "showPercentChange": false,
        "text": {
          "titleSize": 20,
          "valueSize": 50
        },
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
          "expr": "max(coderd_agents_connection_latencies_seconds{workspace_name=~\"$workspace_name\"})",
          "format": "table",
          "hide": false,
          "instant": true,
          "legendFormat": "Connection Latency",
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
          "expr": "max(sum by (pod) (sum_over_time(coderd_agentstats_rx_bytes{workspace_name=~\"$workspace_name\"}[$__range])))",
          "format": "table",
          "hide": false,
          "instant": true,
          "legendFormat": "Received Bytes",
          "range": false,
          "refId": "rx"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "prometheus"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "max(sum by (pod) (sum_over_time(coderd_agentstats_tx_bytes{workspace_name=~\"$workspace_name\"}[$__range])))",
          "format": "table",
          "hide": false,
          "instant": true,
          "legendFormat": "Transmitted Bytes",
          "range": false,
          "refId": "tx"
        }
      ],
      "title": "Networking",
      "transformations": [
        {
          "id": "merge",
          "options": {}
        },
        {
          "id": "organize",
          "options": {
            "excludeByName": {
              "Time": true
            },
            "includeByName": {},
            "indexByName": {},
            "renameByName": {
              "Value #A": "Received Bytes",
              "Value #B": "Transmitted Bytes",
              "Value #C": "Connection Latency",
              "Value #rx": "Received Bytes",
              "Value #tx": "Transmitted Bytes"
            }
          }
        }
      ],
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
        "w": 4,
        "x": 20,
        "y": 9.2
      },
      "id": 40,
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
        "content": "Essential information about this workspace's agent.\n\nRead more about the agent [here](https://coder.com/docs/v2/latest/about/architecture#agents).",
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
        "h": 7,
        "w": 20,
        "x": 0,
        "y": 15.2
      },
      "id": 6,
      "interval": "",
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
          "expr": "sum by (workspace_name, workspace_owner, status, template_name, template_version, workspace_transition) (\n  # Since new series are created and are initially set to a value of 1, we cannot use \"increase\" (because an increase from <nothing> to 1 does not yield 1).\n  # So we compare the current series to an interval ago to see if we have any new series and then sum the series we find. \n  ((\n    coderd_workspace_builds_total{workspace_name=~\"$workspace_name\"} - \n    coderd_workspace_builds_total{workspace_name=~\"$workspace_name\"} offset $__interval\n  ) >= 0) \n  or coderd_workspace_builds_total{workspace_name=~\"$workspace_name\"}\n) > 0",
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
        "h": 7,
        "w": 4,
        "x": 20,
        "y": 15.2
      },
      "id": 37,
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
        "content": "This table shows a reverse-chronological log of all workspace builds.\n\nThe \"Count\" field shows the count of events which occurred within a minute, grouped by all columns.",
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
        "y": 22.2
      },
      "id": 7,
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
          "expr": {{ printf "{%s, logger=~\"(.*runner|terraform|provisioner.*)\"} |~ \"$workspace_name\" | line_format `{{ printf \"[\\033[35m\" }}{{.pod}}{{ printf \"\\033[0m]\\t\" }}{{ __line__ }}`" (include "non-workspace-selector" .) | quote }},
          "hide": false,
          "queryType": "range",
          "refId": "A"
        },
        {
          "datasource": {
            "type": "loki",
            "uid": "loki"
          },
          "editorMode": "code",
          "expr": {{ printf "{%s, pod=~\".*($workspace_name).*\"} | line_format `{{ printf \"[\\033[32m\" }}{{.pod}}{{ printf \"\\033[0m]\\t\" }}{{ __line__ }}`" (include "workspaces-selector" .) | quote }},
          "hide": false,
          "queryType": "range",
          "refId": "B"
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
        "y": 22.2
      },
      "id": 24,
      "options": {
        "code": {
          "language": "plaintext",
          "showLineNumbers": false,
          "showMiniMap": false
        },
        "content": "The logs to the left come both from provisioners and workspace logs.\n\nProvisioner logs matching the name filter are highlighted in <span style=\"color:rgb(204, 0, 204)\">magenta</span>, while\nworkspace logs matching the name filter are highlighted in <span style=\"color:rgb(0, 204, 0)\">green</span>.",
        "mode": "markdown"
      },
      "pluginVersion": "10.4.0",
      "transparent": true,
      "type": "text"
    }
  ],
  "refresh": "{{- include "dashboard-refresh" . -}}",
  "schemaVersion": 39,
  "tags": [],
  "templating": {
    "list": [
      {
        "allValue": "",
        "datasource": {
          "type": "prometheus",
          "uid": "prometheus"
        },
        "definition": "label_values(coderd_agents_up,workspace_name)",
        "hide": 0,
        "includeAll": false,
        "label": "Workspace Name Filter",
        "multi": false,
        "name": "workspace_name",
        "options": [],
        "query": {
          "qryType": 1,
          "query": "label_values(coderd_agents_up,workspace_name)",
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
    "from": "now-{{- include "dashboard-range" . -}}",
    "to": "now"
  },
  "timepicker": {},
  "timezone": "browser",
  "title": "Coder Workspace Detail",
  "uid": "coder-workspace-detail",
  "version": 9,
  "weekStart": ""
}
{{ end }}