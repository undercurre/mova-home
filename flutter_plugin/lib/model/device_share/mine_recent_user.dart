import 'package:freezed_annotation/freezed_annotation.dart';

part 'mine_recent_user.freezed.dart';
part 'mine_recent_user.g.dart';

@freezed
class MineRecentUser with _$MineRecentUser {
  const factory MineRecentUser({
    String? avatar,
    String? name,
    String? uid,
    int? sharedStatus,
  }) = _MineRecentUser;

  factory MineRecentUser.fromJson(Map<String, dynamic> json) =>
      _$MineRecentUserFromJson(json);
}
