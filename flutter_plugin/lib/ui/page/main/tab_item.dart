import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_plugin/model/home/tab_config.dart';
import 'package:flutter_plugin/ui/page/home/home_page.dart';
import 'package:flutter_plugin/ui/page/main/home_rule_app_model.dart';
import 'package:flutter_plugin/ui/page/mall/mall/discuz_page.dart';
import 'package:flutter_plugin/ui/page/mall/mall/mall_page.dart';
import 'package:flutter_plugin/ui/page/mine/mine_page.dart';
import 'package:flutter_plugin/ui/widget/common/keep_alive_wrapper.dart';
import 'package:flutter_plugin/ui/widget/nav/custom_navigation_bar.dart';
import 'package:flutter_plugin/utils/constant.dart';

class TabItem {
  TabItem(
      {required this.bean,
      required this.content,
      required this.type,
      this.extraData});

  final NavigationItemProtocol bean;
  Widget content;
  TabItemType type;
  Map<String, dynamic>? extraData;


  @override
  String toString() {
    return 'TabItem(type: $type, extraData: $extraData)';
  }

 

  static List<TabItem> createList(List<TabConfig> configs) {
    List<TabItem> list = [];
    for (var config in configs) {
      String? type = config.type;
      String? url = config.url;
      if (type == null || url == null) continue;
      TabItem? item;
      if (type == 'app_discard') {
        item = overSeaCreate(type: TabItemType.discuz, extraData: url);
      } else if (type == 'overseas_shopping_mall') {
        item = overSeaCreate(type: TabItemType.overseasMall, extraData: {
          Constant.mallUrl: url,
          Constant.mallType: 'overseas_mall',
        });
      }
      if (item != null) {
        list.add(item);
      }
    }
    return list;
  }

  static TabItem overSeaCreate({required TabItemType type, dynamic extraData}) {
    NavBean bean;
    Widget content;

    switch (type) {
      case TabItemType.explore:
        bean = NavBean(
          'text_descover'.tr(),
          normalImage: 'tab_find.png',
          checkedImage: 'tab_find_checked.png',
        );
        content = KeepAliveWrapper(
          keepAlive: true,
          child: MallPage.parse(
            '',
            key: const ValueKey(TabItemType.explore),
            type: TabItemType.explore,
          ),
        );
        break;
      case TabItemType.device:
        bean = NavBean(
          'device'.tr(),
          normalImage: 'tab_home.png',
          checkedImage: 'tab_home_checked.png',
        );
        content = const KeepAliveWrapper(
          keepAlive: true,
          child: HomePage(key: ValueKey(TabItemType.device)),
        );
        break;
      case TabItemType.mall:
        bean = NavBean(
          'tabBar_mall'.tr(),
          normalImage: 'tab_discover.png',
          checkedImage: 'tab_discove_checked.png',
        );
        content = KeepAliveWrapper(
          keepAlive: true,
          child: MallPage.parse(
            'pages/newShop/newShop',
            key: const ValueKey(TabItemType.mall),
            type: TabItemType.mall,
          ),
        );

        break;
      case TabItemType.overseasMall:
        bean = NavBean(
          'tabBar_mall'.tr(),
          normalImage: 'tab_discover.png',
          checkedImage: 'tab_discove_checked.png',
        );
        String mallUrl = extraData?[Constant.mallUrl] ?? '';
        content = KeepAliveWrapper(
          keepAlive: true,
          child: MallPage.parse(mallUrl,
              key: const ValueKey(TabItemType.overseasMall),
              type: TabItemType.overseasMall),
        );
        break;
      case TabItemType.vip:
        bean = NavBean(
          'tabBar_vip'.tr(),
          normalImage: 'tab_mine.png',
          checkedImage: 'tab_mine_checked.png',
        );
        content = KeepAliveWrapper(
          keepAlive: true,
          child: MallPage.parse('pagesA/vipCenter/vipCenter',
              key: const ValueKey(TabItemType.vip), type: TabItemType.vip),
        );
        break;
      case TabItemType.overseaMine:
        bean = NavBean(
          'mine'.tr(),
          normalImage: 'tab_mine.png',
          checkedImage: 'tab_mine_checked.png',
        );
        content = const KeepAliveWrapper(
          keepAlive: true,
          child: MinePage(
            key: ValueKey(TabItemType.overseaMine),
          ),
        );
      case TabItemType.mine:
        bean = NavBean(
          'mine'.tr(),
          normalImage: 'tab_mine.png',
          checkedImage: 'tab_mine_checked.png',
        );
        content = const KeepAliveWrapper(
          keepAlive: true,
          child: MinePage(key: ValueKey(TabItemType.mine)),
        );
      case TabItemType.discuz:
        bean = NavBean(
          'forum'.tr(),
          normalImage: 'tab_find.png',
          checkedImage: 'tab_find_checked.png',
        );
        content = KeepAliveWrapper(
            keepAlive: true,
            child: DisCuzPage.parse(extraData,
                key: const ValueKey(TabItemType.discuz)));
      default:
        bean = NavBean(
          'mine'.tr(),
          normalImage: 'tab_mine.png',
          checkedImage: 'tab_mine_checked.png',
        );
        content = const KeepAliveWrapper(
          keepAlive: true,
          child: MinePage(key: ValueKey(TabItemType.mine)),
        );
    }
    return TabItem(bean: bean, content: content, type: type);
  }

  static TabItem createWith(
      {required TabItemType type,
      required HomeRuleAppStyle style,
      Map<String, dynamic>? extraData}) {
    ThemeNavBean bean;
    Widget content;

    bean = ThemeNavBean(
      style.normal?.text ?? '',
      normalImage: style.normal?.icon ?? '',
      darkNormalImage: style.normal?.dark_icon ?? '',
      checkedImage: style.selected?.icon ?? '',
      darkCheckedImage: style.selected?.dark_icon ?? '',
      lottieUrl: style.lottie ?? '',
    );

    switch (type) {
      case TabItemType.explore:
        content = KeepAliveWrapper(
          keepAlive: true,
          child: DisCuzPage.parse(
            extraData?['path'] ?? '',
            key: ValueKey('${TabItemType.explore.name}_${style.hashCode}'),
          ),
        );
        break;
      case TabItemType.device:
        content = const KeepAliveWrapper(
          keepAlive: true,
          child: HomePage(key: ValueKey(TabItemType.device)),
        );
        break;
      case TabItemType.mall:
        content = KeepAliveWrapper(
          keepAlive: true,
          child: MallPage.parse(
            extraData?['path'] ?? '',
            key: ValueKey('${TabItemType.mall.name}_${extraData?['path']}'),
            type: TabItemType.mall,
          ),
        );

        break;
      case TabItemType.overseasMall:
        String mallUrl = extraData?[Constant.mallUrl] ?? '';
        content = KeepAliveWrapper(
          keepAlive: true,
          child: MallPage.parse(mallUrl,
              key: ValueKey(
                  '${TabItemType.overseasMall.name}_$mallUrl'),
              type: TabItemType.overseasMall),
        );
        break;
      case TabItemType.overseaMine:
        content = const KeepAliveWrapper(
          keepAlive: true,
          child: MinePage(
            key: ValueKey(TabItemType.overseaMine),
          ),
        );
        break;
      case TabItemType.mine:
       
        String path = extraData?['path'] ?? '';
        /* 兼容逻辑后期去掉*/
        if (path.isNotEmpty) {
          content = KeepAliveWrapper(
            keepAlive: true,
            child: MallPage.parse(
              extraData?['path'] ?? '',
              key: ValueKey('${TabItemType.mall.name}_${style.hashCode}'),
              type: TabItemType.mall,
            ),
          );
        } else {
          content = const KeepAliveWrapper(
            keepAlive: true,
            child: MinePage(key: ValueKey(TabItemType.mine)),
          );
        }
        break;

      default:
        content = const KeepAliveWrapper(
          keepAlive: true,
          child: MinePage(key: ValueKey(TabItemType.mine)),
        );
    }
    return TabItem(bean: bean, content: content, type: type);
  }
}

/// TAB类型
class TabItemType {
  /// 商城内嵌页面
  static const mallInner = 'mall_';
  /// 三方网页
  static const webOuter = 'web_';
  static const TabItemType explore = TabItemType('explore');
  static const TabItemType device = TabItemType('device');
  static const TabItemType mall = TabItemType('mall');
  static const TabItemType mine = TabItemType('mine');
  static const TabItemType discuz = TabItemType('discuz');
  static const TabItemType overseasMall = TabItemType('overseasMall');
  static const TabItemType vip = TabItemType('vip');
  static const TabItemType overseaMine = TabItemType('overseaMine');

  final String name;
  const TabItemType(this.name);

  @override
  int get hashCode => name.hashCode;

  @override
  bool operator ==(Object other) {
    return other is TabItemType && other.name == name;
  }
}


