import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_plugin/common/providers/life_cycle_manager.dart';
import 'package:flutter_plugin/model/event/account_info_event.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/mine/custom_scroll_behavior.dart';
import 'package:flutter_plugin/ui/page/settings/account/account_setting_state_notifier.dart';
import 'package:flutter_plugin/ui/page/settings/account/account_setting_ui_state.dart';
import 'package:flutter_plugin/ui/page/settings/changepassword/user_change_password_page.dart';
import 'package:flutter_plugin/ui/page/settings/logoff/user_logoff_page.dart';
import 'package:flutter_plugin/ui/page/settings/settingpassword/user_setting_password_page.dart';
import 'package:flutter_plugin/ui/page/settings/thirdAccount/user_third_account_page.dart';
import 'package:flutter_plugin/ui/page/settings/usermail/user_mail_page.dart';
import 'package:flutter_plugin/ui/page/settings/username/user_name_page.dart';
import 'package:flutter_plugin/ui/page/settings/userphone/user_phone_page.dart';
import 'package:flutter_plugin/ui/widget/dialog/birthday_select_dialog.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/dialog/gender_select_dialog.dart';
import 'package:flutter_plugin/ui/widget/dm_default_image.dart';
import 'package:flutter_plugin/ui/widget/dm_setting_item.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';

import 'package:flutter_plugin/utils/event_bus_util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: implementation_imports
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../widget/dm_button.dart';

class AccountSettingPage extends BasePage {
  static const String routePath = '/account_setting';

  const AccountSettingPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return AccountSettingPageState();
  }
}

class AccountSettingPageState extends BasePageState
    with CommonDialog, ResponseForeUiEvent {
  @override
  String get centerTitle => 'mine_account_setting'.tr();

  @override
  void initData() {
    super.initData();
    ref.read(accountSettingStateNotifierProvider.notifier).loadUserInfo();
  }

  @override
  void addObserver() {
    super.addObserver();
    ref.listen(accountSettingUiEventProvider, (previous, next) {
      responseFor(next);
    });
    ref.listen(
        accountSettingStateNotifierProvider.select((value) => value.uiEvent),
        (previous, next) {
      responseFor(next);
    });
  }

  @override
  void onTitleLeftClick() {
    EventBusUtil.getInstance().fire(AccountInfoEvent());
    super.onTitleLeftClick();
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    AccountSettingUiState accountUIState =
        ref.watch(accountSettingStateNotifierProvider);
    if (accountUIState.userInfo == null) {
      return const SizedBox.shrink();
    }
    UserInfoModel? userinfo = accountUIState.userInfo;

    return Container(
        color: style.bgGray,
        width: double.infinity,
        height: double.infinity,
        child: ScrollConfiguration(
            behavior: CustomScrollBehavior(),
            child: SingleChildScrollView(
              child: Column(children: [
                _buildUidSetting(style, resource, userinfo),
                _buildUserInfoSettings(style, resource, userinfo),
                _buildAccountBindInfoSettings(style, resource, userinfo),
                _buildAccountSettings(style, resource, userinfo),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(16, 20, 16, 31),
                  child:   DMButton(
                    backgroundGradient: style.cancelBtnGradient,
                    width: double.infinity,
                    height: 48,
                    borderRadius: style.buttonBorder,
                    text: 'log_out'.tr(),
                    textColor: style.lightDartBlack,
                    onClickCallback: (context) {
                      _tapLogOutButtonClick();
                    },
                  ),
                ),
              ]),
            )));
  }

  Widget _buildUidSetting(
      StyleModel style, ResourceModel resource, UserInfoModel? userInfo) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(style.circular8))),
      margin: const EdgeInsets.fromLTRB(4, 20, 4, 0),
      child: DmSettingItem(
        leadingTitle: 'account'.tr(args: [userInfo?.uid ?? '']),
        showDivider: true,
        dividerTopOffset: 10,
        paddingEnd: 0,
        showEndIcon: true,
        trailingText: userInfo?.uid ?? '',
        endWidget: GestureDetector(
          onTap: () async {
            await Clipboard.setData(ClipboardData(text: userInfo?.uid ?? ''));
            SmartDialog.showToast('copyed'.tr());
          },
          child: Container(
            padding: const EdgeInsets.only(right: 8),
            child: Semantics(
              label: 'copy_mova_id'.tr(),
              child: Image.asset(
                resource.getResource('ic_copy'),
                width: 20,
                height: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoSettings(
      StyleModel style, ResourceModel resource, UserInfoModel? userInfo) {
    //? DateFormatUtils.formatLocal(userInfo.birthday!.toString(), format: 'yyyy-MM-dd')

    String birthdayString = 'unset'.tr();
    if (userInfo != null &&
        userInfo.birthday != null &&
        userInfo.birthday != 0) {
      birthdayString = DateFormat('yyyy-MM-dd')
          .format(DateTime.fromMillisecondsSinceEpoch(userInfo.birthday!));
    }

    String nickName = userInfo?.name ?? '';

    String? regin = ref.watch(accountSettingStateNotifierProvider).regin;
    bool showGenderAndBirthday = regin?.toLowerCase() == 'cn' &&
        userInfo?.phoneCode == '86' &&
        userInfo?.phone?.length == 11;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(style.circular8))),
      margin: const EdgeInsets.fromLTRB(4, 20, 4, 0),
      child: Column(children: [
        DmSettingItem(
          leadingTitle: 'setting_avatar'.tr(),
          showDivider: false,
          showEndIcon: true,
          paddingTop: 12,
          paddingBottom: 12,
          onTap: (ctx) {
            _tapUploadImage(ctx, style, resource);
          },
          trailing: ClipOval(
              child: userInfo?.avatar == null ||
                      (userInfo?.avatar ?? '').isEmpty == true
                  ? DMDefaultAvatorImage(
                      uid: ref
                          .read(accountSettingStateNotifierProvider)
                          .userInfo
                          ?.uid,
                      width: 32,
                      height: 32,
                    )
                  : CachedNetworkImage(
                      imageUrl: userInfo?.avatar ?? '',
                      errorWidget: (context, string, _) {
                        return DMDefaultAvatorImage(
                          uid: ref
                              .read(accountSettingStateNotifierProvider)
                              .userInfo
                              ?.uid,
                          width: 32,
                          height: 32,
                        );
                      },
                      width: 32,
                      height: 32,
                    )),
        ),
        DmSettingItem(
          leadingTitle: 'set_nick'.tr(),
          showDivider: !showGenderAndBirthday,
          dividerTopOffset: 10,
          trailingText: nickName,
          trailingWidth: MediaQuery.of(context).size.width * 0.5,
          onTap: (ctx) {
            GoRouter.of(context).push(UserNameSettingPage.routePath).then(
                (value) => ref
                    .read(accountSettingStateNotifierProvider.notifier)
                    .getUserInfo());
          },
        ),
        Visibility(
            visible: showGenderAndBirthday,
            child: DmSettingItem(
              leadingTitle: 'mine_birthday_info'.tr(),
              leadingTitleWidth: 150,
              showEndIcon:
                  (userInfo != null && userInfo.birthday == 0) ? true : false,
              trailingText: birthdayString,
              onTap: (ctx) {
                if (userInfo != null && userInfo.birthday == 0) {
                  _clickBirthdayButton(userInfo);
                }
              },
            )),
        Visibility(
            visible: showGenderAndBirthday,
            child: DmSettingItem(
              leadingTitle: 'mine_gender'.tr(),
              showDivider: true,
              dividerTopOffset: 10,
              trailingText: (userInfo?.sex == 1 || userInfo?.sex == 2)
                  ? (userInfo?.sex == 1
                      ? 'mine_gender_male'.tr()
                      : 'mine_gender_female'.tr())
                  : 'unset'.tr(),
              onTap: (ctx) {
                _showGenderDialog();
              },
            ))
      ]),
    );
  }

  Widget _buildAccountBindInfoSettings(
      StyleModel style, ResourceModel resource, UserInfoModel? userInfo) {
    String emailAddress = userInfo?.email ?? 'not_bind'.tr();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(style.circular8))),
      margin: const EdgeInsets.fromLTRB(4, 20, 4, 0),
      child: Column(children: [
        DmSettingItem(
            leadingTitle: 'mine_phone_number'.tr(),
            trailingText: userInfo?.phone ?? 'not_bind'.tr(),
            onTap: (ctx) {
              GoRouter.of(context).push(UserPhoneSettingPage.routePath, extra: {
                'phone': userInfo?.phone
              }).then((value) => ref
                  .read(accountSettingStateNotifierProvider.notifier)
                  .getUserInfo());
            }),
        DmSettingItem(
            leadingTitle: 'mine_email'.tr(),
            trailingText: emailAddress,
            trailingWidth: 200,
            onTap: (ctx) {
              GoRouter.of(context).push(UserMailSettingPage.routePath, extra: {
                'emailAddress': userInfo?.email ?? '',
              }).then((value) => ref
                  .read(accountSettingStateNotifierProvider.notifier)
                  .getUserInfo());
            }),
        DmSettingItem(
          leadingTitle: 'Me_AccountSetting_3rdPardBundle'.tr(),
          paddingTop: 12,
          paddingBottom: 12,
          showDivider: true,
          dividerTopOffset: 10,
          onTap: (ctx) {
            GoRouter.of(context)
                .push(UserThirdAccountSettingPage.routePath)
                .then((value) => ref
                    .read(accountSettingStateNotifierProvider.notifier)
                    .getUserInfo());
          },
          trailing: (userInfo != null &&
                  userInfo.sources != null &&
                  userInfo.sources!.isNotEmpty)
              ? Row(
                  children: [
                    for (int i = 0; i < userInfo.sources!.length; i++)
                      if (userInfo.sources![i].isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Image.asset(
                            _get3rdPartIcon(resource, userInfo.sources![i]),
                            width: 32,
                            height: 32,
                          ),
                        )
                  ],
                )
              : SizedBox(
                  height: 32,
                  child: Center(
                    child: Text(
                      'not_bind'.tr(),
                      style: TextStyle(
                          height: 1.0,
                          fontSize: style.middleText,
                          color: style.textSecond),
                    ),
                  ),
                ),
        )
      ]),
    );
  }

  String _get3rdPartIcon(ResourceModel resource, String source) {
    switch (source) {
      case 'WECHAT_OPEN':
        return resource.getResource('ic_bind_wechat_small');
      case 'GOOGLE_APP':
        return resource.getResource('ic_bind_google_small');
      case 'FACEBOOK_APP':
        return resource.getResource('ic_bind_facebook_small');
      case 'APPLE':
        return resource.getResource('ic_bind_apple_small');
      default:
        return '';
    }
  }

  Widget _buildAccountSettings(
      StyleModel style, ResourceModel resource, UserInfoModel? userInfo) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(style.circular8))),
      margin: const EdgeInsets.fromLTRB(4, 20, 4, 0),
      child: Column(children: [
        DmSettingItem(
          leadingTitle: userInfo?.hasPass == true
              ? 'reset_password'.tr()
              : 'set_password'.tr(),
          onTap: (ctx) {
            if (userInfo?.hasPass == true) {
              GoRouter.of(context).push(UserChangePasswordPage.routePath);
            } else {
              GoRouter.of(context).push(UserSettingPasswordPage.routePath).then(
                  (value) => ref
                      .read(accountSettingStateNotifierProvider.notifier)
                      .getUserInfo());
            }
          },
        ),
        DmSettingItem(
          leadingTitle: 'logoff_account'.tr(),
          onTap: (ctx) {
            GoRouter.of(context).push(UserLogoffPage.routePath);
          },
        )
      ]),
    );
  }

  void _clickBirthdayButton(UserInfoModel? userInfo) {
    if (userInfo != null &&
        (userInfo.birthday != null && userInfo.birthday != 0)) {
      String formateDate = DateFormat('yyyy-MM-dd')
          .format(DateTime.fromMillisecondsSinceEpoch(userInfo.birthday!));
      _showBirthdayDialog(DateTime.parse(formateDate));
    } else {
      _showBirthdayDialog(DateTime.now());
    }
  }

  void _showBirthdayDialog(DateTime defaultShowTime) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return BirthdaySelectDialog(
              context: context,
              defaultDate: defaultShowTime,
              minimumDate: DateTime(1900, 2, 1, 0, 0, 0),
              maximumDate: DateTime.now(),
              cancelContent: 'cancel'.tr(),
              confirmContent: 'confirm'.tr(),
              confirmCallback: (value) {
                if (value is DateTime) {
                  DateTime selectDate = value;
                  showCommonDialog(
                      content: 'text_birthday_setting_tips'.tr(),
                      cancelContent: 'cancel'.tr(),
                      confirmContent: 'save'.tr(),
                      confirmCallback: () async {
                        Navigator.of(context).pop();
                        await ref
                            .read(accountSettingStateNotifierProvider.notifier)
                            .updateUserBirthday(selectDate);
                      });
                }
              });
        });
  }

  void _showGenderDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return GenderSelectDialog(context,
              itemArray: ['mine_gender_female'.tr(), 'mine_gender_male'.tr()],
              valueArray: const [2, 1],
              cancelContent: 'cancel'.tr(),
              confirmContent: 'confirm'.tr(),
              confirmCallback: (selectTitle, selectValue) async {
            await ref
                .read(accountSettingStateNotifierProvider.notifier)
                .updateUserSex(selectValue);
          });
        });
  }

  void _tapLogOutButtonClick() {
    showCommonDialog(
        content: 'log_out_title'.tr(),
        cancelContent: 'cancel'.tr(),
        confirmContent: 'confirm'.tr(),
        confirmCallback: () async {
          showLoading();
          await LifeCycleManager().logOut(
              logoutFuture: ref
                  .read(accountSettingStateNotifierProvider.notifier)
                  .logOutAccount);
          dismissLoading();
        });
  }

  Future<CroppedFile?> _cropImage(String filePath) async {
    var croppedImage = await ImageCropper().cropImage(
      sourcePath: filePath,
      maxWidth: 800,
      maxHeight: 800,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
    );
    if (croppedImage != null) {
      return croppedImage;
    }
    return null;
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
                        bool hasPermission =
                            await checkCameraPermission(permissionGranted: () {
                    _dealCameraImage();
                  });
                        if (hasPermission) {
                    await _dealCameraImage();
                  }
                  Navigator.of(context).pop();
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
                      onTap: () {
                  _dealPhotomage();
                  Navigator.of(context).pop();
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
              )
          );
        });
      },
    );
  }

  Future<void> _dealCameraImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (image == null) return;
    CroppedFile? imageFile = await _cropImage(image.path);
    if (imageFile == null) return;
    await ref
        .read(accountSettingStateNotifierProvider.notifier)
        .uploadAvator(File(imageFile.path));
    await ref.read(accountSettingStateNotifierProvider.notifier).getUserInfo();
  }

  Future<void> _dealPhotomage() async {
    bool hassPermission = await checkPhotosPermission();
    if (!hassPermission) return;

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (image == null) return;
    CroppedFile? imageFile = await _cropImage(image.path);
    if (imageFile == null) return;
    await ref
        .read(accountSettingStateNotifierProvider.notifier)
        .uploadAvator(File(imageFile.path));
    await ref.read(accountSettingStateNotifierProvider.notifier).getUserInfo();
  }

  /// 相机权限
  Future<bool> checkCameraPermission({VoidCallback? permissionGranted}) async {
    if (Platform.isIOS) {
      var status = await Permission.camera.request();
      if (status.isPermanentlyDenied) {
        // 拒绝且不再提示
        // await SmartDialog.showToast(tips);
        await showSimpleAlertView();

        return false;
      } else if (status == PermissionStatus.denied) {
        // 权限被拒绝
        await showCustomAlertView(() {
          AppSettings.openAppSettings(type: AppSettingsType.settings);
        });
        return false;
      }
      return true;
    } else if (Platform.isAndroid) {
      var status = await Permission.camera.status;
      if (status == PermissionStatus.denied) {
        // 权限被拒绝
        await showCustomAlertView(() async {
          var status = await Permission.camera.request();
          if (status == PermissionStatus.granted) {
            permissionGranted?.call();
          }
        });
        return false;
      } else if (status == PermissionStatus.permanentlyDenied) {
        await showSimpleAlertView();
      }
      return true;
    }

    return false;
  }

  /// 相册权限
  Future<bool> checkPhotosPermission() async {
    late PermissionStatus status;
    if (Platform.isIOS) {
      status = await Permission.photosAddOnly.request();
    } else {
      status = PermissionStatus.granted;
    }
    if (status.isPermanentlyDenied) {
      // 拒绝且不再提示
      // await SmartDialog.showToast(tips);
      await showSimpleAlertView();

      return false;
    } else if (status == PermissionStatus.denied) {
      // 权限被拒绝
      await showCustomAlertView(() {
        AppSettings.openAppSettings(type: AppSettingsType.settings);
      });
      return false;
    }

    return true;
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
        .read(accountSettingStateNotifierProvider.notifier)
        .showConfirmAlert(alert);
  }

  Future<void> showSimpleAlertView() async {
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
        .read(accountSettingStateNotifierProvider.notifier)
        .showConfirmAlert(alert);
  }
}
