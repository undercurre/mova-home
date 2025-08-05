library expandable_text;

import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/ui/widget/mine/expand_text_parser.dart';
import 'package:flutter_plugin/ui/widget/mine/expand_text_span.dart';

// import './text_parser.dart';

typedef StringCallback = void Function(String value);

class ExpandText extends StatefulWidget {
  const ExpandText(
    this.text, {
    super.key,
    // required this.expandText,
    required this.expandWidget,
    this.collapseWidget,
    // this.collapseText,
    this.expanded = false,
    this.onExpandedChanged,
    this.onLinkTap,
    this.linkColor,
    this.linkEllipsis = true,
    this.linkStyle,
    this.prefixText,
    this.prefixStyle,
    this.onPrefixTap,
    this.urlStyle,
    this.onUrlTap,
    this.hashtagStyle,
    this.onHashtagTap,
    this.mentionStyle,
    this.onMentionTap,
    this.expandOnTextTap = false,
    this.collapseOnTextTap = false,
    this.style,
    this.textDirection,
    this.textAlign,
    this.textScaleFactor,
    this.maxLines = 2,
    this.animation = false,
    this.animationDuration,
    this.animationCurve,
    this.semanticsLabel,
  }) : assert(maxLines > 0);

  final String text;
  // final String expandText;
  final ExpandTextSpan expandWidget;
  final ExpandTextSpan? collapseWidget;
  // final String? collapseText;
  final bool expanded;
  final ValueChanged<bool>? onExpandedChanged;
  final VoidCallback? onLinkTap;
  final Color? linkColor;
  final bool linkEllipsis;
  final TextStyle? linkStyle;
  final String? prefixText;
  final TextStyle? prefixStyle;
  final VoidCallback? onPrefixTap;
  final TextStyle? urlStyle;
  final StringCallback? onUrlTap;
  final TextStyle? hashtagStyle;
  final StringCallback? onHashtagTap;
  final TextStyle? mentionStyle;
  final StringCallback? onMentionTap;
  final bool expandOnTextTap;
  final bool collapseOnTextTap;
  final TextStyle? style;
  final TextDirection? textDirection;
  final TextAlign? textAlign;
  final double? textScaleFactor;
  final int maxLines;
  final bool animation;
  final Duration? animationDuration;
  final Curve? animationCurve;
  final String? semanticsLabel;

  @override
  ExpandTextState createState() => ExpandTextState();
}

class ExpandTextState extends State<ExpandText> with TickerProviderStateMixin {
  bool _expanded = false;
  late TapGestureRecognizer _linkTapGestureRecognizer;
  late TapGestureRecognizer _prefixTapGestureRecognizer;

  List<TextSegment> _textSegments = [];
  final List<TapGestureRecognizer> _textSegmentsTapGestureRecognizers = [];

  @override
  void initState() {
    super.initState();

    _expanded = widget.expanded;
    _linkTapGestureRecognizer = TapGestureRecognizer()..onTap = _linkTapped;
    _prefixTapGestureRecognizer = TapGestureRecognizer()..onTap = _prefixTapped;

    _updateText();
  }

  @override
  void didUpdateWidget(ExpandText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.text != widget.text ||
        oldWidget.onUrlTap != widget.onUrlTap ||
        oldWidget.onHashtagTap != widget.onHashtagTap ||
        oldWidget.onMentionTap != widget.onMentionTap) {
      _updateText();
    }
  }

  @override
  void dispose() {
    _linkTapGestureRecognizer.dispose();
    _prefixTapGestureRecognizer.dispose();
    _textSegmentsTapGestureRecognizers
        .forEach((recognizer) => recognizer.dispose());
    super.dispose();
  }

  void _linkTapped() {
    if (widget.onLinkTap != null) {
      widget.onLinkTap!();
      return;
    }

    final toggledExpanded = !_expanded;

    setState(() => _expanded = toggledExpanded);

    widget.onExpandedChanged?.call(toggledExpanded);
  }

  void _prefixTapped() {
    widget.onPrefixTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    var effectiveTextStyle = widget.style;
    if (widget.style == null || widget.style!.inherit) {
      effectiveTextStyle = defaultTextStyle.style.merge(widget.style);
    }

    final linkWidget =
        (_expanded ? widget.collapseWidget : widget.expandWidget);
    final linkColor = widget.linkColor ??
        widget.linkStyle?.color ??
        Theme.of(context).colorScheme.secondary;
    final linkTextStyle =
        effectiveTextStyle!.merge(widget.linkStyle).copyWith(color: linkColor);

    final prefixText =
        widget.prefixText != null && widget.prefixText!.isNotEmpty
            ? '${widget.prefixText} '
            : '';

    final link = TextSpan(
      children: [
        if (linkWidget != null)
          TextSpan(
            text: _expanded ? '' : '\u2026 ',
            style: widget.style,
            recognizer: widget.linkEllipsis ? _linkTapGestureRecognizer : null,
          ),
        if (linkWidget != null)
          TextSpan(
            style: effectiveTextStyle,
            children: <InlineSpan>[
              WidgetSpan(
                  child: GestureDetector(
                child: linkWidget.child,
                onTap: () {
                  _linkTapGestureRecognizer.onTap?.call();
                },
              )),
            ],
          ),
      ],
    );

    final prefix = TextSpan(
      text: prefixText,
      style: effectiveTextStyle.merge(widget.prefixStyle),
      recognizer: _prefixTapGestureRecognizer,
    );

    final text = _textSegments.isNotEmpty
        ? TextSpan(
            children: _buildTextSpans(_textSegments, effectiveTextStyle, null))
        : TextSpan(text: widget.text);

    final content = TextSpan(
      children: <TextSpan>[prefix, text],
      style: effectiveTextStyle,
    );

    Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        final double maxWidth = constraints.maxWidth;

        final textAlign =
            widget.textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start;
        final textDirection =
            widget.textDirection ?? Directionality.of(context);
        final textScaleFactor =
            widget.textScaleFactor ?? MediaQuery.textScaleFactorOf(context);
        final locale = Localizations.maybeLocaleOf(context);

        TextPainter textPainter = TextPainter(
          text: link,
          textAlign: textAlign,
          textDirection: textDirection,
          textScaleFactor: textScaleFactor,
          maxLines: widget.maxLines,
          locale: locale,
        );
        final linkWidget =
            (_expanded ? widget.collapseWidget : widget.expandWidget);
        Size? dimensionSize = linkWidget?.size;
        if (dimensionSize != null) {
          List<PlaceholderDimensions> dimensions = [
            PlaceholderDimensions(
              size: dimensionSize //size of yout WidgetSpan
              ,
              alignment: PlaceholderAlignment.top,
            )
          ];
          textPainter.setPlaceholderDimensions(dimensions);
        }

        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final linkSize = textPainter.size;

        textPainter.text = content;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final textSize = textPainter.size;

        TextSpan textSpan;
        if (textPainter.didExceedMaxLines) {
          final position = textPainter.getPositionForOffset(Offset(
            textSize.width - linkSize.width,
            textSize.height,
          ));
          final endOffset =
              (textPainter.getOffsetBefore(position.offset) ?? 0) -
                  prefixText.length;

          final recognizer =
              (_expanded ? widget.collapseOnTextTap : widget.expandOnTextTap)
                  ? _linkTapGestureRecognizer
                  : null;

          final text = _textSegments.isNotEmpty
              ? TextSpan(
                  children: _buildTextSpans(
                      _expanded
                          ? _textSegments
                          : parseText(
                              widget.text.substring(0, max(endOffset, 0))),
                      effectiveTextStyle!,
                      recognizer),
                )
              : TextSpan(
                  text: _expanded
                      ? widget.text
                      : widget.text.substring(0, max(endOffset, 0)),
                  recognizer: recognizer,
                );

          textSpan = TextSpan(
            style: effectiveTextStyle,
            children: <TextSpan>[
              prefix,
              text,
              link,
            ],
          );
        } else {
          textSpan = content;
        }

        final richText = RichText(
          text: textSpan,
          softWrap: true,
          textDirection: textDirection,
          textAlign: textAlign,
          textScaleFactor: textScaleFactor,
          overflow: TextOverflow.clip,
        );

        if (widget.animation) {
          return AnimatedSize(
            child: richText,
            duration: widget.animationDuration ?? Duration(milliseconds: 200),
            curve: widget.animationCurve ?? Curves.fastLinearToSlowEaseIn,
            alignment: Alignment.topLeft,
          );
        }

        return richText;
      },
    );

    if (widget.semanticsLabel != null) {
      result = Semantics(
        textDirection: widget.textDirection,
        label: widget.semanticsLabel,
        child: ExcludeSemantics(
          child: result,
        ),
      );
    }

    return result;
  }

  void _updateText() {
    _textSegmentsTapGestureRecognizers
        .forEach((recognizer) => recognizer.dispose());
    _textSegmentsTapGestureRecognizers.clear();

    if (widget.onUrlTap == null &&
        widget.onHashtagTap == null &&
        widget.onMentionTap == null) {
      _textSegments.clear();
      return;
    }

    _textSegments = parseText(widget.text);

    _textSegments.forEach((element) {
      if (element.isUrl && widget.onUrlTap != null) {
        final recognizer = TapGestureRecognizer()
          ..onTap = () {
            widget.onUrlTap!(element.name!);
          };

        _textSegmentsTapGestureRecognizers.add(recognizer);
      } else if (element.isHashtag && widget.onHashtagTap != null) {
        final recognizer = TapGestureRecognizer()
          ..onTap = () {
            widget.onHashtagTap!(element.name!);
          };

        _textSegmentsTapGestureRecognizers.add(recognizer);
      } else if (element.isMention && widget.onMentionTap != null) {
        final recognizer = TapGestureRecognizer()
          ..onTap = () {
            widget.onMentionTap!(element.name!);
          };

        _textSegmentsTapGestureRecognizers.add(recognizer);
      }
    });
  }

  List<TextSpan> _buildTextSpans(List<TextSegment> segments,
      TextStyle textStyle, TapGestureRecognizer? textTapRecognizer) {
    final spans = <TextSpan>[];

    var index = 0;
    for (var segment in segments) {
      TextStyle? style;
      TapGestureRecognizer? recognizer;

      if (segment.isUrl && widget.onUrlTap != null) {
        style = textStyle.merge(widget.urlStyle);
        recognizer = _textSegmentsTapGestureRecognizers[index++];
      } else if (segment.isMention && widget.onMentionTap != null) {
        style = textStyle.merge(widget.mentionStyle);
        recognizer = _textSegmentsTapGestureRecognizers[index++];
      } else if (segment.isHashtag && widget.onHashtagTap != null) {
        style = textStyle.merge(widget.hashtagStyle);
        recognizer = _textSegmentsTapGestureRecognizers[index++];
      }

      final span = TextSpan(
        text: segment.text,
        style: style,
        recognizer: recognizer ?? textTapRecognizer,
      );

      spans.add(span);
    }

    return spans;
  }
}
