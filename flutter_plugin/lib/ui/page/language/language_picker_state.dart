import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'language_picker_state.freezed.dart';

@freezed
class LanguagePickerState with _$LanguagePickerState {
  const factory LanguagePickerState({
    @Default([]) List<LanguageModel> languages,
    LanguageModel? selectLanguage,
  }) = _LanguagePickerState;
}
