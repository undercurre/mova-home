import 'package:freezed_annotation/freezed_annotation.dart';
part 'tab_config.freezed.dart';
part 'tab_config.g.dart';

@unfreezed
class TabConfig with _$TabConfig {
  factory TabConfig({
    String? type,
    String? url,
  }) = _TabConfig;

  TabConfig._();

  factory TabConfig.fromJson(Map<String, dynamic> json) =>
      _$TabConfigFromJson(json);
}
