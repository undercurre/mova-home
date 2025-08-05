import 'package:flutter_plugin/ui/page/pair_network/pincode_verification/pincode_verification_ui_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'pincode_verification_state_notifier.g.dart';

@riverpod
class PincodeVerificationStateNotifier
    extends _$PincodeVerificationStateNotifier {
  @override
  PincodeVerificationUIState build() {
    return PincodeVerificationUIState();
  }

  void initData() {
    state = state.copyWith(pincode: '', enableBtn: false, remainingTime: 10);
  }

  void updatePinCode(String text) {
    state = state.copyWith(pincode: text, enableBtn: text.length == 4);
  }

  Future<void> verifyPinCode() async {}

  void showAlert() {}
}
