/**
 * 单片机配网参数组装
 * [https://dreametech.feishu.cn/docx/DwTmdsTSKoUirQxqePoc2NnenBe]
 */

import 'dart:math';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_connect/protocol/bt_send_data_protocol.dart';
import 'package:flutter_plugin/utils/logutils.dart';

class McuData {
  final int siid;
  final int piid;
  final int type;
  final List<int> content;

  McuData(this.siid, this.piid, this.type, this.content);

  @override
  String toString() {
    return 'McuData{siid: $siid, piid: $piid, type: $type, content: $content} contentStr: ${hex.encode(content)}';
  }
}

/// 通用蓝牙MCU发送数据协议
class BtMcuSendDataProtocol {
  static const int HEAD = 0xC0;
  static const int END = HEAD;

  static const int SIID_CONFIG_NET = 0x01;

  static const int PIID_STEP_1_RANDOM_CODE = 0x01;
  static const int PIID_STEP_1_CONFIG_NET = 0x02;

  static const int TYPE_ARRAY_NO = 0x0F;
  static const int TYPE_ARRAY = 0x80;

  static const int TYPE_STRING = 0x0;
  static const int TYPE_UINT8 = 0x1;
  static const int TYPE_UINT16 = 0x2;
  static const int TYPE_UINT32 = 0x3;
  static const int TYPE_UINT64 = 0x4;

  ///  下发配网参数 - 配网步骤1
  ///  [https://dreametech.feishu.cn/docx/DwTmdsTSKoUirQxqePoc2NnenBe]
  ///  [randomCode] 6位随机数 [uid] uid
  ///  数据包结构 HEAD + SIID + PIID + 字符串数组类型 + 字符串数组长度2 + RANDOM_LENGTH + RANDOM + UID_LENGTH + UID + END
  Future<Uint8List> packageRandomCode(String uid, String randomCode) async {
    List<int> packageFrame = [];
    // SIID
    packageFrame.add(SIID_CONFIG_NET);

    List<int> dataFrame = [];

    /// PIID
    dataFrame.add(PIID_STEP_1_RANDOM_CODE);

    const type = 0x80;
    dataFrame.add(type);
    final randomCodeBytes = randomCode.codeUnits;
    final uidBytes = uid.codeUnits;
    // 数组长度2
    dataFrame.add(2);
    // 随机数
    dataFrame.add(randomCodeBytes.length);
    dataFrame.addAll(randomCodeBytes);
    // uid
    dataFrame.add(uidBytes.length);
    dataFrame.addAll(uidBytes);
    packageFrame.addAll(dataFrame);
    // 转义字段
    final packageDataFrame =
        BtSendDataProtocol().packageDataFrame(Uint8List.fromList(packageFrame));
    // 添加头，尾
    packageDataFrame.insert(0, HEAD);
    packageDataFrame.add(END);
    return Uint8List.fromList(packageDataFrame);
  }

  /// 解析配网参数 [content] 数据内容
  Map<String, String> parseRandomCode(Uint8List content) {
    LogUtils.i('parseRandomCode: ${hex.encode(content)}');
    try {
      final mcuContent = parseMcuContent(SIID_CONFIG_NET, content);
      LogUtils.i('mcuContent: $mcuContent');
      if (mcuContent.isEmpty) {
        return {};
      }
      final encryptContent = hex.encode(mcuContent[0].content);
      final did = String.fromCharCodes(mcuContent[1].content);
      final ver = String.fromCharCodes(mcuContent[2].content);
      LogUtils.i('mcuContent: $mcuContent ,did: $did, ver: $ver');
      return {
        'code': '0',
        'encryptContent': encryptContent,
        'did': did,
        'ver': ver
      };
    } catch (e) {
      LogUtils.e('parseRandomCode error: $e');
    }
    return {
      'code': '-1',
    };
  }

  /// 下发配网参数 - 配网步骤2
  Uint8List packageConfigNet(bool success) {
    final list = <int>[];
    list.add(SIID_CONFIG_NET);
    list.addAll(packageMcuData(
        PIID_STEP_1_CONFIG_NET, TYPE_ARRAY_NO, TYPE_UINT8, [success ? 1 : 0]));
    final packageDataFrame =
        BtSendDataProtocol().packageDataFrame(Uint8List.fromList(list));
    packageDataFrame.insert(0, HEAD);
    packageDataFrame.add(END);
    return Uint8List.fromList(packageDataFrame);
  }

  Map<String, String> parseConfigNet(Uint8List content) {
    final mcuContent = parseMcuContent(SIID_CONFIG_NET, content);
    if (mcuContent.isNotEmpty) {
      final content1 = mcuContent[0].content;
      final type = mcuContent[0].type;
      if (type == TYPE_UINT8) {
        return {'code': content1[0] == 1 ? "0" : content1[0].toString()};
      }
    }
    return {'code': '-1'};
  }

  /// 组装数据 [pid] 操作类型 [type1] 是否是数据 0x0 否 0x1是 [type2]数据类型 0 string 1 uint8 2 uint16 3 uint32 4 uint64
  /// [content] 数据内容 当为字符串数组的时候，数组内容为: 字符串长度,字符串，字符串长度，字符串......
  List<int> packageMcuData(int pid, int type1, int type2, List<int> content) {
    final dataFrame = <int>[];
    dataFrame.add(pid);
    final type = type1 & TYPE_ARRAY | type2 & TYPE_ARRAY_NO;
    dataFrame.add(type);
    if (content.length > 1) {
      dataFrame.add(content.length);
    }
    dataFrame.addAll(content);
    return dataFrame;
  }

  /// 解析MCU数据格式
  /// 举例：C0 01 01 80 02 15 8B 13 58 14 BC 62 13 63 3B 5E 04 F2 0A 22 6D CE F9 9E 5C C1 10 0A 31 32 33 34 35 36 37 38 39 30 C0
  List<McuData> parseMcuContent(int siid, Uint8List convertBytes) {
    if (convertBytes.isEmpty) {
      // 数据空
      return [];
    }
    if (convertBytes[0] != HEAD &&
        convertBytes[convertBytes.length - 1] != END) {
      // 数据头尾错误
      return [];
    }
    if (convertBytes[1] != siid) {
      // 数据SIID错误
      return [];
    }
    final content = convertBytes.convertBytes();
    final contents = <McuData>[];
    var index = 2;
    while (index < content.length) {
      final piid = content[index++];
      final type = content[index++];
      final typeArr = type & TYPE_ARRAY;
      final arrLength = content[index++].toInt();
      if (typeArr == TYPE_ARRAY) {
        final byteType = type.toInt() & TYPE_ARRAY_NO.toInt();
        if (byteType == TYPE_STRING) {
          var subIndex = 0;
          while (subIndex < arrLength) {
            final length = content[index++];
            final data = content.sublist(index, index + length);
            contents.add(McuData(siid, piid, byteType, data));
            index += length;
            subIndex++;
          }
        } else {
          final data = content.sublist(index++, index + arrLength);
          contents.add(McuData(siid, piid, byteType, data));
        }
      } else {
        final byteType = type.toInt() & TYPE_ARRAY_NO.toInt();
        if (byteType == TYPE_UINT8) {
          contents.add(McuData(siid, piid, byteType, [arrLength]));
        } else {
          final data = content.sublist(index++, index + arrLength);
          contents.add(McuData(siid, piid, byteType, data));
        }
      }
      //Advance
      index += arrLength;
    }
    return contents;
  }

  /// 生成[a-z][0-9]的随机字符串
  String getRandomString(int length) {
    const str = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random.secure();
    final sb = StringBuffer();
    for (var i = 0; i < length; i++) {
      var number = random.nextInt(str.length);
      sb.write(str[number]);
    }
    return sb.toString();
  }
}
