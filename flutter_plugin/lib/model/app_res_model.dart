import 'package:freezed_annotation/freezed_annotation.dart';
part 'app_res_model.freezed.dart';

@freezed
class AppResModel with _$AppResModel {
  const factory AppResModel({
    @Default({}) Map<String, String> iconMap,
    @Default(0) int startDate,
    @Default(0) int endDate,
  }) = _AppResModel;
}

enum ResourceType { image, video, lottie }
