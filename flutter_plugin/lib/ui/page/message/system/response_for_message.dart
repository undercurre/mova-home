import 'package:flutter_plugin/model/message/common_message_record_model.dart';
import 'package:flutter_plugin/ui/page/main/scheme/scheme_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main/scheme/scheme_handle_notifier.dart';

extension ResponseForMessage on ConsumerState {
  void messageClick(CommonMsgRecord message) {
    if (message.display == null ||
        message.display!.link == null ||
        message.display!.link == '') {
      return;
    }
    messageClick2(message.jumpType, message.display?.link, null);
  }

  void messageClick2(String? jumpType, String? jumpLink, String? applet_id) {
    if (jumpType == null) return;
    if (jumpLink == null) return;
    final extMap = <String, dynamic>{};
    switch (jumpType.toUpperCase()) {
      case 'WEB':
        extMap['url'] = jumpLink;
      case 'WEB_EXTERNAL':
        extMap['url'] = jumpLink;
      case 'APP':
        extMap['page'] = jumpLink;
      case 'MALL':
        extMap['url'] = jumpLink;
      case 'APPLET_ID':
        extMap['id'] = applet_id;
        extMap['path'] = jumpLink;
      case 'MEMBER':
        extMap['url'] = jumpLink;
      default:
        extMap['url'] = jumpLink;
        break;
    }
    ref
        .read(schemeHandleNotifierProvider.notifier)
        .handleSchemeJump(SchemeType(jumpType), extMap);
  }
}
