import 'dart:convert';

import 'package:flutter_plugin/common/bridge/local_storage.dart';
import 'package:flutter_plugin/model/account/mall_login_res.dart';
import 'package:flutter_plugin/utils/constant.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_info_store.g.dart';

class UserInfoStore {
  final LocalStorage _localStorage;

  const UserInfoStore({
    required LocalStorage localStorage,
  }) : _localStorage = localStorage;

  Future<void> saveMallInfo(MallLoginRes? mallLogin) async {
    if (mallLogin == null) {
      await _localStorage.remove(Constant.sharedMallLoginResKey,
          fileName: 'mallSession');
    } else {
      String jsonString = json.encode(mallLogin);
      await _localStorage.putString(Constant.sharedMallLoginResKey, jsonString,
          fileName: 'mallSession');
    }
  }

  Future<MallLoginRes?> getMallInfo() async {
    String? jsonString = await _localStorage
        .getString(Constant.sharedMallLoginResKey, fileName: 'mallSession');
    if (jsonString == null) return null;
    try {
      return MallLoginRes.fromJson(json.decode(jsonString));
    } catch (_) {
      return null;
    }
  }

  Future<void> clearMallInfo() async {
    await _localStorage.remove(Constant.sharedMallLoginResKey,
        fileName: 'mallSession');
  }
}

@Riverpod(keepAlive: true)
UserInfoStore userInfoStore(UserInfoStoreRef ref) {
  return UserInfoStore(
    localStorage: LocalStorage(),
  );
}
