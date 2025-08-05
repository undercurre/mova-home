/*
 * @Author: lijiajia lijiajia@dreame.tech
 * @Date: 2023-07-21 18:30:47
 * @LastEditors: lijiajia lijiajia@dreame.tech
 * @LastEditTime: 2023-09-01 13:59:19
 * @FilePath: /flutter_plugin/lib/ui/page/mall/wechat/wechat_page.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:flutter_plugin/ui/page/mall/mall/web_page.dart';
import 'package:flutter_plugin/ui/page/mall/wechat/wechat_page_minxin.dart';

class WeChatPage extends WebPage {
  static const String routePath = '/we_chat_page';
  const WeChatPage({super.key, super.request});

  @override
  WeChatPageState createState() {
    return WeChatPageState();
  }
}

class WeChatPageState extends WebPageState with WeChatPageMinXin {
  var poped = false;
  // @override
  // void initState() {
  //   WidgetsBinding.instance.addObserver(this);
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   WidgetsBinding.instance.removeObserver(this);
  // }

  @override
  void onAppResume() {
    dismiss();
    super.onAppResume();
  }
}
