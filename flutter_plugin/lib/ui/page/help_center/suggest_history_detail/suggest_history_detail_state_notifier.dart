import 'package:flutter_plugin/ui/page/help_center/model/suggest_history_box.dart';
import 'package:flutter_plugin/ui/page/help_center/suggest_history_detail/suggest_history_detail_ui_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'suggest_history_detail_state_notifier.g.dart';

@riverpod
class SuggestHistoryDetailStateNotifier
    extends _$SuggestHistoryDetailStateNotifier {
  @override
  SuggestHistoryDetailUiState build() {
    return const SuggestHistoryDetailUiState();
  }

  void loadData(SuggestHistoryItem history) {
    state = state.copyWith(history: history);

    // SuggestHistoryBox box =
    //     await ref.read(helpCenterRepositoryProvider).getSuggestHistory(page: 0);

    // List<SuggestHistoryItem> records = box.records
    //         ?.map((e) => SuggestHistoryItem.fromSuggestHistory(e))
    //         .toList() ??
    //     [];
    // state = state.copyWith(records: records.isNotEmpty ? records : null);
  }

  List<String> getMediaPaths() {
    List<String> imagePaths = [];
    state.history?.medias?.forEach((element) {
      imagePaths.add(element.url);
    });
    return imagePaths;
  }
}
