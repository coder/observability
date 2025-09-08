{{ define "prebuilds-dashboard.json" }}
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
  "id": 132,
  "links": [],
  "panels": [
    {
      "datasource": {
        "type": "prometheus",
        "uid": "prometheus"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "text",
            "mode": "fixed"
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": 0
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
        "h": 4,
        "w": 4,
        "x": 0,
        "y": 0
      },
      "id": 49,
      "interval": "30s",
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "center",
        "orientation": "vertical",
        "percentChangeColorMode": "standard",
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
      "pluginVersion": "12.1.0",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "prometheus"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "sum(max(coderd_prebuilt_workspaces_desired) by (template_name, preset_name)) or vector(0)",
          "instant": true,
          "interval": "",
          "legendFormat": "Desired",
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
          "expr": "sum(max(coderd_prebuilt_workspaces_running) by (template_name, preset_name)) or vector(0)",
          "hide": false,
          "instant": true,
          "interval": "",
          "legendFormat": "Running",
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
          "expr": "sum(max(coderd_prebuilt_workspaces_eligible) by (template_name, preset_name)) or vector(0)",
          "hide": false,
          "instant": true,
          "interval": "",
          "legendFormat": "Eligible",
          "range": false,
          "refId": "E"
        }
      ],
      "title": "Current: Global",
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
            "fixedColor": "text",
            "mode": "fixed"
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": 0
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
        "h": 4,
        "w": 4,
        "x": 4,
        "y": 0
      },
      "id": 48,
      "interval": "30s",
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "center",
        "orientation": "vertical",
        "percentChangeColorMode": "standard",
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
      "pluginVersion": "12.1.0",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "prometheus"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "sum(max by (template_name, preset_name) (coderd_prebuilt_workspaces_created_total)) or vector(0)",
          "hide": false,
          "instant": true,
          "interval": "",
          "legendFormat": "Created",
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
          "expr": "sum(max by (template_name, preset_name) (coderd_prebuilt_workspaces_failed_total)) or vector(0)",
          "hide": false,
          "instant": true,
          "interval": "",
          "legendFormat": "Failed",
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
          "expr": "sum(max by (template_name, preset_name) (coderd_prebuilt_workspaces_claimed_total)) or vector(0)",
          "hide": false,
          "instant": true,
          "interval": "",
          "legendFormat": "Claimed",
          "range": false,
          "refId": "A"
        }
      ],
      "title": "All Time: Global",
      "type": "stat"
    },
    {
      "collapsed": false,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 4
      },
      "id": 2,
      "panels": [],
      "repeat": "preset",
      "title": "$preset",
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
            "fixedColor": "text",
            "mode": "fixed"
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": 0
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
        "h": 3,
        "w": 6,
        "x": 0,
        "y": 5
      },
      "id": 1,
      "interval": "30s",
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "center",
        "orientation": "vertical",
        "percentChangeColorMode": "standard",
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
      "pluginVersion": "12.1.0",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "prometheus"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "max(coderd_prebuilt_workspaces_created_total{template_name=~\"$template\", preset_name=~\"$preset\"}) or vector(0)",
          "hide": false,
          "instant": true,
          "interval": "",
          "legendFormat": "Created",
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
          "expr": "max(coderd_prebuilt_workspaces_failed_total{template_name=~\"$template\", preset_name=~\"$preset\"}) or vector(0)",
          "hide": false,
          "instant": true,
          "interval": "",
          "legendFormat": "Failed",
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
          "expr": "max(coderd_prebuilt_workspaces_claimed_total{template_name=~\"$template\", preset_name=~\"$preset\"}) or vector(0)",
          "hide": false,
          "instant": true,
          "interval": "",
          "legendFormat": "Claimed",
          "range": false,
          "refId": "A"
        }
      ],
      "title": "All Time: $preset",
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
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "axisSoftMax": 10,
            "axisSoftMin": 0,
            "barAlignment": 0,
            "barWidthFactor": 0.6,
            "drawStyle": "line",
            "fillOpacity": 13,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "smooth",
            "lineStyle": {
              "fill": "solid"
            },
            "lineWidth": 2,
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
          "decimals": 0,
          "fieldMinMax": false,
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": 0
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": [
          {
            "matcher": {
              "id": "byName",
              "options": "Failed"
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
              "options": "Created"
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
          },
          {
            "matcher": {
              "id": "byName",
              "options": "Desired"
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
              "options": "Running"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "yellow",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "Eligible"
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
              "options": "Claimed"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "dark-green",
                  "mode": "fixed"
                }
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 6,
        "w": 9,
        "x": 6,
        "y": 5
      },
      "id": 38,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "hideZeros": false,
          "mode": "single",
          "sort": "none"
        }
      },
      "pluginVersion": "12.1.0",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "prometheus"
          },
          "editorMode": "code",
          "expr": "floor(max(increase(coderd_prebuilt_workspaces_created_total{template_name=~\"$template\", preset_name=~\"$preset\"}[$__rate_interval]))) or vector(0)",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "Created",
          "range": true,
          "refId": "B"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "prometheus"
          },
          "editorMode": "code",
          "expr": "floor(max(increase(coderd_prebuilt_workspaces_failed_total{template_name=~\"$template\", preset_name=~\"$preset\"}[$__rate_interval]))) or vector(0)",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "Failed",
          "range": true,
          "refId": "C"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "prometheus"
          },
          "editorMode": "code",
          "expr": "floor(max(increase(coderd_prebuilt_workspaces_claimed_total{template_name=~\"$template\", preset_name=~\"$preset\"}[$__rate_interval]))) or vector(0)",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "Claimed",
          "range": true,
          "refId": "F"
        }
      ],
      "title": "Pool Operations: $preset",
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
            "axisSoftMax": 10,
            "axisSoftMin": 0,
            "barAlignment": 0,
            "barWidthFactor": 0.6,
            "drawStyle": "line",
            "fillOpacity": 18,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "smooth",
            "lineStyle": {
              "fill": "solid"
            },
            "lineWidth": 2,
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
          "decimals": 0,
          "fieldMinMax": false,
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": 0
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": [
          {
            "matcher": {
              "id": "byName",
              "options": "Desired"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "purple",
                  "mode": "fixed"
                }
              },
              {
                "id": "custom.lineStyle",
                "value": {
                  "dash": [
                    10,
                    10
                  ],
                  "fill": "dash"
                }
              },
              {
                "id": "custom.fillOpacity",
                "value": 85
              },
              {
                "id": "custom.fillBelowTo",
                "value": "Running"
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "Running"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "yellow",
                  "mode": "fixed"
                }
              },
              {
                "id": "custom.fillBelowTo",
                "value": "Eligible"
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "Eligible"
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
          }
        ]
      },
      "gridPos": {
        "h": 6,
        "w": 9,
        "x": 15,
        "y": 5
      },
      "id": 5,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "hideZeros": false,
          "mode": "single",
          "sort": "none"
        }
      },
      "pluginVersion": "12.1.0",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "prometheus"
          },
          "editorMode": "code",
          "expr": "max(coderd_prebuilt_workspaces_desired{template_name=~\"$template\", preset_name=~\"$preset\"}) or vector(0)",
          "instant": false,
          "interval": "",
          "legendFormat": "Desired",
          "range": true,
          "refId": "A"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "prometheus"
          },
          "editorMode": "code",
          "expr": "max(coderd_prebuilt_workspaces_running{template_name=~\"$template\", preset_name=~\"$preset\"}) or vector(0)",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "Running",
          "range": true,
          "refId": "D"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "prometheus"
          },
          "editorMode": "code",
          "expr": "max(coderd_prebuilt_workspaces_eligible{template_name=~\"$template\", preset_name=~\"$preset\"}) or vector(0)",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "Eligible",
          "range": true,
          "refId": "E"
        }
      ],
      "title": "Pool Capacity: $preset",
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
            "fixedColor": "text",
            "mode": "fixed"
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": 0
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
        "h": 3,
        "w": 6,
        "x": 0,
        "y": 8
      },
      "id": 31,
      "interval": "30s",
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "center",
        "orientation": "vertical",
        "percentChangeColorMode": "standard",
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
      "pluginVersion": "12.1.0",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "prometheus"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "max(coderd_prebuilt_workspaces_desired{template_name=~\"$template\", preset_name=~\"$preset\"}) or vector(0)",
          "instant": true,
          "interval": "",
          "legendFormat": "Desired",
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
          "expr": "max(coderd_prebuilt_workspaces_running{template_name=~\"$template\", preset_name=~\"$preset\"}) or vector(0)",
          "hide": false,
          "instant": true,
          "interval": "",
          "legendFormat": "Running",
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
          "expr": "max(coderd_prebuilt_workspaces_eligible{template_name=~\"$template\", preset_name=~\"$preset\"}) or vector(0)",
          "hide": false,
          "instant": true,
          "interval": "",
          "legendFormat": "Eligible",
          "range": false,
          "refId": "E"
        }
      ],
      "title": "Current: $preset",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "prometheus"
      },
      "description": "Compares the total number of regular workspace creations to prebuilt workspace claims to date.",
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
                "value": 0
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
        "h": 3,
        "w": 6,
        "x": 0,
        "y": 11
      },
      "id": 51,
      "options": {
        "colorMode": "none",
        "graphMode": "none",
        "justifyMode": "auto",
        "orientation": "horizontal",
        "percentChangeColorMode": "standard",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "textMode": "value_and_name",
        "wideLayout": true
      },
      "pluginVersion": "12.1.0",
      "targets": [
        {
          "editorMode": "code",
          "exemplar": false,
          "expr": "sum(max by (template_name, preset_name) (\n  coderd_workspace_creation_total{\n    template_name=~\"$template\", preset_name=~\"$preset\"\n  }\n)) or vector(0)",
          "instant": false,
          "legendFormat": "Regular workspaces created",
          "range": true,
          "refId": "A"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "prometheus"
          },
          "editorMode": "code",
          "expr": "sum(max by (template_name, preset_name) (\n  coderd_prebuilt_workspaces_claimed_total{\n    template_name=~\"$template\", preset_name=~\"$preset\"\n  }\n)) or vector(0)\n",
          "hide": false,
          "instant": false,
          "legendFormat": "Prebuilt workspaces claimed",
          "range": true,
          "refId": "B"
        }
      ],
      "title": "All Time: Regular vs Prebuilt",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "prometheus"
      },
      "description": "Median (p50) build time in seconds for Regular Workspace Creation, Prebuilt Workspace Creation, and Prebuilt Workspace Claim",
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
            "barWidthFactor": 0.6,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "smooth",
            "lineStyle": {
              "dash": [
                10,
                10
              ],
              "fill": "dash"
            },
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
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": 0
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
              "options": "Regular Creation"
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
          },
          {
            "matcher": {
              "id": "byName",
              "options": "Prebuild Creation"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "yellow",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "Prebuilt Claim"
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
          }
        ]
      },
      "gridPos": {
        "h": 6,
        "w": 9,
        "x": 6,
        "y": 11
      },
      "id": 50,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "hideZeros": false,
          "mode": "single",
          "sort": "none"
        }
      },
      "pluginVersion": "12.1.0",
      "targets": [
        {
          "editorMode": "code",
          "expr": "histogram_quantile(0.5,\n  sum(\n    coderd_workspace_creation_duration_seconds{\n      template_name=~\"$template\", preset_name=~\"$preset\", type=\"regular\"\n    }\n  )\n)\nor vector(0)",
          "legendFormat": "Regular Creation",
          "range": true,
          "refId": "A"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "prometheus"
          },
          "editorMode": "code",
          "expr": "histogram_quantile(0.5,\n  sum(\n    coderd_workspace_creation_duration_seconds{\n      template_name=~\"$template\", preset_name=~\"$preset\", type=\"prebuild\"\n    }\n  )\n)\nor vector(0)",
          "hide": false,
          "instant": false,
          "legendFormat": "Prebuild Creation",
          "range": true,
          "refId": "B"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "prometheus"
          },
          "editorMode": "code",
          "expr": "histogram_quantile(0.5,\n  sum(\n    coderd_prebuilt_workspace_claim_duration_seconds{\n      template_name=~\"$template\", preset_name=~\"$preset\"\n    }\n  )\n)\nor vector(0)",
          "hide": false,
          "instant": false,
          "legendFormat": "Prebuild Claim",
          "range": true,
          "refId": "C"
        }
      ],
      "title": "Workspace Build Latency p50",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "prometheus"
      },
      "description": "95th-percentile (p95) build time in seconds for Regular Workspace Creation, Prebuilt Workspace Creation, and Prebuilt Workspace Claim.",
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
            "barWidthFactor": 0.6,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "smooth",
            "lineStyle": {
              "dash": [
                10,
                10
              ],
              "fill": "dash"
            },
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
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": 0
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
              "options": "Regular Creation"
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
          },
          {
            "matcher": {
              "id": "byName",
              "options": "Prebuild Creation"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "yellow",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "Prebuilt Claim"
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
          }
        ]
      },
      "gridPos": {
        "h": 6,
        "w": 9,
        "x": 15,
        "y": 11
      },
      "id": 53,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "hideZeros": false,
          "mode": "single",
          "sort": "none"
        }
      },
      "pluginVersion": "12.1.0",
      "targets": [
        {
          "editorMode": "code",
          "expr": "histogram_quantile(0.95,\n  sum(\n    coderd_workspace_creation_duration_seconds{\n      template_name=~\"$template\", preset_name=~\"$preset\", type=\"regular\"\n    }\n  )\n)\nor vector(0)",
          "legendFormat": "Regular Creation",
          "range": true,
          "refId": "A"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "prometheus"
          },
          "editorMode": "code",
          "expr": "histogram_quantile(0.95,\n  sum(\n    coderd_workspace_creation_duration_seconds{\n      template_name=~\"$template\", preset_name=~\"$preset\", type=\"prebuild\"\n    }\n  )\n)\nor vector(0)",
          "hide": false,
          "instant": false,
          "legendFormat": "Prebuild Creation",
          "range": true,
          "refId": "B"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "prometheus"
          },
          "editorMode": "code",
          "expr": "histogram_quantile(0.95,\n  sum(\n    coderd_prebuilt_workspace_claim_duration_seconds{\n      template_name=~\"$template\", preset_name=~\"$preset\"\n    }\n  )\n)\nor vector(0)",
          "hide": false,
          "instant": false,
          "legendFormat": "Prebuild Claim",
          "range": true,
          "refId": "C"
        }
      ],
      "title": "Workspace Build Latency p95",
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
          "mappings": [],
          "max": 100,
          "min": 0,
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "red",
                "value": 0
              },
              {
                "color": "#EAB839",
                "value": 50
              },
              {
                "color": "green",
                "value": 75
              }
            ]
          },
          "unit": "percent"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 3,
        "w": 6,
        "x": 0,
        "y": 14
      },
      "id": 54,
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "auto",
        "orientation": "auto",
        "percentChangeColorMode": "standard",
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
      "pluginVersion": "12.1.0",
      "targets": [
        {
          "editorMode": "code",
          "expr": "clamp_max(\n  100 *\n  (\n    sum(\n      coderd_prebuilt_workspaces_claimed_total{\n        template_name=\"$template\", preset_name=\"$preset\"\n      }\n    ) or vector(0)\n  )\n  /\n  clamp_min(\n    ( \n      sum(\n        coderd_prebuilt_workspaces_claimed_total{\n          template_name=\"$template\", preset_name=\"$preset\"\n        }\n      ) or vector(0))\n    +\n    (\n      sum(\n        coderd_workspace_creation_total{\n          template_name=\"$template\", preset_name=\"$preset\"\n        }\n      ) or vector(0)),\n    1\n  ),\n  100\n)",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "All Time: Prebuilds Usage %",
      "type": "stat"
    }
  ],
  "preload": false,
  "refresh": "{{- include "dashboard-refresh" . -}}",
  "schemaVersion": 41,
  "tags": [],
  "templating": {
    "list": [
      {
        "current": {
          "text": "coder",
          "value": "coder"
        },
        "datasource": {
          "type": "prometheus",
          "uid": "prometheus"
        },
        "definition": "label_values(coderd_prebuilt_workspaces_desired,template_name)",
        "includeAll": false,
        "label": "Template",
        "name": "template",
        "options": [],
        "query": {
          "qryType": 1,
          "query": "label_values(coderd_prebuilt_workspaces_desired,template_name)",
          "refId": "PrometheusVariableQueryEditor-VariableQuery"
        },
        "refresh": 1,
        "regex": "",
        "type": "query"
      },
      {
        "current": {
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
        "definition": "label_values(coderd_prebuilt_workspaces_desired{template_name=~\"$template\"},preset_name)",
        "includeAll": true,
        "label": "Preset",
        "multi": true,
        "name": "preset",
        "options": [],
        "query": {
          "qryType": 1,
          "query": "label_values(coderd_prebuilt_workspaces_desired{template_name=~\"$template\"},preset_name)",
          "refId": "PrometheusVariableQueryEditor-VariableQuery"
        },
        "refresh": 1,
        "regex": "",
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
  "title": "Prebuilds",
  "uid": "cej6jysyme22oa",
  "version": 5
}
{{ end }}