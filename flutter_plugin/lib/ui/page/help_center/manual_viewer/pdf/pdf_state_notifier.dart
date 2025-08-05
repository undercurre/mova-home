

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'pdf_state.dart';

part 'pdf_state_notifier.g.dart';


@riverpod
class PdfStateNotifier extends _$PdfStateNotifier{

  @override
  PdfState build() {
    return const PdfState();
  }

  Future<void> retry()async {
    state = state.copyWith(refreshCount: state.refreshCount+1);
  }




}