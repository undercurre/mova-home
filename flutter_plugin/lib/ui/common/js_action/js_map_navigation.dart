/*
 * @Author: lijiajia lijiajia@dreame.tech
 * @Date: 2023-07-24 17:59:11
 * @LastEditors: lijiajia lijiajia@dreame.tech
 * @LastEditTime: 2023-07-26 11:01:46
 * @FilePath: /flutter_plugin/lib/ui/common/js_action/js_map_navigation.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:flutter_plugin/ui/page/mall/mall_content/map_naviagte_minxin.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'js_map_navigation.freezed.dart';
part 'js_map_navigation.g.dart';

@freezed
class JSMapLocation with _$JSMapLocation {
  const factory JSMapLocation({
    String? lon,
    String? lat,
  }) = _JSMapLocation;

  factory JSMapLocation.fromJson(Map<String, dynamic> json) =>
      _$JSMapLocationFromJson(json);
}

class JSMapNavigation {
  JSMapNavigation({
    this.title,
    this.location,
    this.type,
  });
  String? title;
  JSMapLocation? location;
  NavigateMapType? type;

  static JSMapNavigation fromJson(Map<String, dynamic> json) {
    String? title = json['title'];
    JSMapLocation? location = JSMapLocation.fromJson(json['location']);
    return JSMapNavigation(
      title: title,
      location: location,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['title'] = title;
    map['location'] = location?.toJson();
    return map;
  }
}
