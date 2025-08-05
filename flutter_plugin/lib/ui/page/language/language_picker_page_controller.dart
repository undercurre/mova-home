import 'package:flutter_plugin/ui/page/language/language_picker_page_mixin.dart';
import 'package:flutter_plugin/ui/page/language/language_picker_state.dart';
import 'package:flutter_plugin/utils/language_store.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'language_picker_page_controller.g.dart';

@riverpod
class LanguagePickerPageController extends _$LanguagePickerPageController
    with LanguagePickerPageMinXin {
  @override
  LanguagePickerState build() {
    return LanguagePickerState(
      languages: LanguageStore().getLanguages(),
      selectLanguage: LanguageStore().getCurrentLanguage(),
    );
  }
}
