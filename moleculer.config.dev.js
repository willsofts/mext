const os = require("os");
const MiddlewareTracing = require("./middleware.tracing");

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
                host: "localhost",
                port: 6832,
                tracerOptions: {},
                defaultTags: {"module.name":"mext"}
            }
        }
    },
    middlewares: [MiddlewareTracing]    
};
