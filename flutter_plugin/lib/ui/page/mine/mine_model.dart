import 'package:freezed_annotation/freezed_annotation.dart';

part 'mine_model.freezed.dart';

typedef ClickCallback = void Function();

@unfreezed
class MineModel with _$MineModel {
  factory MineModel({
    @Default('') String tag,
    @Default('') String icon,
    @Default('') String leftText,
    @Default('') String rightText,
    @Default(true) bool showRightArrow,
    Function? onTouchUp,
  }) = _MineModel;
}
