import 'package:json_annotation/json_annotation.dart';

/// int or string converter 转String?
class StringOrIntConverter implements JsonConverter<String?, Object?> {
  // 是否允许null 默认为true
  final bool ifNull;

  const StringOrIntConverter({this.ifNull = true});

  @override
  String? fromJson(Object? json) {
    if (json is int) {
      return json.toString();
    } else if (json is String) {
      return json; // 默认值为0，如果不能解析
    }
    if (ifNull) {
      return null;
    } else {
      return '';
    }
  }

  @override
  Object? toJson(String? object) => object;
}

/// int or string converter 转int?
class IntOrStringConverter implements JsonConverter<int?, Object?> {
  // 是否允许null 默认为true
  final bool ifNull;

  const IntOrStringConverter({this.ifNull = true});

  @override
  int? fromJson(Object? json) {
    if (json is int) {
      return json;
    } else if (json is String) {
      try {
        return int.parse(json); // 默认值为0，如果不能解析
      } catch (e) {
        return 0;
      }
    }
    if (ifNull) {
      return null;
    } else {
      return 0;
    }
  }

  @override
  Object? toJson(int? object) => object;
}
