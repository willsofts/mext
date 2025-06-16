const os = require("os");
const MiddlewareTracing = require("./middleware.tracing");
const { transports } = require("winston");
const LokiTransport = require("winston-loki");

module.exports = {
    nodeID: "mext-"+os.hostname().toLowerCase() + "-" + process.pid,
    logger: [
        {
            type: "Console",
            options: {
                level: "debug",
                color: true,
                formatter: "full",
            } 
        },  
        /*                 
        {
            type: "File",
            options: {
                level: "debug",
                formatter: "full",
                folder: "./logs",
                filename: "express-{date}.log",
                eol: "\n",
                interval: 1000,
            }
        },
        */
        {
            type: "Winston",
            options: {
                level: "debug",
                winston: {
                    transports: [
                        new transports.Console(),
                        new LokiTransport({
                            host: "http://localhost:3100", 
                            labels: { 
                                job: "moleculer-mext", 
                                nodeID: "mext-"+os.hostname().toLowerCase() + "-" + process.pid,
                            }, 
                            json: true,
                            replaceTimestamp: true,
                            hostname: os.hostname(),
                            onConnectionError: (err) => {
                                console.error("Loki connection error:", err);
                            }
                        }),
                    ],
                },
            },
        },         
        
    ],
    registry: {
        strategy: "RoundRobin",
        preferLocal: false,
    },
    //transporter: "NATS",
    /*    
    transporter: "NATS",
    transporter: "nats://localhost:4222",
    requestTimeout: 5 * 1000,

    circuitBreaker: {
        enabled: true
    },

    metrics: false,
    statistics: true
    */
         
    tracing: {
        description: "this work by setting tempo.yaml: distributor -> receivers -> jaeger -> thrift_binary -> endpoint: 0.0.0.0:6833 and docker-compos.yaml: tempo -> ports: - 6833:6833/udp (default port is 6832 but in this case it start with jaeger service)", 
        enabled: true,
        exporter: {
            type: "Jaeger",
            options: {
                endpoint: null,
                host: "localhost",
                port: 6832,
                tracerOptions: {},
                defaultTags: {"module.name":"mext"}
            }
        }
    },
        
    /*
    tracing: {
        description: "this work by setting tempo.yaml: distributor -> receivers -> zipkin -> endpoint: 0.0.0.0:9411", 
        enabled: true,
        exporter: {
            type: "Zipkin",
            options: {
                baseURL: "http://localhost:9411",
                interval: 5,
                payloadOptions: {
                    debug: true,
                    shared: false,
                },
                defaultTags: {"module.name":"mext"}
            }
        }
    },
    */
    
	metrics: {
        enabled: true,
        reporter: [
            {
                type: "Prometheus",
                options: {
                    port: 3030,
                    path: "/metrics",
                    defaultLabels: registry => ({
                        namespace: registry.broker.namespace,
                        nodeID: registry.broker.nodeID
                    })
                }
            }
        ]
    },
    middlewares: [MiddlewareTracing]
};
