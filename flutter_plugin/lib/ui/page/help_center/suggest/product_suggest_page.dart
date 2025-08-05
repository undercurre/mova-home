import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:dreame_flutter_widget_dialog/dreame_flutter_widget_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_plugin/common/theme/app_theme_manager.dart';
import 'package:flutter_plugin/common/theme/app_theme_notifier.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/help_center/model/suggest_report_media.dart';
import 'package:flutter_plugin/ui/page/help_center/suggest/product_suggest_state_notifier.dart';
import 'package:flutter_plugin/ui/page/help_center/suggest_history/suggest_history_page.dart';
import 'package:flutter_plugin/ui/page/help_center/wiget/question_suggest_tag.dart';
import 'package:flutter_plugin/ui/widget/dialog/product_suggest_device_dialog.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/ui/widget/dm_format_rich_text.dart';
import 'package:flutter_plugin/utils/LogUtils.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

import 'custom_length_limit_text_input_formatter.dart';

class ProductSuggestPage extends BasePage {
  static const String routePath = '/product_suggest_page';
  final String? did;

  const ProductSuggestPage({super.key, this.did});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ProductSuggestPage();
  }
}

class _ProductSuggestPage extends BasePageState<ProductSuggestPage>
    with ResponseForeUiEvent {
  final GlobalKey keySwitch = GlobalKey();
  final _focusNode = FocusNode();

  @override
  Color? get navBackgroundColor {
    StyleModel style = ref.read(styleModelProvider);
    return style.bgColor;
  }

  @override
  Color? get backgroundColor {
    StyleModel style = ref.read(styleModelProvider);
    return style.bgGray;
  }

  @override
  String get centerTitle => 'text_product_suggestion'.tr();

  @override
  Widget? get rightItemWidget => ThemeWidget(
        builder: (_, style, resource) {
          return GestureDetector(
            onTap: () {
              responseFor(PushEvent(
                path: SuggestHistoryPage.routePath,
              ));
            },
            child: Container(
              padding: const EdgeInsets.only(right: 16).withRTL(context),
              child: Image(
                image: AssetImage(
                  resource.getResource('ic_suggest_history'),
                ),
                width: 24,
                height: 24,
              ),
            ),
          );
        },
      );

  @override
  void addObserver() {
    super.addObserver();
    ref.listen(
        productSuggestStateNotifierProvider.select((value) => value.event),
        (previous, next) {
      responseFor(next);
    });
  }

  Future<void> toSwitch() async {
    final RenderBox? renderBox =
        keySwitch.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset(0.0, size.height));

    await SmartDialog.show(
      tag: 'product_suggest_device_dialog',
      useAnimation: false,
      builder: (context) {
        return ProductSuggestDeviceDialog(
          onSelect: (index) {
            ref
                .read(productSuggestStateNotifierProvider.notifier)
                .selectIndex(index);
          },
          offset: offset,
          size: size,
          select: ref.read(productSuggestStateNotifierProvider
                  .select((value) => value.selectIndex)) ??
              0,
          productList: ref.read(productSuggestStateNotifierProvider
              .select((value) => value.deviceList)),
        );
      },
      clickMaskDismiss: true,
    );
  }

  Widget buildCard(DeviceModel? selectedDevice) {
    if (selectedDevice == null) {
      return Container();
    }
    return ThemeWidget(builder: (_, style, resource) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [style.bgWhite, style.bgWhite],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(style.circular8),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(children: [
          Container(
            padding:
                const EdgeInsets.only(left: 6, right: 24, top: 5, bottom: 5)
                    .withRTL(context),
            child: Row(children: [
              (selectedDevice.deviceInfo?.mainImage.imageUrl ?? '').isEmpty ==
                      true
                  ? Image.asset(
                      resource.getResource('ic_placeholder_robot'),
                      width: 70,
                      height: 70,
                    )
                  : CachedNetworkImage(
                      imageUrl:
                          selectedDevice.deviceInfo?.mainImage.imageUrl ?? '',
                      errorWidget: (context, string, _) {
                        return Image.asset(
                          resource.getResource('ic_placeholder_robot'),
                          width: 70,
                          height: 70,
                        );
                      },
                      width: 70,
                      height: 70,
                    ),
              Expanded(
                child: Text(
                  selectedDevice.getShowName(),
                  style: style.mainStyle(fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (ref.watch(productSuggestStateNotifierProvider
                  .select((value) => value.deviceList.length > 1)))
                GestureDetector(
                  key: keySwitch,
                  child: Image.asset(
                    resource.getResource('ic_faq_switch'),
                    width: 20,
                    height: 20,
                  ),
                  onTap: () {
                    toSwitch();
                  },
                )
            ]),
          ),
          if (!selectedDevice.master)
            Container(
              decoration: BoxDecoration(
                color: style.blueShare,
                borderRadius: BorderRadius.circular(4),
              ),
              clipBehavior: Clip.hardEdge,
              margin: const EdgeInsetsDirectional.only(top: 8, start: 8),
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              child: Text(
                'message_setting_share'.tr(),
                style: TextStyle(
                  fontSize: 12,
                  color: style.textWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
        ]),
      );
    });
  }

  @override
  void initData() {
    ref.watch(productSuggestStateNotifierProvider.notifier).initData();
    ref
        .watch(productSuggestStateNotifierProvider.notifier)
        .loadData(widget.did);
  }

  void previewIndex(int number) {
    List<AssetEntity> previewAssets = ref
        .watch(
            productSuggestStateNotifierProvider.select((value) => value.medias))
        .where((element) => element.type != SuggestReportMediaType.add)
        .map((e) => e.assetEntity!)
        .toList();
    ThemeData themeData = Theme.of(context);
    AssetPickerViewer.pushToViewer(context,
        previewAssets: previewAssets,
        themeData: themeData,
        currentIndex: number);
  }

  Widget buildNormalItem(SuggestReportMedia media, void Function() onRemoveItem,
      void Function() onTap) {
    return ThemeWidget(builder: (_, style, resource) {
      return Stack(children: [
        Align(
          alignment: Alignment.bottomLeft,
          child: FractionallySizedBox(
            widthFactor: 0.95,
            heightFactor: 0.95,
            child: GestureDetector(
              onTap: () {
                onTap();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(style.circular8),
                  color: style.bgGray,
                ),
                clipBehavior: Clip.hardEdge,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: Image(
                          image: AssetEntityImageProvider(media.assetEntity!,
                              isOriginal: false),
                          fit: BoxFit.cover,
                        )),
                    if (media.type == SuggestReportMediaType.video)
                      Image.asset(
                        resource.getResource('ic_video_tag'),
                        width: 18,
                        height: 24,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: onRemoveItem,
          child: Align(
            alignment: Alignment.topRight,
            child: Image.asset(
              resource.getResource('ic_question_report_remove'),
            ),
          ),
        ),
      ]);
    });
  }

  Widget buildAddlItem() {
    return ThemeWidget(builder: (_, style, resource) {
      return Align(
        alignment: Alignment.bottomLeft,
        child: FractionallySizedBox(
          widthFactor: 0.95,
          heightFactor: 0.95,
          child: GestureDetector(
            onTap: () async {
              /// 隐藏键盘
              _focusNode.unfocus();
              _tapUploadImage(context, style, resource);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(style.circular8),
                border: Border.all(
                  color: style.lightBlack1,
                ),
              ),
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    resource.getResource('ic_suggest_report_add'),
                    width: 24,
                    height: 24,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 3),
                    child: Text(
                      'text_pictures_videos'.tr(),
                      style: style.secondStyle(
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Future<void> _pushToAlbum() async {
    List<AssetEntity> previewAssets = ref
        .watch(
            productSuggestStateNotifierProvider.select((value) => value.medias))
        .where((element) => element.type != SuggestReportMediaType.add)
        .map((e) => e.assetEntity!)
        .toList();
    int maxAsset = 4 - previewAssets.length;
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        maxAssets: maxAsset,
        requestType: RequestType.common,
        filterOptions: FilterOptionGroup(
          videoOption: const FilterOption(
            durationConstraint: DurationConstraint(
              max: Duration(seconds: 120),
              allowNullable: false,
            ),
          ),
        ),
        selectPredicate: (context, asset, isSelected) {
          if (asset.type == AssetType.video && isSelected) {
            return asset.duration < 120;
          }
          return true;
        },
      ),
    );
    await immersionSystemBar();
    ref.read(productSuggestStateNotifierProvider.notifier).addVideos(result!);
  }

  /// 用来设置状态栏颜色
  Future<void> immersionSystemBar() async {
    // 根据暗黑模式状态设置状态栏样式
    return Future.delayed(const Duration(milliseconds: 300), () async {
      final themeMode =
          await ref.read(appThemeStateNotifierProvider.notifier).loadTheme();
      final style = ref.read(styleModelProvider);
      AppThemeManager().updateAppThemeMode(themeMode,
          systemNavigationBarColor: style.bgBlack);
    });
  }

  Future<void> _pushToCamera() async {
    final AssetEntity? entity = await CameraPicker.pickFromCamera(context,
        pickerConfig: const CameraPickerConfig(
          maximumRecordingDuration: Duration(seconds: 120),
        ),
        languageTextMap: {
          'cancel': 'cancel'.tr(),
          'confirm': 'confirm'.tr(),
          'shootingTips': 'shooting_tips'.tr(),
          'shootingWithRecordingTips': 'shooting_with_recording_tips'.tr(),
          'shootingOnlyRecordingTips': 'shooting_only_recording_tips'.tr(),
          'shootingTapRecordingTips': 'shooting_tap_recording_tips'.tr(),
          'cameraLoadFailed': 'camera_load_failed'.tr(),
          'cameraLoading': 'camera_loading'.tr(),
          'cameraSaving': 'camera_saving'.tr(),
          'sActionManuallyFocusHint': 's_action_manually_focus_hint'.tr(),
          'sActionRecordHint': 's_action_record_hint'.tr(),
          'sActionShootHint': 's_action_shoot_hint'.tr(),
          'sActionShootingButtonToolTip': 's_action_shooting_button_tool_tip'.tr(),
          'sActionStopRecordingHint': 's_action_stop_recording_hint'.tr(),
          'cameraSwitchTo': 'camera_switch_to'.tr(),
          'cameraLib': 'camera_lib'.tr(),
          'cameraPre': 'camera_pre'.tr(),
          'cameraAfter': 'camera_after'.tr(),
          'cameraOutside': 'camera_outside'.tr(),
          'cameraPreviewPicture': 'camera_preview_picture'.tr(),
          'cameraClose': 'camera_close'.tr(),
          'cameraAuto': 'camera_auto'.tr(),
          'cameraFlashWhenTaskingPhotos': 'camera_flash_when_tasking_photos'.tr(),
          'cameraAlwaysShining': 'camera_always_shining'.tr(),
          'cameraFlashMode': 'camera_flash_mode'.tr(),
        });
    // 设置状态栏
    await immersionSystemBar();
    if (entity == null) {
      return;
    }
    ref.read(productSuggestStateNotifierProvider.notifier).addVideos([entity]);
  }

  Future<void> _tapUploadImage(
      BuildContext context, StyleModel style, ResourceModel resource) async {
    await showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(style.circular20), // 顶部圆角
      ),
      builder: (context) {
        return ThemeWidget(builder: (context, style, resource) {
          return Container(
              decoration: BoxDecoration(
                color: style.bgWhite,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min, // 内容自适应高度
                  children: [
                    // 相机选项
                    ListTile(
                      title: Center(
                          child: Text(
                        'camera'.tr(),
                        style: TextStyle(
                          fontSize: style.largeText,
                          color: style.textMain,
                        ),
                      )),
                      onTap: () async {
                        Navigator.of(context).pop();
                        await checkCameraPermission();
                      },
                    ),
                    Divider(height: 1, color: style.lightBlack1),
                    // 相册选项
                    ListTile(
                      title: Center(
                          child: Text(
                        'photo_album'.tr(),
                        style: TextStyle(
                          fontSize: style.largeText,
                          color: style.textMain,
                        ),
                      )),
                      onTap: () async {
                        Navigator.of(context).pop();
                        await checkPhotosPermission();
                      },
                    ),
                    Divider(height: 1, color: style.lightBlack1),
                    // 取消按钮
                    ListTile(
                      title: Center(
                        child: Text(
                          'cancel'.tr(),
                          style: TextStyle(
                            fontSize: style.largeText,
                            color: style.red,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ));
        });
      },
    );
  }

  /// 相机权限
  Future<void> checkCameraPermission() async {
    if (Platform.isIOS) {
      await _pushToCamera();
    } else if (Platform.isAndroid) {
      var status = await Permission.camera.status;
      var storageStatus = PermissionStatus.granted;
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        storageStatus = await Permission.storage.status;
      }
      if (status == PermissionStatus.granted &&
          storageStatus == PermissionStatus.granted) {
        await _pushToCamera();
      } else {
        // 权限被拒绝
        await showCustomAlertView(() async {
          var status = await Permission.camera.status;
          var storageStatus = PermissionStatus.granted;
          if (androidInfo.version.sdkInt <= 32) {
            storageStatus = await Permission.storage.status;
          }
          LogUtils.i(
              'checkCameraPermission cameraStatus: $status ,storageStatus:$storageStatus');
          if (status == PermissionStatus.permanentlyDenied ||
              storageStatus == PermissionStatus.permanentlyDenied) {
            // 权限被拒绝
            await showOpenSettingDialog();
          } else {
            var status = await Permission.camera.request();
            var storageStatus = PermissionStatus.granted;
            if (androidInfo.version.sdkInt <= 32) {
              storageStatus = await Permission.storage.request();
            }
            if (status == PermissionStatus.granted &&
                storageStatus == PermissionStatus.granted) {
              await _pushToCamera();
            }
          }
        });
      }
    }
  }

  /// 相册权限
  Future<void> checkPhotosPermission() async {
    if (Platform.isIOS) {
      await _pushToAlbum();
    } else if (Platform.isAndroid) {
      Map<Permission, PermissionStatus> permissionMaps = {};
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        var storageStatus = await Permission.storage.status;
        permissionMaps = {Permission.storage: storageStatus};
      } else {
        var photosStatus = await Permission.photos.status;
        var videoStatus = await Permission.videos.status;
        permissionMaps = {
          Permission.photos: photosStatus,
          Permission.videos: videoStatus,
        };
      }
      LogUtils.d('permissionMaps: $permissionMaps');
      if (permissionMaps[Permission.storage] == PermissionStatus.granted ||
          permissionMaps[Permission.photos] == PermissionStatus.granted ||
          permissionMaps[Permission.videos] == PermissionStatus.granted) {
        await _pushToAlbum();
      } else {
        // 权限被拒绝
        await showCustomAlertView(() async {
          // 如果是永久拒绝，则弹出弹框去设置开启权限
          if (permissionMaps[Permission.storage] ==
                  PermissionStatus.permanentlyDenied ||
              (permissionMaps[Permission.photos] ==
                      PermissionStatus.permanentlyDenied &&
                  permissionMaps[Permission.videos] ==
                      PermissionStatus.permanentlyDenied)) {
            await showOpenSettingDialog();
            return;
          }
          if (androidInfo.version.sdkInt <= 32) {
            var storageStatus = await Permission.storage.request();
            permissionMaps = {Permission.storage: storageStatus};
          } else {
            permissionMaps =
                await [Permission.photos, Permission.videos].request();
          }
          LogUtils.d('permissionMaps2: $permissionMaps');
          if (permissionMaps[Permission.storage] == PermissionStatus.granted ||
              permissionMaps[Permission.photos] == PermissionStatus.granted ||
              permissionMaps[Permission.photos] == PermissionStatus.limited ||
              permissionMaps[Permission.videos] == PermissionStatus.granted ||
              permissionMaps[Permission.videos] == PermissionStatus.limited) {
            await _pushToAlbum();
          }
        });
      }
    }
  }

  Future<void> showCustomAlertView(Function() confirmCallback) async {
    CustomAlertEvent alert = CustomAlertEvent(
      contentAlign: TextAlign.left,
      content: 'Toast_SystemServicePermission_CameraPhoto'.tr(),
      confirmContent: 'next'.tr(),
      cancelContent: 'cancel'.tr(),
      confirmCallback: confirmCallback,
      cancelCallback: () {},
    );
    ref
        .read(productSuggestStateNotifierProvider.notifier)
        .showConfirmAlert(alert);
  }

  Future<void> showOpenSettingDialog() async {
    String permisson =
        '${'common_permission_camera'.tr()} 、 ${'common_permission_storage'.tr()}';
    String content = 'common_permission_fail_3'.tr(args: [permisson]);
    AlertEvent alert = AlertEvent(
        content: content,
        confirmContent: 'common_permission_goto'.tr(),
        cancelContent: 'cancel'.tr(),
        confirmCallback: () {
          AppSettings.openAppSettings(type: AppSettingsType.settings);
        },
        cancelCallback: () {});
    ref
        .read(productSuggestStateNotifierProvider.notifier)
        .showConfirmAlert(alert);
  }

  @override
  void onLifecycleEvent(LifecycleEvent event) {
    super.onLifecycleEvent(event);
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: buildCard(ref.watch(productSuggestStateNotifierProvider
                    .select((value) => value.selectedDevice))),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(style.circular8),
                        color: style.white,
                      ),
                      margin: const EdgeInsets.only(top: 12),
                      clipBehavior: Clip.hardEdge,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'text_suggestion_tag_tip'.tr(),
                            style: style.secondStyle(
                              fontSize: 12,
                            ),
                          ),
                          if (ref.watch(productSuggestStateNotifierProvider
                              .select((value) => value.showTags)))
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Wrap(
                                runSpacing: 12,
                                spacing: 12,
                                children: [
                                  for (var tag in ref.watch(
                                      productSuggestStateNotifierProvider
                                          .select((value) => value.tags)))
                                    QuestionSuggestionTag(
                                      title: tag.tagName,
                                      isSelect: tag.isSelected,
                                      onTap: (isSelect) {
                                        ref
                                            .read(
                                                productSuggestStateNotifierProvider
                                                    .notifier)
                                            .selectTag(tag.copyWith(
                                                isSelected: isSelect));
                                      },
                                    )
                                ],
                              ),
                            ),
                          Container(
                            margin: const EdgeInsets.only(top: 24),
                            constraints: const BoxConstraints(minHeight: 140),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: style.lightBlack,
                              borderRadius:
                                  BorderRadius.circular(style.circular8),
                            ),
                            child: Column(children: [
                              SizedBox(
                                height: 100,
                                child: TextField(
                                  style: style.thirdStyle(),
                                  expands: true,
                                  minLines: null,
                                  maxLines: null,
                                  maxLength: 500,
                                  focusNode: _focusNode,
                                  inputFormatters: [
                                    CustomLengthLimitingTextInputFormatter(500),
                                  ],
                                  magnifierConfiguration:
                                      TextMagnifierConfiguration.disabled,
                                  cursorColor: style.click,
                                  autofocus: false,
                                  textInputAction: TextInputAction.done,
                                  maxLengthEnforcement:
                                      MaxLengthEnforcement.enforced,
                                  onChanged: (value) {
                                    ref
                                        .read(
                                            productSuggestStateNotifierProvider
                                                .notifier)
                                        .onContentChange(value);
                                  },
                                  decoration: InputDecoration(
                                    hintText:
                                        'text_suggestion_content_hint'.tr(),
                                    hintStyle: style.disableStyle(
                                      fontSize: 14,
                                    ),
                                    hintMaxLines: 100,
                                    contentPadding: const EdgeInsets.all(0),
                                    border: InputBorder.none,
                                    counterText: '',
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  ref.watch(productSuggestStateNotifierProvider
                                      .select((value) => value.contentNumber)),
                                  style: style.disableStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ]),
                          ),
                          GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(top: 12, bottom: 8),
                            itemCount: ref
                                .watch(productSuggestStateNotifierProvider
                                    .select((value) => value.medias))
                                .length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 10,
                            ),
                            itemBuilder: (context, index) {
                              SuggestReportMedia media = ref.read(
                                  productSuggestStateNotifierProvider
                                      .select((value) => value.medias))[index];

                              if (media.type == SuggestReportMediaType.add) {
                                return buildAddlItem();
                              } else {
                                return buildNormalItem(media, () {
                                  ref
                                      .read(productSuggestStateNotifierProvider
                                          .notifier)
                                      .removeMedia(media);
                                }, () {
                                  previewIndex(index);
                                });
                              }
                            },
                          ),
                          Text(
                            'text_video_1min_suggest'.tr(),
                            style: style.disableStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Visibility(
                  visible: ref.watch(productSuggestStateNotifierProvider
                      .select((value) => value.visibleUploadLog)),
                  child: Container(
                    margin: const EdgeInsets.only(top: 12),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Image.asset(resource.getResource(ref.watch(
                                      productSuggestStateNotifierProvider
                                          .select(
                                              (value) => value.enableUploadLog))
                                  ? 'ic_agreement_selected'
                                  : 'ic_agreement_unselect')),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Flexible(
                              child: Text(
                                'upload_issue_logs'.tr(),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: style.textMain),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ).onClick(() {
                          ref
                              .read(
                                  productSuggestStateNotifierProvider.notifier)
                              .toggleEnableUploadLogBtn();
                        })),
                  ),
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: DMFormatRichText(
                    type: 1,
                    content: 'text_contact_us_new_tip'.tr(),
                    normalTextStyle: TextStyle(
                      color: style.textNormal,
                      fontSize: 14,
                    ),
                    clickTextStyle: TextStyle(
                      color: style.click,
                      fontSize: 14,
                    ),
                    richCallback: (index, key, content) {
                      ref
                          .read(productSuggestStateNotifierProvider.notifier)
                          .pushToChat();
                    },
                  ),
                ),
              )
            ],
          ),
        ),
        Column(children: [
          DMCommonClickButton(
            borderRadius: style.buttonBorder,
            margin: const EdgeInsets.only(top: 20, bottom: 23),
            enable: true,
            disableBackgroundGradient: style.disableBtnGradient,
            disableTextColor: style.disableBtnTextColor,
            textColor: style.enableBtnTextColor,
            backgroundGradient: style.confirmBtnGradient,
            text: 'feedback_submit'.tr(),
            height: 44,
            onClickCallback: () {
              ref.read(productSuggestStateNotifierProvider.notifier).submit();
            },
          )
        ])
      ]),
    );
  }
}
