import 'package:freezed_annotation/freezed_annotation.dart';

part 'email_collection_state.freezed.dart';

@freezed
class EmailCollectionState with _$EmailCollectionState {
  factory EmailCollectionState({
    bool? subscribed,
    String? email,
  }) = _EmailCollectionState;
}
