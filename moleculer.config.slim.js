const os = require("os");

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
};
