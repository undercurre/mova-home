import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_mark_model.freezed.dart';
part 'user_mark_model.g.dart';

@freezed
class UserMarkModel with _$UserMarkModel {
  factory UserMarkModel({@Default(false) bool needDialog}) = _UserMarkModel;

  factory UserMarkModel.fromJson(Map<String, dynamic> json) =>
      _$UserMarkModelFromJson(json);
      
}
