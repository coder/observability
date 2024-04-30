{{ define "status-dashboard.json" }}
{{ $ns := .Release.Namespace }}
{{ $metrics := .Values.metrics.server.fullnameOverride }}
{{ $logs := .Values.logs.fullnameOverride }}
{{ $collector := .Values.collector.fullnameOverride }}
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
    "id": 28,
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
                "y": 1
            },
            "id": 10,
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
                    "expr": "min by (pod) (up{{- .Values.global.coder.statusDashboard.coderSelector -}})",
                    "instant": false,
                    "legendFormat": "__auto",
                    "range": true,
                    "refId": "A"
                }
            ],
            "title": "Coder",
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
                    "expr": "min(pg_up)",
                    "instant": false,
                    "legendFormat": "__auto",
                    "range": true,
                    "refId": "A"
                }
            ],
            "title": "Postgres",
            "type": "stat"
        },
        {
            "gridPos": {
                "h": 1,
                "w": 24,
                "x": 0,
                "y": 6
            },
            "id": 3,
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
                "y": 7
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
                    "expr": "min(up{job=\"{{$ns}}/{{$metrics}}/server\"})",
                    "instant": false,
                    "legendFormat": "__auto",
                    "range": true,
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
                "y": 7
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
                    "expr": "min(up{job=\"{{$ns}}/{{$logs}}/write\"})",
                    "instant": false,
                    "legendFormat": "__auto",
                    "range": true,
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
                "y": 7
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
                    "expr": "min(up{job=\"{{$ns}}/logs/read\"})",
                    "instant": false,
                    "legendFormat": "__auto",
                    "range": true,
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
                "y": 7
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
                    "expr": "min(up{job=\"{{$ns}}/logs/backend\", container=\"loki\"})",
                    "instant": false,
                    "legendFormat": "__auto",
                    "range": true,
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
                "y": 7
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
                    "expr": "min(up{job=\"{{$ns}}/logs/canary\"})",
                    "instant": false,
                    "legendFormat": "__auto",
                    "range": true,
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
                "y": 7
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
                    "expr": "min(up{job=\"{{$ns}}/{{$collector}}/grafana-agent\"})",
                    "instant": false,
                    "legendFormat": "__auto",
                    "range": true,
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
                "y": 12
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
                    "expr": "prometheus_config_last_reload_successful{job=\"{{$ns}}/{{$metrics}}/server\"}",
                    "instant": false,
                    "legendFormat": "__auto",
                    "range": true,
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
                "y": 12
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
                    "expr": "min(loki_runtime_config_last_reload_successful)",
                    "instant": false,
                    "legendFormat": "__auto",
                    "range": true,
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
                "y": 12
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
                    "expr": "min(agent_config_last_load_successful{job=\"{{$ns}}/{{$collector}}/grafana-agent\"})",
                    "instant": false,
                    "legendFormat": "__auto",
                    "range": true,
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
                "y": 12
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
                    "expr": "(\n    prometheus_tsdb_wal_storage_size_bytes{job=\"{{$ns}}/{{$metrics}}/server\"} +\n    prometheus_tsdb_storage_blocks_bytes{job=\"{{$ns}}/{{$metrics}}/server\"} +\n    prometheus_tsdb_symbol_table_size_bytes{job=\"{{$ns}}/{{$metrics}}/server\"}\n)\n/\nprometheus_tsdb_retention_limit_bytes{job=\"{{$ns}}/{{$metrics}}/server\"}",
                    "instant": false,
                    "legendFormat": "Retention limit used",
                    "range": true,
                    "refId": "A"
                }
            ],
            "title": "Prometheus Storage",
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
    "title": "Status",
    "uid": "bdk6eff8skqo0c",
    "version": 1,
    "weekStart": ""
}
{{ end }}