import 'package:easy_localization/easy_localization.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/ui/widget/refresh/class_indicator.dart';

/// Classic header.
class CustomHeader extends Header {
  final Key? key;

  /// The location of the widget.
  /// Only supports [MainAxisAlignment.center],
  /// [MainAxisAlignment.start] and [MainAxisAlignment.end].
  final MainAxisAlignment mainAxisAlignment;

  /// Background color.
  final Color? backgroundColor;

  /// Text on [IndicatorMode.drag].
  final String? dragText;

  /// Text on [IndicatorMode.armed].
  final String? armedText;

  /// Text on [IndicatorMode.ready].
  final String? readyText;

  /// Text on [IndicatorMode.processing].
  final String? processingText;

  /// Text on [IndicatorMode.processed].
  final String? processedText;

  /// Text on [IndicatorResult.noMore].
  final String? noMoreText;

  /// Text on [IndicatorResult.fail].
  final String? failedText;

  /// Whether to display text.
  final bool showText;

  /// Message text.
  /// %T will be replaced with the last time.
  final String? messageText;

  /// Whether to display message.
  final bool showMessage;

  /// The dimension of the text area.
  /// When less than 0, calculate the length of the text widget.
  final double? textDimension;

  /// The dimension of the icon area.
  final double iconDimension;

  /// Spacing between text and icon.
  final double spacing;

  /// Icon when [IndicatorResult.success].
  final Widget? succeededIcon;

  /// Icon when [IndicatorResult.fail].
  final Widget? failedIcon;

  /// Icon when [IndicatorResult.noMore].
  final Widget? noMoreIcon;

  /// Text style.
  final TextStyle? textStyle;

  /// Text style.
  final TextStyle? messageStyle;

  /// Link [Stack.clipBehavior].
  final Clip clipBehavior;

  /// Icon style.
  final IconThemeData? iconTheme;

  /// Progress indicator size.
  final double? progressIndicatorSize;

  /// Progress indicator stroke width.
  /// See [CircularProgressIndicator.strokeWidth].
  final double? progressIndicatorStrokeWidth;

  const CustomHeader({
    this.key,
    double triggerOffset = 70,
    bool clamping = false,
    IndicatorPosition position = IndicatorPosition.above,
    Duration processedDuration = const Duration(seconds: 1),
    SpringBuilder? readySpringBuilder,
    bool springRebound = true,
    FrictionFactor? frictionFactor,
    bool safeArea = true,
    double? infiniteOffset,
    bool? hitOver,
    bool? infiniteHitOver,
    bool hapticFeedback = false,
    bool triggerWhenReach = false,
    bool triggerWhenRelease = false,
    double maxOverOffset = double.infinity,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.backgroundColor,
    this.dragText,
    this.armedText,
    this.readyText,
    this.processingText,
    this.processedText,
    this.noMoreText,
    this.failedText,
    this.showText = true,
    this.messageText,
    this.showMessage = true,
    this.textDimension,
    this.iconDimension = 24,
    this.spacing = 16,
    this.succeededIcon,
    this.failedIcon,
    this.noMoreIcon,
    this.textStyle,
    this.messageStyle,
    this.clipBehavior = Clip.hardEdge,
    this.iconTheme,
    this.progressIndicatorSize,
    this.progressIndicatorStrokeWidth,
  }) : super(
          triggerOffset: triggerOffset,
          clamping: clamping,
          processedDuration: processedDuration,
          readySpringBuilder: readySpringBuilder,
          springRebound: springRebound,
          frictionFactor: frictionFactor,
          safeArea: safeArea,
          infiniteOffset: infiniteOffset,
          hitOver: hitOver,
          infiniteHitOver: infiniteHitOver,
          position: position,
          hapticFeedback: hapticFeedback,
          triggerWhenReach: triggerWhenReach,
          triggerWhenRelease: triggerWhenRelease,
          maxOverOffset: maxOverOffset,
        );

  @override
  Widget build(BuildContext context, IndicatorState state) {
    return ClassicIndicator(
      key: key,
      state: state,
      backgroundColor: backgroundColor,
      mainAxisAlignment: mainAxisAlignment,
      dragText: dragText ?? 'pull_to_refresh'.tr(),
      armedText: armedText ?? 'release_to_refresh'.tr(),
      readyText: readyText ?? 'refreshing'.tr(),
      processingText: processingText ?? 'refreshing'.tr(),
      processedText: processedText ?? 'refresh_success'.tr(),
      noMoreText: noMoreText ?? 'No more',
      failedText: failedText ?? 'Failed',
      showText: showText,
      messageText: messageText ?? 'Last updated at %T',
      showMessage: false,
      textDimension: textDimension,
      iconDimension: iconDimension,
      spacing: spacing,
      reverse: state.reverse,
      succeededIcon: succeededIcon,
      failedIcon: failedIcon,
      noMoreIcon: noMoreIcon,
      textStyle: textStyle,
      messageStyle: messageStyle,
      clipBehavior: clipBehavior,
      iconTheme: iconTheme,
      progressIndicatorSize: progressIndicatorSize,
      progressIndicatorStrokeWidth: progressIndicatorStrokeWidth,
    );
  }
}
