{{ define "derp-dashboard.json" }}
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
      "collapsed": false,
      "gridPos": { "h": 1, "w": 24, "x": 0, "y": 0 },
      "id": 1,
      "title": "Connections",
      "type": "row"
    },
    {
      "datasource": { "type": "prometheus", "uid": "prometheus" },
      "fieldConfig": {
        "defaults": {
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              { "color": "green", "value": null }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": { "h": 8, "w": 4, "x": 0, "y": 1 },
      "id": 2,
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "auto",
        "orientation": "auto",
        "reduceOptions": {
          "calcs": ["lastNotNull"],
          "fields": "",
          "values": false
        },
        "textMode": "auto"
      },
      "title": "Current Connections",
      "type": "stat",
      "targets": [
        {
          "datasource": { "type": "prometheus", "uid": "prometheus" },
          "editorMode": "code",
          "expr": "sum(coder_derp_server_connections)",
          "legendFormat": "__auto",
          "refId": "A"
        }
      ]
    },
    {
      "datasource": { "type": "prometheus", "uid": "prometheus" },
      "fieldConfig": {
        "defaults": {
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              { "color": "green", "value": null }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": { "h": 8, "w": 4, "x": 4, "y": 1 },
      "id": 3,
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "auto",
        "orientation": "auto",
        "reduceOptions": {
          "calcs": ["lastNotNull"],
          "fields": "",
          "values": false
        },
        "textMode": "auto"
      },
      "title": "Home Connections",
      "type": "stat",
      "targets": [
        {
          "datasource": { "type": "prometheus", "uid": "prometheus" },
          "editorMode": "code",
          "expr": "sum(coder_derp_server_home_connections)",
          "legendFormat": "__auto",
          "refId": "A"
        }
      ]
    },
    {
      "datasource": { "type": "prometheus", "uid": "prometheus" },
      "fieldConfig": {
        "defaults": {
          "custom": {
            "drawStyle": "line",
            "fillOpacity": 10,
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "showPoints": "auto",
            "spanNulls": false
          },
          "unit": "none"
        },
        "overrides": []
      },
      "gridPos": { "h": 8, "w": 8, "x": 8, "y": 1 },
      "id": 4,
      "options": {
        "legend": { "calcs": [], "displayMode": "list", "placement": "bottom" },
        "tooltip": { "mode": "single", "sort": "none" }
      },
      "title": "Accepts Rate",
      "type": "timeseries",
      "targets": [
        {
          "datasource": { "type": "prometheus", "uid": "prometheus" },
          "editorMode": "code",
          "expr": "sum by (instance) (rate(coder_derp_server_accepts_total[$__rate_interval]))",
          "legendFormat": "{{ "{{" }}instance{{ "}}" }}",
          "refId": "A"
        }
      ]
    },
    {
      "datasource": { "type": "prometheus", "uid": "prometheus" },
      "fieldConfig": {
        "defaults": {
          "custom": {
            "drawStyle": "line",
            "fillOpacity": 10,
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": { "group": "A", "mode": "normal" }
          },
          "unit": "none"
        },
        "overrides": []
      },
      "gridPos": { "h": 8, "w": 8, "x": 16, "y": 1 },
      "id": 5,
      "options": {
        "legend": { "calcs": [], "displayMode": "list", "placement": "bottom" },
        "tooltip": { "mode": "single", "sort": "none" }
      },
      "title": "Clients",
      "type": "timeseries",
      "targets": [
        {
          "datasource": { "type": "prometheus", "uid": "prometheus" },
          "editorMode": "code",
          "expr": "sum by (instance) (coder_derp_server_clients_local)",
          "legendFormat": "Local - {{ "{{" }}instance{{ "}}" }}",
          "refId": "A"
        },
        {
          "datasource": { "type": "prometheus", "uid": "prometheus" },
          "editorMode": "code",
          "expr": "sum by (instance) (coder_derp_server_clients_remote)",
          "legendFormat": "Remote - {{ "{{" }}instance{{ "}}" }}",
          "refId": "B"
        }
      ]
    },
    {
      "collapsed": false,
      "gridPos": { "h": 1, "w": 24, "x": 0, "y": 9 },
      "id": 6,
      "title": "Throughput",
      "type": "row"
    },
    {
      "datasource": { "type": "prometheus", "uid": "prometheus" },
      "fieldConfig": {
        "defaults": {
          "custom": {
            "drawStyle": "line",
            "fillOpacity": 10,
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "showPoints": "auto",
            "spanNulls": false
          },
          "unit": "Bps"
        },
        "overrides": []
      },
      "gridPos": { "h": 8, "w": 8, "x": 0, "y": 10 },
      "id": 7,
      "options": {
        "legend": { "calcs": [], "displayMode": "list", "placement": "bottom" },
        "tooltip": { "mode": "single", "sort": "none" }
      },
      "title": "Bytes Rate",
      "type": "timeseries",
      "targets": [
        {
          "datasource": { "type": "prometheus", "uid": "prometheus" },
          "editorMode": "code",
          "expr": "sum by (instance) (rate(coder_derp_server_bytes_received_total[$__rate_interval]))",
          "legendFormat": "Received - {{ "{{" }}instance{{ "}}" }}",
          "refId": "A"
        },
        {
          "datasource": { "type": "prometheus", "uid": "prometheus" },
          "editorMode": "code",
          "expr": "sum by (instance) (rate(coder_derp_server_bytes_sent_total[$__rate_interval]))",
          "legendFormat": "Sent - {{ "{{" }}instance{{ "}}" }}",
          "refId": "B"
        }
      ]
    },
    {
      "datasource": { "type": "prometheus", "uid": "prometheus" },
      "fieldConfig": {
        "defaults": {
          "custom": {
            "drawStyle": "line",
            "fillOpacity": 10,
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "showPoints": "auto",
            "spanNulls": false
          },
          "unit": "none"
        },
        "overrides": []
      },
      "gridPos": { "h": 8, "w": 8, "x": 8, "y": 10 },
      "id": 8,
      "options": {
        "legend": { "calcs": [], "displayMode": "list", "placement": "bottom" },
        "tooltip": { "mode": "single", "sort": "none" }
      },
      "title": "Packets Rate",
      "type": "timeseries",
      "targets": [
        {
          "datasource": { "type": "prometheus", "uid": "prometheus" },
          "editorMode": "code",
          "expr": "sum by (instance) (rate(coder_derp_server_packets_received_total[$__rate_interval]))",
          "legendFormat": "Received - {{ "{{" }}instance{{ "}}" }}",
          "refId": "A"
        },
        {
          "datasource": { "type": "prometheus", "uid": "prometheus" },
          "editorMode": "code",
          "expr": "sum by (instance) (rate(coder_derp_server_packets_sent_total[$__rate_interval]))",
          "legendFormat": "Sent - {{ "{{" }}instance{{ "}}" }}",
          "refId": "B"
        }
      ]
    },
    {
      "datasource": { "type": "prometheus", "uid": "prometheus" },
      "fieldConfig": {
        "defaults": {
          "custom": {
            "drawStyle": "line",
            "fillOpacity": 10,
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "showPoints": "auto",
            "spanNulls": false
          },
          "unit": "none"
        },
        "overrides": []
      },
      "gridPos": { "h": 8, "w": 8, "x": 16, "y": 10 },
      "id": 9,
      "options": {
        "legend": { "calcs": [], "displayMode": "list", "placement": "bottom" },
        "tooltip": { "mode": "single", "sort": "none" }
      },
      "title": "Packets by Kind",
      "type": "timeseries",
      "targets": [
        {
          "datasource": { "type": "prometheus", "uid": "prometheus" },
          "editorMode": "code",
          "expr": "sum by (instance, kind) (rate(coder_derp_server_packets_received_kind_total[$__rate_interval]))",
          "legendFormat": "{{ "{{" }}kind{{ "}}" }} - {{ "{{" }}instance{{ "}}" }}",
          "refId": "A"
        }
      ]
    },
    {
      "collapsed": false,
      "gridPos": { "h": 1, "w": 24, "x": 0, "y": 18 },
      "id": 10,
      "title": "Drops & Errors",
      "type": "row"
    },
    {
      "datasource": { "type": "prometheus", "uid": "prometheus" },
      "fieldConfig": {
        "defaults": {
          "custom": {
            "drawStyle": "line",
            "fillOpacity": 10,
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "showPoints": "auto",
            "spanNulls": false
          },
          "unit": "none"
        },
        "overrides": []
      },
      "gridPos": { "h": 8, "w": 6, "x": 0, "y": 19 },
      "id": 11,
      "options": {
        "legend": { "calcs": [], "displayMode": "list", "placement": "bottom" },
        "tooltip": { "mode": "single", "sort": "none" }
      },
      "title": "Packet Drop Rate",
      "type": "timeseries",
      "targets": [
        {
          "datasource": { "type": "prometheus", "uid": "prometheus" },
          "editorMode": "code",
          "expr": "sum by (instance) (rate(coder_derp_server_packets_dropped_total[$__rate_interval]))",
          "legendFormat": "{{ "{{" }}instance{{ "}}" }}",
          "refId": "A"
        }
      ]
    },
    {
      "datasource": { "type": "prometheus", "uid": "prometheus" },
      "fieldConfig": {
        "defaults": {
          "custom": {
            "drawStyle": "line",
            "fillOpacity": 10,
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "showPoints": "auto",
            "spanNulls": false
          },
          "unit": "none"
        },
        "overrides": []
      },
      "gridPos": { "h": 8, "w": 6, "x": 6, "y": 19 },
      "id": 12,
      "options": {
        "legend": { "calcs": [], "displayMode": "list", "placement": "bottom" },
        "tooltip": { "mode": "single", "sort": "none" }
      },
      "title": "Drops by Reason",
      "type": "timeseries",
      "targets": [
        {
          "datasource": { "type": "prometheus", "uid": "prometheus" },
          "editorMode": "code",
          "expr": "sum by (instance, reason) (rate(coder_derp_server_packets_dropped_reason_total[$__rate_interval]))",
          "legendFormat": "{{ "{{" }}reason{{ "}}" }} - {{ "{{" }}instance{{ "}}" }}",
          "refId": "A"
        }
      ]
    },
    {
      "datasource": { "type": "prometheus", "uid": "prometheus" },
      "fieldConfig": {
        "defaults": {
          "custom": {
            "drawStyle": "line",
            "fillOpacity": 10,
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "showPoints": "auto",
            "spanNulls": false
          },
          "unit": "none"
        },
        "overrides": []
      },
      "gridPos": { "h": 8, "w": 6, "x": 12, "y": 19 },
      "id": 13,
      "options": {
        "legend": { "calcs": [], "displayMode": "list", "placement": "bottom" },
        "tooltip": { "mode": "single", "sort": "none" }
      },
      "title": "Drops by Type",
      "type": "timeseries",
      "targets": [
        {
          "datasource": { "type": "prometheus", "uid": "prometheus" },
          "editorMode": "code",
          "expr": "sum by (instance, type) (rate(coder_derp_server_packets_dropped_type_total[$__rate_interval]))",
          "legendFormat": "{{ "{{" }}type{{ "}}" }} - {{ "{{" }}instance{{ "}}" }}",
          "refId": "A"
        }
      ]
    },
    {
      "datasource": { "type": "prometheus", "uid": "prometheus" },
      "fieldConfig": {
        "defaults": {
          "custom": {
            "drawStyle": "line",
            "fillOpacity": 10,
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "showPoints": "auto",
            "spanNulls": false
          },
          "unit": "none"
        },
        "overrides": []
      },
      "gridPos": { "h": 8, "w": 6, "x": 18, "y": 19 },
      "id": 14,
      "options": {
        "legend": { "calcs": [], "displayMode": "list", "placement": "bottom" },
        "tooltip": { "mode": "single", "sort": "none" }
      },
      "title": "Unknown Frames",
      "type": "timeseries",
      "targets": [
        {
          "datasource": { "type": "prometheus", "uid": "prometheus" },
          "editorMode": "code",
          "expr": "sum by (instance) (rate(coder_derp_server_unknown_frames_total[$__rate_interval]))",
          "legendFormat": "{{ "{{" }}instance{{ "}}" }}",
          "refId": "A"
        }
      ]
    },
    {
      "collapsed": false,
      "gridPos": { "h": 1, "w": 24, "x": 0, "y": 27 },
      "id": 15,
      "title": "Mesh & Peering",
      "type": "row"
    },
    {
      "datasource": { "type": "prometheus", "uid": "prometheus" },
      "fieldConfig": {
        "defaults": {
          "custom": {
            "drawStyle": "line",
            "fillOpacity": 10,
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "showPoints": "auto",
            "spanNulls": false
          },
          "unit": "none"
        },
        "overrides": []
      },
      "gridPos": { "h": 8, "w": 8, "x": 0, "y": 28 },
      "id": 16,
      "options": {
        "legend": { "calcs": [], "displayMode": "list", "placement": "bottom" },
        "tooltip": { "mode": "single", "sort": "none" }
      },
      "title": "Forwarded Packets",
      "type": "timeseries",
      "targets": [
        {
          "datasource": { "type": "prometheus", "uid": "prometheus" },
          "editorMode": "code",
          "expr": "sum by (instance) (rate(coder_derp_server_packets_forwarded_in_total[$__rate_interval]))",
          "legendFormat": "In - {{ "{{" }}instance{{ "}}" }}",
          "refId": "A"
        },
        {
          "datasource": { "type": "prometheus", "uid": "prometheus" },
          "editorMode": "code",
          "expr": "sum by (instance) (rate(coder_derp_server_packets_forwarded_out_total[$__rate_interval]))",
          "legendFormat": "Out - {{ "{{" }}instance{{ "}}" }}",
          "refId": "B"
        }
      ]
    },
    {
      "datasource": { "type": "prometheus", "uid": "prometheus" },
      "fieldConfig": {
        "defaults": {
          "custom": {
            "drawStyle": "line",
            "fillOpacity": 10,
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "showPoints": "auto",
            "spanNulls": false
          },
          "unit": "none"
        },
        "overrides": []
      },
      "gridPos": { "h": 8, "w": 8, "x": 8, "y": 28 },
      "id": 17,
      "options": {
        "legend": { "calcs": [], "displayMode": "list", "placement": "bottom" },
        "tooltip": { "mode": "single", "sort": "none" }
      },
      "title": "Peer Gone",
      "type": "timeseries",
      "targets": [
        {
          "datasource": { "type": "prometheus", "uid": "prometheus" },
          "editorMode": "code",
          "expr": "sum by (instance) (rate(coder_derp_server_peer_gone_disconnected_total[$__rate_interval]))",
          "legendFormat": "Disconnected - {{ "{{" }}instance{{ "}}" }}",
          "refId": "A"
        },
        {
          "datasource": { "type": "prometheus", "uid": "prometheus" },
          "editorMode": "code",
          "expr": "sum by (instance) (rate(coder_derp_server_peer_gone_not_here_total[$__rate_interval]))",
          "legendFormat": "Not Here - {{ "{{" }}instance{{ "}}" }}",
          "refId": "B"
        }
      ]
    },
    {
      "datasource": { "type": "prometheus", "uid": "prometheus" },
      "fieldConfig": {
        "defaults": {
          "custom": {
            "drawStyle": "line",
            "fillOpacity": 10,
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "showPoints": "auto",
            "spanNulls": false
          },
          "unit": "none"
        },
        "overrides": []
      },
      "gridPos": { "h": 8, "w": 8, "x": 16, "y": 28 },
      "id": 18,
      "options": {
        "legend": { "calcs": [], "displayMode": "list", "placement": "bottom" },
        "tooltip": { "mode": "single", "sort": "none" }
      },
      "title": "Home Moves",
      "type": "timeseries",
      "targets": [
        {
          "datasource": { "type": "prometheus", "uid": "prometheus" },
          "editorMode": "code",
          "expr": "sum by (instance) (rate(coder_derp_server_home_moves_in_total[$__rate_interval]))",
          "legendFormat": "In - {{ "{{" }}instance{{ "}}" }}",
          "refId": "A"
        },
        {
          "datasource": { "type": "prometheus", "uid": "prometheus" },
          "editorMode": "code",
          "expr": "sum by (instance) (rate(coder_derp_server_home_moves_out_total[$__rate_interval]))",
          "legendFormat": "Out - {{ "{{" }}instance{{ "}}" }}",
          "refId": "B"
        }
      ]
    },
    {
      "collapsed": false,
      "gridPos": { "h": 1, "w": 24, "x": 0, "y": 36 },
      "id": 19,
      "title": "Health",
      "type": "row"
    },
    {
      "datasource": { "type": "prometheus", "uid": "prometheus" },
      "fieldConfig": {
        "defaults": {
          "custom": {
            "drawStyle": "line",
            "fillOpacity": 10,
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "showPoints": "auto",
            "spanNulls": false
          },
          "unit": "ms"
        },
        "overrides": []
      },
      "gridPos": { "h": 8, "w": 8, "x": 0, "y": 37 },
      "id": 20,
      "options": {
        "legend": { "calcs": [], "displayMode": "list", "placement": "bottom" },
        "tooltip": { "mode": "single", "sort": "none" }
      },
      "title": "Average Queue Duration",
      "type": "timeseries",
      "targets": [
        {
          "datasource": { "type": "prometheus", "uid": "prometheus" },
          "editorMode": "code",
          "expr": "coder_derp_server_average_queue_duration_ms",
          "legendFormat": "{{ "{{" }}instance{{ "}}" }}",
          "refId": "A"
        }
      ]
    },
    {
      "datasource": { "type": "prometheus", "uid": "prometheus" },
      "fieldConfig": {
        "defaults": {
          "custom": {
            "drawStyle": "line",
            "fillOpacity": 10,
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "showPoints": "auto",
            "spanNulls": false
          },
          "unit": "none"
        },
        "overrides": []
      },
      "gridPos": { "h": 8, "w": 8, "x": 8, "y": 37 },
      "id": 21,
      "options": {
        "legend": { "calcs": [], "displayMode": "list", "placement": "bottom" },
        "tooltip": { "mode": "single", "sort": "none" }
      },
      "title": "Ping / Pong",
      "type": "timeseries",
      "targets": [
        {
          "datasource": { "type": "prometheus", "uid": "prometheus" },
          "editorMode": "code",
          "expr": "sum by (instance) (rate(coder_derp_server_got_ping_total[$__rate_interval]))",
          "legendFormat": "Got Ping - {{ "{{" }}instance{{ "}}" }}",
          "refId": "A"
        },
        {
          "datasource": { "type": "prometheus", "uid": "prometheus" },
          "editorMode": "code",
          "expr": "sum by (instance) (rate(coder_derp_server_sent_pong_total[$__rate_interval]))",
          "legendFormat": "Sent Pong - {{ "{{" }}instance{{ "}}" }}",
          "refId": "B"
        }
      ]
    },
    {
      "datasource": { "type": "prometheus", "uid": "prometheus" },
      "fieldConfig": {
        "defaults": {
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              { "color": "green", "value": null }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": { "h": 8, "w": 8, "x": 16, "y": 37 },
      "id": 22,
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "auto",
        "orientation": "auto",
        "reduceOptions": {
          "calcs": ["lastNotNull"],
          "fields": "",
          "values": false
        },
        "textMode": "auto"
      },
      "title": "Watchers",
      "type": "stat",
      "targets": [
        {
          "datasource": { "type": "prometheus", "uid": "prometheus" },
          "editorMode": "code",
          "expr": "sum(coder_derp_server_watchers)",
          "legendFormat": "__auto",
          "refId": "A"
        }
      ]
    }
  ],
  "refresh": "{{- include "dashboard-refresh" . -}}",
  "schemaVersion": 39,
  "tags": [],
  "templating": {
    "list": []
  },
  "time": {
    "from": "now-{{- include "dashboard-range" . -}}",
    "to": "now"
  },
  "timepicker": {},
  "timezone": "browser",
  "title": "DERP",
  "uid": "derp",
  "version": 1,
  "weekStart": ""
}
{{ end }}
