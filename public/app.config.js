var appVariables = {
    MULTI_LANGUAGES: ["EN","TH"],
    BASE_CSS: ""
};
function getAppConfigs() {
    return appVariables;
}
function getAppConfig(key) {
    return appVariables[key];
}
console.log("appVariables",appVariables);
