import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';

mixin WebLaunchFromRoute {
  Future<String> fixUrlFromLaunchUrl({required String url}) async {
    Uri uri = Uri.parse(url);
    Map<String, String> newFixParam = Map.from(uri.queryParameters);
    List<String> keys = newFixParam.keys.toList();
    UserInfoModel? userInfo;
    for (String key in keys) {
      if (key.contains('_uid_')) {
        String uidKey = key.replaceAll('_uid_', '');
        newFixParam.remove(key);
        userInfo ??= await AccountModule().getUserInfo();
        newFixParam[uidKey] = userInfo?.uid ?? '';
      } else if (key.contains('_phone_')) {
        String phoneKey = key.replaceAll('_phone_', '');
        newFixParam.remove(key);
        userInfo ??= await AccountModule().getUserInfo();
        newFixParam[phoneKey] = userInfo?.phone ?? '';
      }
    }
    return uri.replace(queryParameters: newFixParam).toString();
  }
}
