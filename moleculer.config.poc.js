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
        {
            type: "Winston",
            options: {
                level: "debug",
                winston: {
                    transports: [
                        new transports.Console(),
                        new LokiTransport({
                            host: "http://10.99.99.124:3100", 
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
    tracing: {
        enabled: true,
        exporter: {
            type: "Jaeger",
            options: {
                endpoint: null,
                host: "10.99.99.124",
                /*host: "localhost",*/
                port: 6832,
                tracerOptions: {},
                defaultTags: {"module.name":"mext"}
            }
        }
    },    
    middlewares: [MiddlewareTracing]
};
