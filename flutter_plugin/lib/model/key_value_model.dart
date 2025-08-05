import 'package:freezed_annotation/freezed_annotation.dart';
part 'key_value_model.freezed.dart';
part 'key_value_model.g.dart';

@freezed
class KVModel with _$KVModel {
  factory KVModel(String key, dynamic value) = _KVModel;

  factory KVModel.fromJson(Map<String, dynamic> json) =>
      _$KVModelFromJson(json);
}
