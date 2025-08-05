import 'package:flutter_js/flutter_js.dart';

abstract mixin class JSRuntime {
  JavascriptRuntime init() {
    JavascriptRuntime flutterJs = getJavascriptRuntime(xhr: false);

    /// unawait
    flutterJs.onMessage('showToast', (args) {
      showJSToast(args);
    });
    flutterJs.onMessage('showJSDialog', (args) {
      showJSDialog(args);
    });
    flutterJs.onMessage('buildUI', (args) {
      buildUI(args);
    });

    /// await
    flutterJs.onMessage('getAppConfig', (args) async {
      return getAppConfig();
    });
    flutterJs.onMessage('sendCommond', (args) async {
      return sendCommond(args);
    });
    flutterJs.onMessage('getKeyDefine', (args) async {
      return getKeyDefine(args);
    });
    flutterJs.onMessage('getCurrentDevice', (args) async {
      return getCurrentDevice();
    });
    flutterJs.onMessage('getLocalImagePath', (args) async {
      return getLocalImagePath();
    });

    flutterJs.evaluateAsync(''' 
      function showToast(msg){
        sendMessage("showToast", JSON.stringify({msg}));
      }
      function showJSDialog(msg){
        sendMessage("showJSDialog", JSON.stringify({msg}));
      }

      async function getAppConfig(){
        return await sendMessage("getAppConfig", JSON.stringify({}));
      }

      async function sendCommond(){
        return await sendMessage("sendCommond", JSON.stringify({}));
      }

      async function getKeyDefine(){
        return await sendMessage("getKeyDefine", JSON.stringify({}));
      }

      async function getCurrentDevice(){
        return await sendMessage("getCurrentDevice", JSON.stringify({}));
      }

      async function getLocalImagePath(){
        return await sendMessage("getLocalImagePath", JSON.stringify({}));
      }

      function buildUI(json){
        sendMessage('buildUI',JSON.stringify(json));
      }
    ''');
    return flutterJs;
  }

  void showJSToast(msg);

  void showJSDialog(msg);

  void buildUI(String json);

  void sendCommond(params);

  Future<String> getKeyDefine(params);

  Future<String> getCurrentDevice();

  Future<String> getAppConfig();

  Future<String> getLocalImagePath();
}
