import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class CommonUrlUtils {
  CommonUrlUtils._internal();

  factory CommonUrlUtils() => _instance;
  static final CommonUrlUtils _instance = CommonUrlUtils._internal();

  WebUri appendRawQueryParam(
      Uri originalUri, Map<String, dynamic> queryParameters) {
    final parameters = Map<String, dynamic>.from(originalUri.queryParameters);
    parameters.addAll(queryParameters);
    final newUri = originalUri.replace(queryParameters: parameters);
    return WebUri.uri(Uri.parse(Uri.decodeComponent(newUri.toString())));
  }

  WebUri appendRawQueryParam2(
      String originalUriPath, Map<String, dynamic> queryParameters) {
    return appendRawQueryParam(Uri.parse(originalUriPath), queryParameters);
  }
}
