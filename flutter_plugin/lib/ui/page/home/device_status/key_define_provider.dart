import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:package_info_plus/package_info_plus.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:path_provider_foundation/path_provider_foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'key_define_provider.g.dart';

@riverpod
class KeyDefine extends _$KeyDefine {
  final String _tableName = 'key_define';
  late Database _db;
  @override
  bool build() {
    return false;
  }

  Future<Database> getDB() async {
    // if (_db.isOpen) {
    //   return _db;
    // }
    String? databasesPath = await getDatabasesPath();
    try {
      if (Platform.isIOS) {
        databasesPath = await PathProviderFoundation()
            .getContainerPath(appGroupIdentifier: 'group.app.com.mova.smart');
      }
    } catch (error) {
      LogUtils.d(error.toString());
    }
    String path = join(databasesPath ?? '', 'dreame_flutter.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
    return _db;
  }

  Future<void> closeDB() async {
    if (_db.isOpen) {
      return await _db.close();
    }
  }

  Future<void> clearKeyDefine() async {
    final db = await getDB();
    await db.delete(_tableName);
  }

  Future<void> batch(String jsonStr, {String model = 'vacuum'}) async {
    final db = await getDB();
    Map jsonMap = jsonDecode(jsonStr);
    Map localKeyDefine = jsonMap['keyDefine'];
    int ver = jsonMap['ver'];
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version =
        ver.toString() == '-1' ? packageInfo.buildNumber : ver.toString();
    await db.transaction((txn) async {
      Batch batch = txn.batch();
      localKeyDefine.forEach((key, value) {
        localKeyDefine[key].forEach((language, content) {
          batch.insert(
              _tableName,
              {
                'key': key,
                'model': model,
                'language': language,
                'version': int.tryParse(version) ?? 0,
                'define': jsonEncode(localKeyDefine[key][language]),
                'tag': '${model}_${version}_${language}_$key'
              },
              conflictAlgorithm: ConflictAlgorithm.ignore);
        });
      });
      List<dynamic> results = await batch.commit();
      unawaited(db.delete(_tableName,
          where: 'model = ? and version != ?',
          whereArgs: [model, int.tryParse(version) ?? 0]));
      LogUtils.d(results.toString());
    });
    // await db.close();
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $_tableName (id INTEGER PRIMARY KEY, key TEXT, language TEXT, version INTEGER, model TEXT, define TEXT , tag TEXT UNIQUE)');
    await db.execute('CREATE INDEX index1 ON $_tableName(model)');
    await db.execute('CREATE INDEX index2 ON $_tableName(key)');
    await db.execute('CREATE INDEX index3 ON $_tableName(language)');
  }

  Future<Map> getKeyDefine(String model,
      {String key = '2.1', String language = 'en'}) async {
    try {
      final db = await getDB();
      List result = await db.query(_tableName,
          columns: ['define', 'model'],
          where: '(model = ? OR model = ?) AND key = ? AND language = ?',
          orderBy: 'version DESC',
          groupBy: 'model',
          whereArgs: [model, model.split('.')[1], key, language]);
      Map defaultKeyDefine = {};
      Map keyDefine = {};
      for (var item in result) {
        if (item['model'] == model) {
          keyDefine = jsonDecode(item['define']);
        } else {
          defaultKeyDefine = jsonDecode(item['define']);
        }
      }
      // await db.close();
      return keyDefine.isEmpty ? defaultKeyDefine : keyDefine;
    } catch (err) {
      LogUtils.d(err.toString());
    }
    return {};
  }

  Future<void> init() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = await getLatestVersion('vacuum');
      if (version != packageInfo.buildNumber) {
        String localKeyDefineStr = await rootBundle
            .loadString('assets/home_device/common_device_protocol.json');
        await batch(localKeyDefineStr, model: 'vacuum');
        localKeyDefineStr = await rootBundle
            .loadString('assets/home_device/common_hold_protocol.json');
        await batch(localKeyDefineStr, model: 'hold');
        localKeyDefineStr = await rootBundle
            .loadString('assets/home_device/common_mower_protocol.json');
        await batch(localKeyDefineStr, model: 'mower');
      }
    } catch (error) {
      LogUtils.e(error.toString());
    }
  }

  Future<String> getLatestVersion(String model) async {
    final db = await getDB();
    List result = await db.query(_tableName,
        columns: ['version'],
        where: 'model = ?',
        orderBy: 'version DESC',
        whereArgs: [model]);
    // await db.close();
    return result.isNotEmpty ? result[0]['version'].toString() : '-1';
  }
}
