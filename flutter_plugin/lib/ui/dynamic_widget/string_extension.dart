import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:path_provider/path_provider.dart';

extension StringExtension on String {
  Future<File> getFile() async {
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    return File('${appDocumentsDir.path}/$this');
  }

  Future<Directory> getDirectory() async {
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    return Directory('${appDocumentsDir.path}/$this');
  }

  Future<FileSystemEntityType> getPathType() async {
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    String path = '${appDocumentsDir.path}/$this';
    FileSystemEntityType type = FileSystemEntity.typeSync(path);
    return type;
  }

  String aESCBCencrypt({required String secrectKey}) {
    final key = Key.fromUtf8(secrectKey); // 128-bit key
    final iv = IV.fromSecureRandom(16); // 16-byte IV
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));
    final plainText = this;
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    final combined = iv.bytes + encrypted.bytes;
    return base64.encode(combined);
  }
}
