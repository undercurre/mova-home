// ignore_for_file: must_be_immutable

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/utils/debounce_click_mixin.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';

typedef DMRichCallback = void Function(int index, String key, String content);

/// 富文本控件
/// 用法：'我已阅读并同意<a href="user">《用户协议》</a>及<a href="privacy">《隐私政策》</a>相关内容'
///      'abcd<tag>123</tag>efg<tag>456</tag>adfadf<tag>789</tag>wears'
/// children: [
///   DMRichText(
///     content:
///         '我已阅读并同意<a href="user">《用户协议》</a>及<a href="privacy">《隐私政策》</a>相关内容',
///     richCallback: (index, key) {
///       SmartDialog.showToast('index: $index, key: $key');
///     },
///   ),
///   DMRichText(
///     type: 1,
///     content:
///         'abcd<tag>123</tag>efg<tag>456</tag>adfadf<tag>789</tag>',
///     richCallback: (index, key) {
///       SmartDialog.showToast('index: $index, key: $key');
///     },
///   )
/// ],
///
class DMFormatRichText extends StatefulWidget {
  final DMRichCallback? richCallback;
  final String content;
  final List<String>? indexs;
  final TextAlign? align;
  TextStyle? normalTextStyle;
  TextStyle? clickTextStyle;

  /// 0 : '我已阅读并同意<a href="user">《用户协议》</a>及<a href="privacy">《隐私政策》</a>相关内容'
  /// 1:  'abcd<tag>123</tag>efg<tag>456</tag>adfadf<tag>789</tag>'
  /// 2:  content: '我已阅读并同意《用户协议》及《隐私政策》' indexs: ['《用户协议》','《隐私政策》']
  int type = 0;

  DMFormatRichText(
      {super.key,
      this.type = 0,
      this.normalTextStyle,
      this.clickTextStyle,
      required this.content,
      this.align,
      this.indexs,
      this.richCallback});

  @override
  State<StatefulWidget> createState() {
    return _DMFormatRichTextState();
  }
}

class _DMFormatRichTextState extends State<DMFormatRichText> {
  @override
  Widget build(BuildContext context) {
    return ThemeWidget(builder: (context, style, resource) {
      return Text.rich(
        TextSpan(
            children: widget.type == 0
                ? stringHrefParser(style, resource, widget.content)
                : widget.type == 1
                    ? stringTagParser(style, resource, widget.content)
                    : stringIndexParser(style, resource, widget.content)),
        textAlign: widget.align ?? TextAlign.start,
      );
    });
  }

  /// 解析文案中是TAG的内容
  /// @param content 例如：abcd<tag>123</tag>efg<tag>456</tag>adfadf<tag>789</tag>
  List<InlineSpan> stringTagParser(
      StyleModel style, ResourceModel resource, String content) {
    final List<TextSpan> spans = <TextSpan>[];
    RegExp regExp = RegExp('<tag([^<]+)<\\/tag>');
    int indexStart = 0;
    Iterable<RegExpMatch> iterable = regExp.allMatches(content);

    // 没有匹配到符合规则的文案
    if (iterable.isEmpty) {
      spans.add(_buildNormalSpan(text: content, style: style));
      return spans;
    }
    for (int i = 0; i < iterable.length; i++) {
      var match = iterable.elementAt(i);
      String group = match.group(0) ?? '';
      if (group.isEmpty) {
        spans.add(_buildNormalSpan(text: content, style: style));
        continue;
      }

      final String substring = content.substring(indexStart, match.start);
      indexStart = match.end;
      // 匹配前的文案
      spans.add(_buildNormalSpan(text: substring, style: style));
      var clickContent = group.replaceAll('</tag>', '').replaceAll('<tag>', '');
      // 点击文案

      spans.add(_buildClickSpan(
          showText: clickContent,
          index: i,
          clickUrl: clickContent,
          clickContent: clickContent,
          style: style));
      if (i >= iterable.length - 1) {
        var contentEnd = content.substring(indexStart);
        spans.add(_buildNormalSpan(text: contentEnd, style: style));
      }
    }
    return spans;
  }

  /// 解析文案中是href的内容
  /// @param content 例如：<a href="user">《用户协议》</a>及<a href="privacy">《隐私政策》</a>
  List<InlineSpan> stringHrefParser(
      StyleModel style, ResourceModel resource, String content) {
    final List<TextSpan> spans = <TextSpan>[];
    RegExp regExp = RegExp('<a([^<]+)<\\/a>');
    RegExp regExpHref = RegExp('href=\"([^<]+)\"');
    RegExp regExpHref2 = RegExp('href=\'([^<]+)\'');
    RegExp regExpContent = RegExp('>([^>]+)<\\/a>');
    int indexStart = 0;
    Iterable<RegExpMatch> iterable = regExp.allMatches(content);

    // 没有匹配到符合规则的文案
    if (iterable.isEmpty) {
      spans.add(_buildNormalSpan(text: content, style: style));
      return spans;
    }
    for (int i = 0; i < iterable.length; i++) {
      var match = iterable.elementAt(i);
      String? group = match.group(0);
      if (group == null) {
        spans.add(_buildNormalSpan(text: content, style: style));
        continue;
      }

      final String substring = content.substring(indexStart, match.start);
      indexStart = match.end;

      // 匹配前的文案
      spans.add(_buildNormalSpan(text: substring, style: style));

      // 匹配href 中的key
      RegExpMatch? hrefMatch = regExpHref.firstMatch(group);
      String? groupHref = null;
      if (hrefMatch != null) {
        groupHref =
            hrefMatch.group(0)?.replaceAll('href=', '').replaceAll('\"', '');
      } else {
        RegExpMatch? hrefMatch2 = regExpHref2.firstMatch(group);
        groupHref =
            hrefMatch2?.group(0)?.replaceAll('href=', '').replaceAll('\'', '');
      }
      // 匹配要点击的文案： >哈哈哈</a>
      RegExpMatch? contentMatch = regExpContent.firstMatch(group);
      String? clickContent =
          contentMatch?.group(0)?.replaceAll('</a>', '').replaceAll('>', '') ??
              '';

      // 点击文案
      spans.add(_buildClickSpan(
          showText: clickContent,
          index: i,
          clickUrl: groupHref ?? clickContent,
          clickContent: clickContent,
          style: style));

      if (i >= iterable.length - 1) {
        var contentEnd = content.substring(indexStart);
        spans.add(_buildNormalSpan(text: contentEnd, style: style));
      }
    }
    return spans;
  }

  /// 解析文案中是index的内容
  /// @param content: '我已阅读并同意《用户协议》及《隐私政策》' indexs: ['《用户协议》','《隐私政策》']
  List<InlineSpan> stringIndexParser(
      StyleModel style, ResourceModel resource, String content) {
    final List<TextSpan> spans = <TextSpan>[];
    int indexContentStart = 0;
    for (String indexStr in widget.indexs ?? []) {
      int start = content.indexOf(indexStr, indexContentStart);
      if (start == -1) {
        continue;
      }

      spans.add(_buildNormalSpan(
          text: content.substring(indexContentStart, indexContentStart + start),
          style: style));
      spans.add(_buildClickSpan(
          showText: indexStr,
          index: widget.indexs!.indexOf(indexStr),
          clickUrl: indexStr,
          clickContent: indexStr,
          style: style));
      indexContentStart = indexContentStart + start + indexStr.length;
    }
    spans.add(_buildNormalSpan(
        text: content.substring(indexContentStart), style: style));
    return spans;
  }

  /// 正常文案的样式
  TextSpan _buildNormalSpan({required String text, required StyleModel style}) {
    return TextSpan(
        text: text, style: widget.normalTextStyle ?? style.secondStyle());
  }

  /// 可点击文案的样式
  TextSpan _buildClickSpan(
      {required String showText,
      required int index,
      required String clickUrl,
      required String clickContent,
      required StyleModel style}) {
    return TextSpan(
        text: showText,
        recognizer: DMRichTapGestureRecognizer(
            clickIndex: index, clickUrl: clickUrl, clickContent: clickContent)
          ..onDMRichTap = widget.richCallback,
        style: widget.clickTextStyle ?? style.clickStyle());
  }
}

class DMRichTapGestureRecognizer extends TapGestureRecognizer
    with DebounceClickMixin {
  final int clickIndex;
  final String clickUrl;
  final String clickContent;

  @override
  DMRichTapGestureRecognizer({
    required this.clickIndex,
    required this.clickUrl,
    required this.clickContent,
    int ms = 300,
    super.debugOwner,
    super.supportedDevices,
    super.allowedButtonsFilter,
  }) {
    setMilliseconds(ms);
  }

  set onDMRichTap(DMRichCallback? onDMRichTap) {
    onTap = () {
      if (canClick()) {
        debounceClick();
        onDMRichTap?.call(clickIndex, clickUrl, clickContent);
      }
    };
  }
}
