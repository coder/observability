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
      "gridPos": { "h": 8, "w": 8, "x": 0, "y": 1 },
      "id": 2,
      "options": {
        "legend": { "calcs": [], "displayMode": "list", "placement": "bottom" },
        "tooltip": { "mode": "single", "sort": "none" }
      },
      "title": "Current Connections",
      "type": "timeseries",
      "targets": [
        {
          "datasource": { "type": "prometheus", "uid": "prometheus" },
          "editorMode": "code",
          "expr": "sum by (pod) (coder_derp_server_connections)",
          "legendFormat": "{{ "{{" }}pod{{ "}}" }}",
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
      "id": 3,
      "options": {
        "legend": { "calcs": [], "displayMode": "list", "placement": "bottom" },
        "tooltip": { "mode": "single", "sort": "none" }
      },
      "title": "Home Connections",
      "type": "timeseries",
      "targets": [
        {
          "datasource": { "type": "prometheus", "uid": "prometheus" },
          "editorMode": "code",
          "expr": "sum by (pod) (coder_derp_server_home_connections)",
          "legendFormat": "{{ "{{" }}pod{{ "}}" }}",
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
      "gridPos": { "h": 8, "w": 8, "x": 16, "y": 1 },
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
          "expr": "sum by (pod) (rate(coder_derp_server_accepts_total[$__rate_interval]))",
          "legendFormat": "{{ "{{" }}pod{{ "}}" }}",
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
      "gridPos": { "h": 8, "w": 24, "x": 0, "y": 9 },
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
          "expr": "sum by (pod) (coder_derp_server_clients_local)",
          "legendFormat": "Local - {{ "{{" }}pod{{ "}}" }}",
          "refId": "A"
        },
        {
          "datasource": { "type": "prometheus", "uid": "prometheus" },
          "editorMode": "code",
          "expr": "sum by (pod) (coder_derp_server_clients_remote)",
          "legendFormat": "Remote - {{ "{{" }}pod{{ "}}" }}",
          "refId": "B"
        }
      ]
    },
    {
      "collapsed": false,
      "gridPos": { "h": 1, "w": 24, "x": 0, "y": 17 },
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
      "gridPos": { "h": 8, "w": 8, "x": 0, "y": 18 },
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
          "expr": "sum by (pod) (rate(coder_derp_server_bytes_received_total[$__rate_interval]))",
          "legendFormat": "Received - {{ "{{" }}pod{{ "}}" }}",
          "refId": "A"
        },
        {
          "datasource": { "type": "prometheus", "uid": "prometheus" },
          "editorMode": "code",
          "expr": "sum by (pod) (rate(coder_derp_server_bytes_sent_total[$__rate_interval]))",
          "legendFormat": "Sent - {{ "{{" }}pod{{ "}}" }}",
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
      "gridPos": { "h": 8, "w": 8, "x": 8, "y": 18 },
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
          "expr": "sum by (pod) (rate(coder_derp_server_packets_received_total[$__rate_interval]))",
          "legendFormat": "Received - {{ "{{" }}pod{{ "}}" }}",
          "refId": "A"
        },
        {
          "datasource": { "type": "prometheus", "uid": "prometheus" },
          "editorMode": "code",
          "expr": "sum by (pod) (rate(coder_derp_server_packets_sent_total[$__rate_interval]))",
          "legendFormat": "Sent - {{ "{{" }}pod{{ "}}" }}",
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
      "gridPos": { "h": 8, "w": 8, "x": 16, "y": 18 },
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
          "expr": "sum by (pod, kind) (rate(coder_derp_server_packets_received_kind_total[$__rate_interval]))",
          "legendFormat": "{{ "{{" }}kind{{ "}}" }} - {{ "{{" }}pod{{ "}}" }}",
          "refId": "A"
        }
      ]
    },
    {
      "collapsed": false,
      "gridPos": { "h": 1, "w": 24, "x": 0, "y": 26 },
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
      "gridPos": { "h": 8, "w": 6, "x": 0, "y": 27 },
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
          "expr": "sum by (pod) (rate(coder_derp_server_packets_dropped_total[$__rate_interval]))",
          "legendFormat": "{{ "{{" }}pod{{ "}}" }}",
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
      "gridPos": { "h": 8, "w": 6, "x": 6, "y": 27 },
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
          "expr": "sum by (pod, reason) (rate(coder_derp_server_packets_dropped_reason_total[$__rate_interval]))",
          "legendFormat": "{{ "{{" }}reason{{ "}}" }} - {{ "{{" }}pod{{ "}}" }}",
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
      "gridPos": { "h": 8, "w": 6, "x": 12, "y": 27 },
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
          "expr": "sum by (pod, type) (rate(coder_derp_server_packets_dropped_type_total[$__rate_interval]))",
          "legendFormat": "{{ "{{" }}type{{ "}}" }} - {{ "{{" }}pod{{ "}}" }}",
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
      "gridPos": { "h": 8, "w": 6, "x": 18, "y": 27 },
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
          "expr": "sum by (pod) (rate(coder_derp_server_unknown_frames_total[$__rate_interval]))",
          "legendFormat": "{{ "{{" }}pod{{ "}}" }}",
          "refId": "A"
        }
      ]
    },
    {
      "collapsed": false,
      "gridPos": { "h": 1, "w": 24, "x": 0, "y": 35 },
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
      "gridPos": { "h": 8, "w": 8, "x": 0, "y": 36 },
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
          "expr": "sum by (pod) (rate(coder_derp_server_packets_forwarded_in_total[$__rate_interval]))",
          "legendFormat": "In - {{ "{{" }}pod{{ "}}" }}",
          "refId": "A"
        },
        {
          "datasource": { "type": "prometheus", "uid": "prometheus" },
          "editorMode": "code",
          "expr": "sum by (pod) (rate(coder_derp_server_packets_forwarded_out_total[$__rate_interval]))",
          "legendFormat": "Out - {{ "{{" }}pod{{ "}}" }}",
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
      "gridPos": { "h": 8, "w": 8, "x": 8, "y": 36 },
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
          "expr": "sum by (pod) (rate(coder_derp_server_peer_gone_disconnected_total[$__rate_interval]))",
          "legendFormat": "Disconnected - {{ "{{" }}pod{{ "}}" }}",
          "refId": "A"
        },
        {
          "datasource": { "type": "prometheus", "uid": "prometheus" },
          "editorMode": "code",
          "expr": "sum by (pod) (rate(coder_derp_server_peer_gone_not_here_total[$__rate_interval]))",
          "legendFormat": "Not Here - {{ "{{" }}pod{{ "}}" }}",
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
      "gridPos": { "h": 8, "w": 8, "x": 16, "y": 36 },
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
          "expr": "sum by (pod) (rate(coder_derp_server_home_moves_in_total[$__rate_interval]))",
          "legendFormat": "In - {{ "{{" }}pod{{ "}}" }}",
          "refId": "A"
        },
        {
          "datasource": { "type": "prometheus", "uid": "prometheus" },
          "editorMode": "code",
          "expr": "sum by (pod) (rate(coder_derp_server_home_moves_out_total[$__rate_interval]))",
          "legendFormat": "Out - {{ "{{" }}pod{{ "}}" }}",
          "refId": "B"
        }
      ]
    },
    {
      "collapsed": false,
      "gridPos": { "h": 1, "w": 24, "x": 0, "y": 44 },
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
      "gridPos": { "h": 8, "w": 8, "x": 0, "y": 45 },
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
          "legendFormat": "{{ "{{" }}pod{{ "}}" }}",
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
      "gridPos": { "h": 8, "w": 8, "x": 8, "y": 45 },
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
          "expr": "sum by (pod) (rate(coder_derp_server_got_ping_total[$__rate_interval]))",
          "legendFormat": "Got Ping - {{ "{{" }}pod{{ "}}" }}",
          "refId": "A"
        },
        {
          "datasource": { "type": "prometheus", "uid": "prometheus" },
          "editorMode": "code",
          "expr": "sum by (pod) (rate(coder_derp_server_sent_pong_total[$__rate_interval]))",
          "legendFormat": "Sent Pong - {{ "{{" }}pod{{ "}}" }}",
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
      "gridPos": { "h": 8, "w": 8, "x": 16, "y": 45 },
      "id": 22,
      "options": {
        "legend": { "calcs": [], "displayMode": "list", "placement": "bottom" },
        "tooltip": { "mode": "single", "sort": "none" }
      },
      "title": "Watchers",
      "type": "timeseries",
      "targets": [
        {
          "datasource": { "type": "prometheus", "uid": "prometheus" },
          "editorMode": "code",
          "expr": "sum by (pod) (coder_derp_server_watchers)",
          "legendFormat": "{{ "{{" }}pod{{ "}}" }}",
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
