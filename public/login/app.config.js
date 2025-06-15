if(!window.appVariables) appVariables = {};
function getAppConfigs() {
    return appVariables;
}
function getAppConfig(key) {
    return appVariables[key];
}
console.log("appConfigs",appVariables);
