import 'dart:convert';
import 'dart:typed_data';

import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';


class BtSendDataProtocol {
  // 协议帧
  // c0 00 00 82 02 00 00 00 00 00 01 54 7b 22 63 6f 64 65
  // 22 3a 31 2c 22 76 61 6c 75 65 22 3a 22 72 62 74 37 30
  // ······
  // 63 6f 6e 66 69 67 5f 72 6f 75 74 65 72 22 2c 22 6c 65
  // 6e 67 74 68 22 3a 32 30 38 7d 8f c0

  // 帧头/帧尾 标志位
  static const int byteHead = 0xC0;

  // 替换位 OxCO -> 0xDB 0xDC
  static const int byteDB = 0xDB;
  static const int byteDC = 0xDC;

  // 替换位 0xDB -> 0xDD
  static const int byteDD = 0xDD;

  // 操作类型
  static const int byteQuery = 0x81;
  static const int byteSetting = 0x82;
  static const int byteUpload = 0x83;
  static const int byteAckQuery = 0x84;
  static const int byteAckSetting = 0x90;
  static const int byteAcErr = 0xA0;

  // 对象标识
  static const int byteObjLink = 0x01;
  static const int byteObjNetwork = 0x02;
  static const int byteObjDefault = 0x03;

  // 解析数据
  Pair<int, String> parseQueryAckData(Uint8List data,
      {bool skipAckCheck = false}) {
    return parseDataPackage(data, byteAckQuery, byteObjLink,
        skipAckCheck: skipAckCheck);
  }

  Pair<int, String> parseSettingAckData(Uint8List data,
      {bool skipAckCheck = false}) {
    return parseDataPackage(data, byteAckSetting, byteObjNetwork,
        skipAckCheck: skipAckCheck);
  }

  // 发数据
  Uint8List packageQueryString(String? content) {
    if (content == null) {
      return Uint8List.fromList([]);
    }
    return packageSendData(
        byteQuery, byteObjLink, Uint8List.fromList(utf8.encode(content)));
  }

  Uint8List packageQueryData(Uint8List content) {
    return packageSendData(byteQuery, byteObjLink, content);
  }

  Uint8List packageSettingString(String content) {
    return packageSendData(
        byteSetting, byteObjNetwork, Uint8List.fromList(utf8.encode(content)));
  }

  Uint8List packageSettingData(Uint8List content) {
    return packageSendData(byteSetting, byteObjNetwork, content);
  }

  Pair<int, String> parseDataPackage(
      Uint8List revdata, int ackType, int objType,
      {bool skipAckCheck = false}) {
    // 截取第一个数据包
    int indexLast = revdata.length - 1;
    // 1、校验数据包是否完整
    if (revdata[0] != byteHead || revdata[indexLast] != byteHead) {
      return Pair(-1, 'data is not complete');
    }
    // 发送方标识
    if (revdata[1] != 0 || revdata[2] != 0) {
      return Pair(-1, 'data is not mine');
    }
    if (revdata[3] == byteAcErr) {
      return Pair(-2, 'ack err');
    }
    if (revdata[3] != ackType && !skipAckCheck) {
      return Pair(-3, 'data is other');
    }
    if (revdata[4] != objType && !skipAckCheck) {
      return Pair(-3, 'data is other');
    }

    // 接收到的转换后的数据包
    Uint8List data = revdata.convertBytes().dataSubList();

    // 5 6 7 8 9为保留位
    // 10 11 两位数据长度位
    int dataLen = (data[10] & 0xff) * 256 + (data[11] & 0xff);

    int dataFromIndex = dataLen > 0 ? 12 : -1;
    int dataToIndex = 12 + dataLen - 1;

    // 计算校验签名
    List<int> toList = revdata.toList();
    int byte2 = revdata[revdata.length - 2];
    int byte3 = revdata[revdata.length - 3];

    // 签名位数据
    int checksumData = revdata[revdata.length - 2];
    int endIndex;
    if (byte3 == byteDB && byte2 == byteDC) {
      // C0
      checksumData = byteHead;
      endIndex = revdata.length - 3;
    } else if (byte3 == byteDB && byte2 == byteDD) {
      // DB
      checksumData = byteDB;
      endIndex = revdata.length - 3;
    } else {
      endIndex = revdata.length - 2;
    }

    Uint8List checksum = toList.checksum(endIndex, skipHead: true);

    // 2、校验签名是否正确
    if (checksum[0] != checksumData) {
      return Pair(-4, 'data checksum error');
    }
    // 3、获取real数据list
    Uint8List contentBytes;
    if (dataLen > 0) {
      List<int> dataRealList = toList.sublist(dataFromIndex, dataToIndex + 1);
      // 4、取数据 去掉转义数据
      contentBytes = Uint8List.fromList(dataRealList);
    } else {
      contentBytes = Uint8List.fromList([0]);
    }

    return Pair(0, String.fromCharCodes(contentBytes));
  }

  // 配网数据
  Uint8List packageSendData(int type, int objType, Uint8List content) {
    List<int> dataFrame = [];
    List<int> data = packageDataFrame(content);
    // head
    dataFrame.add(0);
    dataFrame.add(0);
    // 发送方标识
    dataFrame.add(type);
    // 对象标识
    dataFrame.add(objType);
    // 保留
    dataFrame.addAll([0, 0, 0, 0, 0]);

    if (data.isNotEmpty) {
      // 数据长度
      addDataLen(data, dataFrame);
      // 数据内容
      dataFrame.addAll(data);
    } else {
      // 数据长度
      dataFrame.addAll([0, 0]);
    }
    // 替换
    List<int> flatMap = dataFrame.expand((byte) => byte.convertByte()).toList();
    List<int> tableBytes = [];
    tableBytes.addAll(flatMap);
    // 计算校验位
    Uint8List checksum = tableBytes.checksum(tableBytes.length);
    // 帧结束
    dataFrame.clear();
    dataFrame.add(byteHead);
    dataFrame.addAll(tableBytes);
    // 添加校验位
    dataFrame.addAll(checksum);
    dataFrame.add(byteHead);
    return Uint8List.fromList(dataFrame);
  }

  void addDataLen(List<int> data, List<int> dataFrame) {
    Uint8List dataLength = (data.length).calculateLength();
    if (dataLength.length > 1) {
      dataFrame.add(dataLength[0]);
      dataFrame.add(dataLength[1]);
    } else {
      // 高位
      dataFrame.add(0);
      //低位
      dataFrame.add(dataLength[0]);
    }
  }

  // 计算数据帧
  List<int> packageDataFrame(Uint8List contentByteArray) {
    return contentByteArray
        .map((byte) {
          return byte.convertByte();
        })
        .expand((x) => x)
        .toList();
  }
}

extension Checksum on List<int> {
  Uint8List checksum(int endIndex, {bool skipHead = false}) {
    int ret = 0;
    for (int index = 0; index < length; index++) {
      if ((skipHead && index == 0) || index >= endIndex) {
        // 跳过 head 和 校验位
      } else {
        ret = (ret + this[index]) & 0xFF;
      }
    }
    ret = ~ret & 0xFF;
    return Uint8List.fromList([ret]);
  }
}

extension CalculateLength on int {
  Uint8List calculateLength() {
    int h = this >> 8 & 0xff;
    int l = this & 0xff;
    return Uint8List.fromList([h, l]);
  }

  Uint8List convertByte() {
    switch (this) {
      case 0xC0:
        return Uint8List.fromList([0xDB, 0xDC]);
      case 0xDB:
        return Uint8List.fromList([0xDB, 0xDD]);
      default:
        return Uint8List.fromList([this]);
    }
  }
}

extension ConvertBytes on Uint8List {
  Uint8List dataSubList() {
    List<int> list = [];
    list.add(0xC0);
    for (int i = 1; i < length; i++) {
      if (this[i] == 0xC0) {
        break;
      }
      list.add(this[i]);
    }
    list.add(0xC0);
    return Uint8List.fromList(list);
  }

  Uint8List convertBytes() {
    List<int> list = [];
    bool skip = false;
    for (int i = 0; i < length; i++) {
      int b1 = this[i];
      if (skip) {
        skip = false;
        continue;
      }
      // 控制结束
      if (i + 1 > length - 1) {
        list.add(b1);
        continue;
      }
      int b2 = this[i + 1];
      if (b1 == 0xDB && b2 == 0xDC) {
        list.add(0xC0);
        skip = true;
      } else if (b1 == 0xDB && b2 == 0xDD) {
        list.add(0xDB);
        skip = true;
      } else {
        list.add(b1);
      }
    }
    return Uint8List.fromList(list);
  }
}
