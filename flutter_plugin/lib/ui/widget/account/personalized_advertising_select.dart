// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/page/privacy/privacy_policy_state_notifier.dart';
import 'package:flutter_plugin/ui/widget/account/global_resource_manager.dart';
import 'package:flutter_plugin/ui/widget/dm_format_rich_text.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonalizedAdvertisingSelect extends ConsumerStatefulWidget {
  ValueChanged<bool>? onSelectChange;
  bool? isCenter;
  late bool isChecked;
  final StyleModel styleModel;

  PersonalizedAdvertisingSelect(
      {super.key,
      required this.isChecked,
      this.onSelectChange,
      this.isCenter,
      required this.styleModel});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      PersonalizedAdvertisingSelectState();
}

class PersonalizedAdvertisingSelectState
    extends ConsumerState<PersonalizedAdvertisingSelect>
    with GlobalResourceManager {
  void togglePress() {
    setState(() {
      widget.isChecked = !widget.isChecked;
    });
    widget.onSelectChange?.call(widget.isChecked);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(privacyPolicyProvider);
    return Semantics(
      label: widget.isChecked ? 'selected'.tr() : 'not_selected'.tr(),
      child: GestureDetector(
          onTap: togglePress,
          child: widget.isCenter == true
              ? Center(child: buildChild())
              : buildChild()),
    );
  }

  Widget buildChild() {
    return Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 6).withRTL(context),
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Image(
                image: AssetImage(getResourceModel(ref).getResource(
                    widget.isChecked
                        ? 'ic_agreement_selected'
                        : 'ic_agreement_unselect')),
                width: 14,
                height: 14,
              ),
            ),
          ),
          Expanded(
            child: Semantics(
              label: 'subscription_ad'.tr(),
              textDirection: Directionality.of(context),
              child: DMFormatRichText(
                normalTextStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: widget.styleModel.textSecondGray,
                ),
                clickTextStyle: TextStyle(
                  color: widget.styleModel.linkGold,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
                content: 'subscription_ad'.tr(),
              ),
            ),
          )
        ]);
  }
}
