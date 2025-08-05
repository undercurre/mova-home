// class JsAppShareInfo {
//   JsAppShareInfo({this.target, this.type, this.content});
//   String? target;
//   String? type;
//   JsAppShareContent? content;
//   static JsAppShareInfo fromMap(Map<String, dynamic> map) {
//     JsAppShareInfo item = JsAppShareInfo(
//       target: map['target'],
//       type: map['type'],
//       content: JsAppShareContent.fromMap(map['content']),
//     );
//     return item;
//   }
// }

import 'dart:collection';

class JsAppShareContent {
  JsAppShareContent({this.url, this.shareTitle, this.shareImage});
  String? url;
  String? shareTitle;
  String? shareImage;

  static JsAppShareContent? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    JsAppShareContent item = JsAppShareContent(
      url: map['url'],
      shareImage: map['share_image'],
      shareTitle: map['shareTitle'],
    );
    return item;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = HashMap();
    map['url'] = url;
    map['share_image'] = shareImage;
    map['shareTitle'] = shareTitle;
    return map;
  }
}
