import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_plugin/model/region_item.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/page/account/regionPicker/region_picker_page.dart';
import 'package:flutter_plugin/ui/widget/account/region_select_menu/region_select_menu_controller.dart';
import 'package:flutter_plugin/ui/widget/account/region_select_menu/region_select_menu_state.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RegionSelectMeun extends ConsumerStatefulWidget {
  const RegionSelectMeun({
    super.key,
    this.onRegion,
    this.onTap,
    this.canTap = true,
  });

  final void Function(RegionItem region)? onRegion;
  final void Function()? onTap;
  final bool canTap;

  // final RegionItem? currentItem;

  @override
  ConsumerState<RegionSelectMeun> createState() {
    return _RegionSelectMenuState();
  }
}

class _RegionSelectMenuState extends ConsumerState<RegionSelectMeun> {
  Future<void> pushToPickerRegion() async {
    widget.onTap?.call();
    RegionItem? item = ref.read(regionSelectMenuControllerProvider
        .select((value) => value?.currentRegion));
    if (item == null) return;
    Object? rebackObjc = await GoRouter.of(context).push(
        RegionPickerPage.routePath,
        extra: RegionPickerPage.createExtra(item));
    if (rebackObjc == null) return;
    if (rebackObjc is RegionItem) {
      RegionItem backItem = rebackObjc;
      await ref
          .read(regionSelectMenuControllerProvider.notifier)
          .updateRegion(backItem);
    }
  }

  @override
  void initState() {
    ref.read(regionSelectMenuControllerProvider.notifier).initState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(regionSelectMenuControllerProvider, (previous, next) {
      RegionItem? item = next?.currentRegion;
      if (item == null) return;
      widget.onRegion?.call(item);
    });

    RegionSelectMenuState? st = ref.watch(regionSelectMenuControllerProvider);

    if (st != null) {
      return ThemeWidget(
        builder: (context, style, resource) {
          return Semantics(
            child: GestureDetector(
              onTap: widget.canTap ? pushToPickerRegion : null,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                      '${st.regionName}(+${st.currentRegion?.code})',
                      style: TextStyle(
                          color: style.textMain,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                      strutStyle: const StrutStyle(
                        forceStrutHeight: true,
                      ),
                    ),
                  const SizedBox(width: 8),
                  Semantics(
                    label: 'switch_country_or_region'.tr(),
                    child: Visibility(
                      visible: widget.canTap,
                      child: Image.asset(resource.getResource('icon_arrow_right2'),
                              width: 7, height: 13)
                          .flipWithRTL(context),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
