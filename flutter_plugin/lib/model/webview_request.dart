import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewRequest {
  WebViewRequest({
    required this.uri,
    this.headers = const <String, String>{},
    this.body,
    this.defaultTitle,
    this.cacheEnabled = true,
    this.useHybridComposition = false,
    this.clearCache = false,
  });
  WebUri uri;
  Map<String, String> headers = const <String, String>{};
  Uint8List? body;
  String? defaultTitle;
  bool cacheEnabled = true;
  bool clearCache = false;
  bool useHybridComposition = false;

  WebViewRequest copyWith({
    WebUri? uri,
    Map<String, String>? headers,
    Uint8List? body,
    String? defaultTitle,
    bool? cacheEnabled,
    bool? clearCache,
    bool? useHybridComposition,
  }) {
    return WebViewRequest(
      uri: uri ?? this.uri,
      headers: headers ?? this.headers,
      body: body ?? this.body,
      defaultTitle: defaultTitle ?? this.defaultTitle,
      cacheEnabled: cacheEnabled ?? this.cacheEnabled,
      clearCache: clearCache ?? this.clearCache,
      useHybridComposition: useHybridComposition ?? this.useHybridComposition,
    );
  }
}

// Future<void> loadRequest(
//     Uri uri, {
//     LoadRequestMethod method = LoadRequestMethod.get,
//     Map<String, String> headers = const <String, String>{},
//     Uint8List? body,
//   }) {
//     if (uri.scheme.isEmpty) {
//       throw ArgumentError('Missing scheme in uri: $uri');
//     }
//     return platform.loadRequest(LoadRequestParams(
//       uri: uri,
//       method: method,
//       headers: headers,
//       body: body,
//     ));
//   }
