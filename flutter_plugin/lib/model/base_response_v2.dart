import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_response_v2.freezed.dart';

part 'base_response_v2.g.dart';

@Freezed(genericArgumentFactories: true)
class BaseResponseV2<T> with _$BaseResponseV2<T> {
  const factory BaseResponseV2(
      {T? data, String? msg, int? code, dynamic success}) = _BaseResponseV2;

  factory BaseResponseV2.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$BaseResponseV2FromJson(json, fromJsonT);
}

extension BaseResponseV2Ext on BaseResponseV2 {
  bool successed() {
    if (success is bool) {
      return success && data != null;
    }
    return code == 0;
  }
}
