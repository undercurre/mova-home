import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'webview_uistate.freezed.dart';

@freezed
class WebviewUistate with _$WebviewUistate {
  const factory WebviewUistate({
    required String title,
    required String url,
    required bool isHideTitle,
  }) = _WebviewUistate;
}
