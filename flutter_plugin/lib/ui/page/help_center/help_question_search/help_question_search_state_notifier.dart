import 'package:flutter_plugin/ui/page/help_center/center/help_center_repository.dart';
import 'package:flutter_plugin/ui/page/help_center/help_question_search/help_question_search_ui_state.dart';
import 'package:flutter_plugin/ui/page/help_center/model/app_faq.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'help_question_search_state_notifier.g.dart';

@riverpod
class HelpQuestionSearchStateNotifier
    extends _$HelpQuestionSearchStateNotifier {
  late List<AppFaq> _faqs;
  List<AppFaq> _currentFaqs = [];
  @override
  HelpQuestionSearchUiState build() {
    return const HelpQuestionSearchUiState();
  }

  void loadData(List<AppFaq>? faqs) {
    if (faqs != null) {
      _faqs = faqs;
      _updateDisplayData();
    } else {
      ref.read(helpCenterRepositoryProvider).getfaqs().then((value) {
        _faqs = value;
        _updateDisplayData();
      });
    }
  }

  void _updateDisplayData() {
    String? searchText = state.searchText ?? '';
    if (searchText.isEmpty) {
      _currentFaqs = _faqs;
      state = state.copyWith(
        faqs: _currentFaqs,
      );
    } else {
      List<AppFaq> faqs = [];
      for (var faq in _faqs) {
        AppFaq fixfaq = AppFaq(
            title: faq.title, bodyItems: faq.bodyItems, isExpand: faq.isExpand, localizationDisplayMedia: faq.localizationDisplayMedia);
        bool isMatch = false;
        bool isExpand = false;
        var items = fixfaq.bodyItems;
        for (var item in items) {
          if (item.content.contains(searchText)) {
            isMatch = true;
            isExpand = true;
            break;
          }
        }
        if (!isMatch) {
          if (faq.title.contains(searchText)) {
            isMatch = true;
          }
        }
        if (isMatch) {
          fixfaq.isExpand = isExpand;
          faqs.add(fixfaq);
        }
      }
      _currentFaqs = faqs;
      state = state.copyWith(
        faqs: _currentFaqs,
      );
    }
  }

  void expandFaq(int index) {
    _currentFaqs[index].isExpand = !_currentFaqs[index].isExpand;
    state = state.copyWith(
      faqs: _currentFaqs,
    );
  }

  void search(String text) {
    state = state.copyWith(
      searchText: text,
    );
    _updateDisplayData();
  }
}
