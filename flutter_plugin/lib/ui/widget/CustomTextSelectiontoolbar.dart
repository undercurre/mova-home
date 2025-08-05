import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextSelectionToolbar extends AdaptiveTextSelectionToolbar {
  const CustomTextSelectionToolbar(
      {super.key, required super.children, required super.anchors});

  CustomTextSelectionToolbar.editableText({
    super.key,
    required EditableTextState editableTextState,
  }) : super.editableText(editableTextState: editableTextState);

  @override
  Widget build(BuildContext context) {
    // If there aren't any buttons to build, build an empty toolbar.
    if ((children != null && children!.isEmpty) ||
        (buttonItems != null && buttonItems!.isEmpty)) {
      return const SizedBox.shrink();
    }

    List<Widget> resultChildren = <Widget>[];
    for (int i = 0; i < buttonItems!.length; i++) {
      ContextMenuButtonItem buttonItem = buttonItems![i];
      resultChildren.add(SelectionToolBarButton(
        title: getButtonLabelString(context, buttonItem),
        onPressed: buttonItem.onPressed,
      ));
    }

    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
        return CupertinoTextSelectionToolbar(
          anchorAbove: anchors.primaryAnchor,
          anchorBelow: anchors.secondaryAnchor == null
              ? anchors.primaryAnchor
              : anchors.secondaryAnchor!,
          children: resultChildren,
        );
      case TargetPlatform.android:
        return TextSelectionToolbar(
          anchorAbove: anchors.primaryAnchor,
          anchorBelow: anchors.secondaryAnchor == null
              ? anchors.primaryAnchor
              : anchors.secondaryAnchor!,
          children: resultChildren,
        );
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return DesktopTextSelectionToolbar(
          anchor: anchors.primaryAnchor,
          children: resultChildren,
        );
      case TargetPlatform.macOS:
        return CupertinoDesktopTextSelectionToolbar(
          anchor: anchors.primaryAnchor,
          children: resultChildren,
        );
    }
  }

  /// Returns the default button label String for the button of the given
  /// [ContextMenuButtonType] on any platform.
  static String getButtonLabelString(
      BuildContext context, ContextMenuButtonItem buttonItem) {
    if (buttonItem.label != null) {
      return buttonItem.label!;
    }

    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        assert(debugCheckHasMaterialLocalizations(context));
        final MaterialLocalizations localizations =
            MaterialLocalizations.of(context);
        switch (buttonItem.type) {
          case ContextMenuButtonType.cut:
            return localizations.cutButtonLabel;
          case ContextMenuButtonType.copy:
            return localizations.copyButtonLabel;
          case ContextMenuButtonType.paste:
            return localizations.pasteButtonLabel;
          case ContextMenuButtonType.selectAll:
            return localizations.selectAllButtonLabel;
          case ContextMenuButtonType.delete:
            return localizations.deleteButtonTooltip.toUpperCase();
          // case ContextMenuButtonType.liveTextInput:
          //   return localizations.scanTextButtonLabel;
          case ContextMenuButtonType.custom:
            return '';
          default:
            return '';
        }
      default:
        return '';
    }
  }
}

class SelectionToolBarButton extends StatelessWidget {
  const SelectionToolBarButton({
    super.key,
    this.padding,
    this.width,
    this.height,
    required this.title,
    required this.onPressed,
  });
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final String title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.colorScheme.brightness == Brightness.dark;
    final Color foregroundColor = isDark ? Colors.black87 : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black87;

    return GestureDetector(
      onTap: () {
        onPressed?.call();
      },
      child: Container(
        width: width ?? 100,
        height: height ?? 50,
        color: foregroundColor,
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
