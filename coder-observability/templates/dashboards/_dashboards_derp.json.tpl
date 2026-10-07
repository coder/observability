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
      "title": "DERP Connections",
      "type": "row"
    },
    {
      "gridPos": { "h": 3, "w": 24, "x": 0, "y": 1 },
      "id": 24,
      "options": {
        "code": { "language": "plaintext", "showLineNumbers": false, "showMiniMap": false },
        "content": "DERP (Designated Encrypted Relay for Packets) relays traffic between Coder clients and workspaces when direct peer-to-peer connections aren't possible. **Current Connections** shows active WebSocket connections to each DERP server. **Home Connections** are clients that have selected this server as their primary relay. **Accepts Rate** shows new connections per second. **Clients** breaks down local (directly connected) vs remote (mesh-forwarded) clients.\n\n📌 **What to watch:** A sudden drop in connections may indicate a DERP server issue. A high ratio of remote to local clients suggests mesh forwarding is doing heavy lifting — this is normal in multi-region deployments. Zero connections on a server that should be active warrants investigation.",
        "mode": "markdown"
      },
      "pluginVersion": "11.4.0",
      "title": "",
      "type": "text",
      "transparent": true
    },
    {
      "datasource": { "type": "prometheus", "uid": "prometheus" },
      "fieldConfig": {
        "defaults": {
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [{ "color": "green", "value": null }]
          }
        },
        "overrides": []
      },
      "gridPos": { "h": 4, "w": 24, "x": 0, "y": 4 },
      "id": 23,
      "options": {
        "colorMode": "value",
        "graphMode": "none",
        "justifyMode": "auto",
        "orientation": "auto",
        "reduceOptions": { "calcs": ["lastNotNull"], "fields": "", "values": false },
        "textMode": "auto"
      },
      "targets": [
        {
          "datasource": { "type": "prometheus", "uid": "prometheus" },
          "expr": "sum(coder_derp_server_connections)",
          "legendFormat": "__auto"
        }
      ],
      "title": "Total Connections",
      "type": "stat"
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
      "gridPos": { "h": 8, "w": 8, "x": 0, "y": 8 },
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
      "gridPos": { "h": 8, "w": 8, "x": 8, "y": 8 },
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
      "gridPos": { "h": 8, "w": 8, "x": 16, "y": 8 },
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
      "gridPos": { "h": 8, "w": 24, "x": 0, "y": 16 },
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
      "gridPos": { "h": 1, "w": 24, "x": 0, "y": 24 },
      "id": 6,
      "title": "DERP Throughput",
      "type": "row"
    },
    {
      "gridPos": { "h": 3, "w": 24, "x": 0, "y": 25 },
      "id": 25,
      "options": {
        "code": { "language": "plaintext", "showLineNumbers": false, "showMiniMap": false },
        "content": "Bytes and packets flowing through the DERP relay. **Bytes Rate** shows bandwidth consumption (sent vs received should be roughly balanced). **Packets Rate** shows message throughput. **Packets by Kind** breaks down the types of packets being relayed.\n\n📌 **What to watch:** Large asymmetry between sent and received bytes could indicate one-directional traffic issues. Throughput scaling linearly with connections is normal. Sudden throughput drops with stable connection counts may indicate packet processing issues.",
        "mode": "markdown"
      },
      "pluginVersion": "11.4.0",
      "title": "",
      "type": "text",
      "transparent": true
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
      "gridPos": { "h": 8, "w": 8, "x": 0, "y": 28 },
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
      "gridPos": { "h": 8, "w": 8, "x": 8, "y": 28 },
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
          "unit": "pps"
        },
        "overrides": []
      },
      "gridPos": { "h": 8, "w": 8, "x": 16, "y": 28 },
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
      "gridPos": { "h": 1, "w": 24, "x": 0, "y": 36 },
      "id": 10,
      "title": "DERP Drops & Errors",
      "type": "row"
    },
    {
      "gridPos": { "h": 3, "w": 24, "x": 0, "y": 37 },
      "id": 26,
      "options": {
        "code": { "language": "plaintext", "showLineNumbers": false, "showMiniMap": false },
        "content": "Packets that couldn't be delivered. **Packet Drop Rate** is the overall drop rate. **Drops by Reason** shows why packets were dropped (e.g. queue full, unknown destination). **Drops by Type** categorizes by packet type. **Unknown Frames** are unrecognized protocol frames.\n\n📌 **What to watch:** Some drops are normal during client disconnects and reconnects — these are self-healing. Sustained high drop rates or drops with reason `queue_full` indicate the server is overloaded. Unknown frames at a consistent rate may indicate a client/server version mismatch.",
        "mode": "markdown"
      },
      "pluginVersion": "11.4.0",
      "title": "",
      "type": "text",
      "transparent": true
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
      "gridPos": { "h": 8, "w": 6, "x": 0, "y": 40 },
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
          "unit": "pps"
        },
        "overrides": []
      },
      "gridPos": { "h": 8, "w": 6, "x": 6, "y": 40 },
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
      "gridPos": { "h": 8, "w": 6, "x": 12, "y": 40 },
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
      "gridPos": { "h": 8, "w": 6, "x": 18, "y": 40 },
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
      "gridPos": { "h": 1, "w": 24, "x": 0, "y": 48 },
      "id": 15,
      "title": "DERP Mesh & Peering",
      "type": "row"
    },
    {
      "gridPos": { "h": 3, "w": 24, "x": 0, "y": 49 },
      "id": 27,
      "options": {
        "code": { "language": "plaintext", "showLineNumbers": false, "showMiniMap": false },
        "content": "Traffic forwarded between DERP servers in a mesh topology. **Forwarded Packets** shows packets relayed to/from other DERP servers. **Peer Gone** fires when a client disconnects or is looked up on the wrong server. **Home Moves** track clients migrating their home DERP server between regions.\n\n📌 **What to watch:** Peer Gone - Not Here at a low rate is normal as clients reconnect to different servers. High rates suggest frequent re-homing or routing issues. Home Moves correlate with clients changing networks or regions — occasional spikes are fine, sustained high rates may indicate instability.",
        "mode": "markdown"
      },
      "pluginVersion": "11.4.0",
      "title": "",
      "type": "text",
      "transparent": true
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
      "gridPos": { "h": 8, "w": 8, "x": 0, "y": 52 },
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
      "gridPos": { "h": 8, "w": 8, "x": 8, "y": 52 },
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
      "gridPos": { "h": 8, "w": 8, "x": 16, "y": 52 },
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
      "gridPos": { "h": 1, "w": 24, "x": 0, "y": 60 },
      "id": 19,
      "title": "DERP Health",
      "type": "row"
    },
    {
      "gridPos": { "h": 3, "w": 24, "x": 0, "y": 61 },
      "id": 28,
      "options": {
        "code": { "language": "plaintext", "showLineNumbers": false, "showMiniMap": false },
        "content": "Server-level health indicators. **Average Queue Duration** is how long packets wait before being sent — lower is better. **Ping/Pong** shows keepalive traffic; these should be roughly equal. **Watchers** are clients subscribed to peer presence notifications.\n\n📌 **What to watch:** Queue duration consistently above 50ms suggests the server is struggling to keep up. A divergence between ping and pong rates means keepalives are being lost. Watchers should roughly correlate with connection count.",
        "mode": "markdown"
      },
      "pluginVersion": "11.4.0",
      "title": "",
      "type": "text",
      "transparent": true
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
      "gridPos": { "h": 8, "w": 8, "x": 0, "y": 64 },
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
      "gridPos": { "h": 8, "w": 8, "x": 8, "y": 64 },
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
      "gridPos": { "h": 8, "w": 8, "x": 16, "y": 64 },
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
