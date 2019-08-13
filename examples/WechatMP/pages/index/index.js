//index.js

const api = require('../../API/ThinkingAnalyticsAPI.js')
const app = getApp()

//var Page = app.thinkingdata.Page;

Page({
  onShareAppMessage(object){
    console.log('shared');
  },
  track() {
    api.track("test");
  },
  login() {
    api.login("mini_user");
  },
  logout() {
    api.logout();
  },
  superProperties() {
    api.setSuperProperties({ "superkey": "supervalue", "superkey2": "supervalue2" });
  },
  clearProperties() {
    api.clearSuperProperties();
  },
  userSet() {
    api.userSet({"level":26, "age":18});
    api.userSetOnce({"cost":-30});
    api.userAdd({"level":2});
    api.userDel();
  },
  authorizeOpenID() {
    api.authorizeOpenID('authorizeOpenID');
  },
  onLoad: function(options) {
    console.log('onload');
  }
})
