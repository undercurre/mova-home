import 'package:freezed_annotation/freezed_annotation.dart';
part 'ai_sound_model.freezed.dart';
part 'ai_sound_model.g.dart';

@freezed
class AiSoundModel with _$AiSoundModel {
  factory AiSoundModel({
    required String name,
    required String imageUrl,
    required String linkUrl,
    required String title,
    @Default('') String? button,
    SoundDetailModel? android,
    SoundDetailModel? ios,
  }) = _AiSoundModel;

  factory AiSoundModel.fromJson(Map<String, dynamic> json) =>
      _$AiSoundModelFromJson(json);
}

@freezed
class SoundDetailModel with _$SoundDetailModel {
  factory SoundDetailModel({
    @Default('') String packageName,
    @Default('') String downloadUrl,
  }) = _SoundDetailModel;

  factory SoundDetailModel.fromJson(Map<String, dynamic> json) =>
      _$SoundDetailModelFromJson(json);
}
