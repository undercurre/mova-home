import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'page_action_provider.g.dart';

@riverpod
class PageActionPrivider extends _$PageActionPrivider {
  @override
  String? build() {
    return null;
  }

  void sendAction({required String path}) {
    state = path;
  }
}
