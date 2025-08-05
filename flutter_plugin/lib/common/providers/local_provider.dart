import 'package:flutter_plugin/model/local_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_provider.g.dart';

@riverpod
class LocalProvider extends _$LocalProvider {
  @override
  LocalModel build() {
    return const LocalModel();
  }

  void updateLocalModel(LocalModel localModel) {
    state = localModel;
  }
}
