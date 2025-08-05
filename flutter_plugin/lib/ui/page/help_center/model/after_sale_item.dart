import 'package:flutter_plugin/ui/page/help_center/model/after_sale_fix_info.dart';
import 'package:flutter_plugin/ui/page/help_center/model/after_sale_info.dart';

enum AfterSaleContact {
  onlineServer,
  email,
  webSite,
  hotLine,
  other,
  serviceCenter,
}

class AfterSaleContactItem {
  AfterSaleContact contact;
  String title;
  String image;
  String? desc;
  bool isShowEnter = false;
  List<AfterSaleItemValue>? valueList;
  OnlineServiceInfo? onlineServiceInfo;
  void Function(AfterSaleItemValue?)? onTap;
  AfterSaleContactItem({
    required this.contact,
    required this.title,
    this.desc,
    required this.image,
    this.valueList,
    this.isShowEnter = false,
    this.onTap,
    this.onlineServiceInfo,
  });
}
