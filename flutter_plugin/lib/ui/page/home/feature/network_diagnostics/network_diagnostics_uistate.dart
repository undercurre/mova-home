import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_diagnostics_uistate.freezed.dart';

@freezed
class NetworkDiagnosticsUiState with _$NetworkDiagnosticsUiState {
  const factory NetworkDiagnosticsUiState({
    String? bindDomain,
    @Default(0) int progress,
    @Default(0) int status,
    @Default(0) int result,
    @Default('') String resultText,
    @Default('') String resultText2,

    // 网络有效
    @Default(false) bool networkValid,
    @Default(0) int networkQuality,
    @Default(0) int networkLatency,
    @Default(false) bool networkDns,
    // http
    @Default(false) bool httpDomainValid,
    @Default(0) int httpDomainQuality,
    @Default(0) int httpDomainLatency,
    @Default(false) bool httpDomainDns,
    // mqtt
    @Default(false) bool mqttDomainValid,
    @Default(0) int mqttDomainQuality,
    @Default(0) int mqttDomainLatency,
    @Default(false) bool mqttDomainDns,
    // wifi 信号强度
    @Default(0) int rssiQuality,
  }) = _NetworkDiagnosticsUiState;
}
