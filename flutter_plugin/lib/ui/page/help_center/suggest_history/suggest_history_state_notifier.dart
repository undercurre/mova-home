import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/help_center/center/help_center_repository.dart';
import 'package:flutter_plugin/ui/page/help_center/model/suggest_history_box.dart';
import 'package:flutter_plugin/ui/page/help_center/suggest_history/suggest_history_ui_state.dart';
import 'package:flutter_plugin/ui/page/help_center/suggest_history_detail/suggest_history_detail_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'suggest_history_state_notifier.g.dart';

@riverpod
class SuggestHistoryStateNotifier extends _$SuggestHistoryStateNotifier {
  @override
  SuggestHistoryUiState build() {
    return const SuggestHistoryUiState();
  }

  Future<void> loadData() async {
    SuggestHistoryBox box =
        await ref.read(helpCenterRepositoryProvider).getSuggestHistory(page: 0);

    List<SuggestHistoryItem> records = box.records
            ?.map((e) => SuggestHistoryItem.fromSuggestHistory(e))
            .toList() ??
        [];
    state = state.copyWith(records: records.isNotEmpty ? records : null);
  }

  void pushToIndex(int index) {
    SuggestHistoryItem item = state.records![index];
    state = state.copyWith(
        event: PushEvent(
      path: SuggestHistoryDetailPage.routePath,
      extra: item,
    ));
  }
}
