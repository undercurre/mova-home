/*
 * @Author: lijiajia lijiajia@dreame.tech
 * @Date: 2023-07-25 18:05:45
 * @LastEditors: lijiajia lijiajia@dreame.tech
 * @LastEditTime: 2023-07-26 10:51:40
 * @FilePath: /flutter_plugin/lib/ui/page/mall/event_action/navigate_sheet_show.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/common/js_action/js_map_navigation.dart';

class NaivgateSheetShow extends CommonEventAction {
  NaivgateSheetShow({required this.navigation});
  JSMapNavigation navigation;
}
