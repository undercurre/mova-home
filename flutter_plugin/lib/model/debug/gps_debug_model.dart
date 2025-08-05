import 'package:freezed_annotation/freezed_annotation.dart';

part 'gps_debug_model.freezed.dart';
part 'gps_debug_model.g.dart';

@unfreezed
class GPSDebugModel with _$GPSDebugModel {
  factory GPSDebugModel({
    @Default('') String longitude,
    @Default('') String latitude,
    @Default(false) bool isDebug,
  }) = _GPSDebugModel;

  factory GPSDebugModel.fromJson(Map<String, dynamic> json) =>
      _$GPSDebugModelFromJson(json);
}
