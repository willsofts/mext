const appVariables = {
    MULTI_LANGUAGES: ["EN","TH"],
    BASE_CSS: "./css/user_style.css"
};
function getAppConfigs() {
    return appVariables;
}
function getAppConfig(key) {
    return appVariables[key];
}
console.log("appVariables",appVariables);
