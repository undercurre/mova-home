import 'dart:convert';

import 'package:flutter_plugin/ui/page/help_center/model/after_sale_info.dart';
import 'package:flutter_plugin/utils/logutils.dart';

enum OnlineServiceType {
  zendesk,
  liveChat,
  zhiChi,
}

class AfterSaleFixInfo {
  final OnlineServiceInfo? onlineServiceInfo;
  List<AfterSaleItem> saleItems;
  AfterSaleFixInfo({
    this.onlineServiceInfo,
    required this.saleItems,
  });
  factory AfterSaleFixInfo.fromOriInfo(AfterSaleInfo info) {
    List<AfterSaleItem> saleItems = info.saleItems;
    OnlineServiceInfo? onlineServiceInfo;
    if (info.onlineService && info.onlineServiceType != null) {
      OnlineServiceType? type;
      switch (info.onlineServiceType) {
        case 1:
          type = OnlineServiceType.zendesk;
          break;
        case 2:
          type = OnlineServiceType.liveChat;
          break;
        case 3:
          type = OnlineServiceType.zhiChi;
          break;
        default:
          type = null;
      }
      LogUtils.i('fixInfo.onlineServiceInfo 1: $type');
      if (type != null) {
        LogUtils.i('fixInfo.onlineServiceInfo 2: $type');
        if (type == OnlineServiceType.liveChat) {
          String? extra = info.remarks;
          if (extra != null) {
            try {
              LogUtils.i('fixInfo.onlineServiceInfo 3: $extra');
              Map<String, dynamic> extraMap = jsonDecode(extra);
              LogUtils.i('fixInfo.onlineServiceInfo 4: $extraMap');
              Map<String, dynamic>? ex = extraMap['liveChat'];
              String? token = ex?['token'];
              String? id = ex?['id'];
              LogUtils.i('fixInfo.onlineServiceInfo 5: $token---$id');
              if (token != null && id != null) {
                onlineServiceInfo = LiveChatOnlineServiceInfo(
                  token: token,
                  id: id,
                );
              }
            } catch (e) {
              LogUtils.e('AfterSaleFixInfo.fromJson---error-$e---extra:$extra');
            }
          }
        } else {
          onlineServiceInfo = OnlineServiceInfo(type: type);
        }
      }
    }
    AfterSaleFixInfo fixInfo = AfterSaleFixInfo(
      onlineServiceInfo: onlineServiceInfo,
      saleItems: saleItems,
    );
    return fixInfo;
  }
}

class OnlineServiceInfo {
  final OnlineServiceType type;
  OnlineServiceInfo({
    required this.type,
  });
}

class LiveChatOnlineServiceInfo extends OnlineServiceInfo {
  final String token;
  final String id;
  LiveChatOnlineServiceInfo({
    required this.token,
    required this.id,
  }) : super(type: OnlineServiceType.liveChat);
}
