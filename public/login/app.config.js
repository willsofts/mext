if(!window.appConfigs) appConfigs = {};
function getAppConfigs() {
    return appConfigs;
}
function getAppConfig(key) {
    return appConfigs[key];
}
console.log("appConfigs",appConfigs);
