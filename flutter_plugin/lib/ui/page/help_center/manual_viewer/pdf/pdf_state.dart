import 'package:freezed_annotation/freezed_annotation.dart';

part 'pdf_state.freezed.dart';



@freezed
class PdfState with _$PdfState {

  const factory PdfState({
    @Default('') String title,
    @Default('')String url,
    @Default(0)int refreshCount
  }) = _PdfState;


}
