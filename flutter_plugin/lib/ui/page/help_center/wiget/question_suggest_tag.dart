import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/theme_widget.dart';

class QuestionSuggestionTag extends StatefulWidget {
  final String title;
  final bool isSelect;
  final void Function(bool isSelect)? onTap;

  const QuestionSuggestionTag({
    super.key,
    required this.title,
    this.isSelect = false,
    this.onTap,
  });

  @override
  State<QuestionSuggestionTag> createState() => _QuestionSuggestionTagState();
}

class _QuestionSuggestionTagState extends State<QuestionSuggestionTag> {
  bool isSelect = false;

  @override
  void initState() {
    super.initState();
    isSelect = widget.isSelect;
  }

  void _onTap() {
    if (widget.onTap == null) {
      return;
    }
    setState(() {
      isSelect = !isSelect;
    });
    widget.onTap?.call(isSelect);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: ThemeWidget(builder: (_, style, resource) {
        return Container(
          decoration: BoxDecoration(
            color: isSelect
                ? style.questionSuggestTagSelectedBgColor
                : style.questionSuggestTagBgColor,
            borderRadius: BorderRadius.circular(style.tagBorder),
            border: widget.onTap == null
                ? (Border.all(color: style.click, width: 1))
                : isSelect
                    ? Border.all(
                        color: style.questionSuggestTagSelectedTextColor,
                        width: 1)
                    : Border.all(
                        color: style.questionSuggestTagBgColor, width: 1),
          ),
          clipBehavior: Clip.hardEdge,
          child: Stack(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Text(
                widget.title,
                style: style.normalStyle(
                  color: isSelect
                      ? style.questionSuggestTagSelectedTextColor
                      : style.textMainBlack,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (isSelect && widget.onTap != null)
              Positioned(
                  right: -1,
                  bottom: -1,
                  child: Image.asset(
                    resource.getResource(
                      'ic_feedback_select_tag',
                    ),
                    width: 14,
                    height: 12,
                  ))
          ]),
        );
      }),
    );
  }
}
