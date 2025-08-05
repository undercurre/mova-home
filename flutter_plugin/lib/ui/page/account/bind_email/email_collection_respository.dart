import 'dart:math';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/providers/api_client_provider.dart';
import 'package:flutter_plugin/model/account/mall_login_res.dart';
import 'package:flutter_plugin/ui/page/account/bind_email/email_collection_state.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'email_collection_respository.g.dart';

@Riverpod(keepAlive: true)
class EmailCollectionRespository extends _$EmailCollectionRespository {
  @override
  EmailCollectionState build() {
    return EmailCollectionState();
  }

  void reset() {
    state = state.copyWith(subscribed: null, email: null);
  }

  Future<bool?> getSubscribeStatus() async {
    if (state.subscribed != null) {
      return state.subscribed!;
    } else {
      try {
        EmailCollectionRes res = await _updateSeaEmail();
        state = state.copyWith(subscribed: res.emailPush == 1);
        return state.subscribed;
      } catch (_) {
        return null;
      }
    }
  }

  Future<String?> updateEmail() async {
    String? email = (await AccountModule().getUserInfo())?.email;
    state = state.copyWith(email: email);
    return email;
  }

  void changeemain() {
    state = state.copyWith(email: 'email');
  }

  Future<bool> subscribe() async {
    try {
      await _subsribue();
      state = state.copyWith(subscribed: true);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<EmailCollectionRes> _updateSeaEmail() {
    return ref.read(apiClientProvider).getSeaEmailCollectInfo().then((value) {
      if (value.successed()) {
        return Future.value(value.data);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  Future<dynamic> _subsribue() {
    return ref
        .read(apiClientProvider)
        .emailCollectionSubscribe(EmailCollectionSubscribeRep(status: 1))
        .then((value) {
      if (value.successed()) {
        return Future.value(value.data);
      } else {
        LogUtils.i('subsribue----errror---$value');
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }
}
