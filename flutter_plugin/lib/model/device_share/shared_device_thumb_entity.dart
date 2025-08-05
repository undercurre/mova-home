import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/model/device_share/mine_recent_user.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/sharing/device_sharing_list_page.dart';

class SharedDeviceThumbEntity {
  // did
  String? did;
  // 型号
  String? model;
  // 权限
  String? permit;
  // productId
  String? productId;
  // 显示名
  String? displayName;
  // 自定义名称
  String? customName;
  // uid
  String? uid;
  // shareuid
  String? sharedUid;
  // 设备图片
  DeviceImageModel? mainImage;
  SharedState? sharedState;
  MineRecentUser? user;

  // 构造函数
  SharedDeviceThumbEntity({
    this.did,
    this.model,
    this.permit,
    this.productId,
    this.displayName,
    this.customName,
    this.uid,
    this.mainImage,
    this.sharedState,
    this.user,
    this.sharedUid,
  });

  // 使用 baseDeviceModel 初始化的构造函数
  SharedDeviceThumbEntity.fromBaseDeviceModel(BaseDeviceModel baseDeviceModel) {
    did = baseDeviceModel.did;
    model = baseDeviceModel.model;
    productId = baseDeviceModel.deviceInfo?.productId ?? '';
    displayName = baseDeviceModel.deviceInfo?.displayName;
    mainImage = baseDeviceModel.deviceInfo?.mainImage;
    permit = baseDeviceModel.deviceInfo?.permit;
    customName = baseDeviceModel.customName;
  }
}
