import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/common/bridge/message_channel.dart';
import 'package:flutter_plugin/ui/page/language/language_picker_state.dart';
import 'package:flutter_plugin/utils/language_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin LanguagePickerPageMinXin on AutoDisposeNotifier<LanguagePickerState> {
  void selectItem(LanguageModel item) {
    state = state.copyWith(selectLanguage: item);
  }

  Future<void> saveItem() async {
    LanguageModel? language = state.selectLanguage;
    if (language == null) return;
    await LanguageStore().updateLanguageFrom(language: language);
    await MessageChannel().changeLanguage(language.toDreamelanTag());
  }
}
