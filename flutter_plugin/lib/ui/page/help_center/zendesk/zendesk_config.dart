import 'dart:io';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';

class ZendeskConfigManager {
  static final ZendeskConfigManager instance = ZendeskConfigManager._();

  ZendeskConfigManager._();

  Future<Map<String, dynamic>> getZendeskConfigWithList(
      List<BaseDeviceModel>? deviceList) async {
    final country = await LocalModule().getCurrentCountry();
    final countryCode = country.countryCode.toUpperCase();

    if (countryCode == 'TR' || countryCode == 'IN' || countryCode == 'MX') {
      // 新兴区域：土耳其 印度 墨西哥 等；
      return await _getConfigWith(otherConfig, deviceList);
    } else if (countryCode == 'US' || countryCode == 'CA') {
      // 北美区域：美国，加拿大
      return await _getConfigWith(usConfig, deviceList);
    } else {
      //保加利亚、罗马尼亚、匈牙利、捷克、哈萨克斯坦、德国、俄罗斯、芬兰、波兰、瑞典、挪威、丹麦、乌克兰、英国、西班牙、意大利、法国
      return await _getConfigWith(euConfig, deviceList);
    }
  }

  Future<Map<String, dynamic>> _getConfigWith(
      ZendeskConfig zendeskConfig, List<BaseDeviceModel>? deviceList) async {
    final country = await LocalModule().getCurrentCountry();
    final countryCode = country.countryCode.toUpperCase();
    var userInfo = await AccountModule().getUserInfo();

    zendeskConfig.region?.value = countryCode;
    zendeskConfig.uid?.value = userInfo?.uid;
    zendeskConfig.email?.value = userInfo?.email;

    BaseDeviceModel? device;
    if (deviceList?.length == 1) {
      device = deviceList?.first;
    }
    zendeskConfig.sn?.value = device?.sn;
    zendeskConfig.sNs?.value = deviceList?.map((e) => e.sn).join(',');
    zendeskConfig.model?.value = device?.model;
    zendeskConfig.models?.value = deviceList?.map((e) => e.model).join(',');
    zendeskConfig.did?.value = device?.did;
    zendeskConfig.dids?.value = deviceList?.map((e) => e.did).join(',');
    return zendeskConfig.toMap();
  }

  ZendeskConfig get euConfig => ZendeskConfig(
        apiKey: (Platform.isAndroid
            ? ZendeskApiKey.eu_android.apiKey.toString()
            : ZendeskApiKey.eu_ios.apiKey.toString()),
        region: ValueBean('45836310837401', null),
        uid: ValueBean('45857291786265', null),
        email: null,
        sn: ValueBean('44951063016473', null),
        sNs: null,
        model: ValueBean('4495122941711', null),
        models: null,
        did: ValueBean('45857636271257', null),
        dids: null, 
      );

  ZendeskConfig get otherConfig => ZendeskConfig(
        apiKey: (Platform.isAndroid
            ? ZendeskApiKey.other_android.apiKey.toString()
            : ZendeskApiKey.other_ios.apiKey.toString()),
        region: ValueBean('45816986266009', null),
        uid: ValueBean('45817040749337', null),
        email: ValueBean('45817094811417', null),
        sn: ValueBean('45817089731609', null),
        sNs: null,
        model: ValueBean('45817268478745', null),
        models: ValueBean('45817460869401', null),
        did: ValueBean('45817288349337', null),
        dids: ValueBean('45817491169305', null),
      );

  ZendeskConfig get usConfig => ZendeskConfig(
        apiKey: (Platform.isAndroid
            ? ZendeskApiKey.us_android.apiKey.toString()
            : ZendeskApiKey.us_ios.apiKey.toString()),
        region: null,
        uid: null,
        email: null,
        sn: null,
        sNs: null,
        model: null,
        models: null,
        did: null,
        dids: null,
      );
}

class ValueBean {
  final String key;
  String? value;
  ValueBean(this.key, this.value);
}

class ZendeskConfig {
  final String apiKey;
  ValueBean? region;
  ValueBean? uid;
  ValueBean? email;
  ValueBean? sn;
  ValueBean? sNs;
  ValueBean? model;
  ValueBean? models;
  ValueBean? did;
  ValueBean? dids;

  ZendeskConfig({
    required this.apiKey,
    this.region,
    this.uid,
    this.email,
    this.sn,
    this.sNs,
    this.model,
    this.models,
    this.did,
    this.dids,
  });

  ZendeskConfig copyWith({
    String? apiKey,
    ValueBean? region,
    ValueBean? uid,
    ValueBean? email,
    ValueBean? sn,
    ValueBean? sNs,
    ValueBean? model,
    ValueBean? models,
    ValueBean? did,
    ValueBean? dids,
  }) {
    return ZendeskConfig(
      apiKey: apiKey ?? this.apiKey,
      region: region ?? this.region,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      sn: sn ?? this.sn,
      sNs: sNs ?? this.sNs,
      model: model ?? this.model,
      models: models ?? this.models,
      did: did ?? this.did,
      dids: dids ?? this.dids,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['apiKey'] = apiKey;

    if (region != null) {
      map[region!.key] = region!.value ?? '';
    }
    if (uid != null) {
      map[uid!.key] = uid!.value ?? '';
    }
    if (email != null) {
      map[email!.key] = email!.value ?? '';
    }
    if (sn != null) {
      map[sn!.key] = sn!.value ?? '';
    }
    if (sNs != null) {
      map[sNs!.key] = sNs!.value ?? '';
    }
    if (model != null) {
      map[model!.key] = model!.value ?? '';
    }
    if (models != null) {
      map[models!.key] = models!.value ?? '';
    }
    if (did != null) {
      map[did!.key] = did!.value ?? '';
    }
    if (dids != null) {
      map[dids!.key] = dids!.value ?? '';
    }

    return map;
  }
}

enum ZendeskApiKey {
  // 欧洲区域 @苏盼盼
  eu_android(
      'eyJzZXR0aW5nc191cmwiOiJodHRwczovL21vdmF0ZWNoLnplbmRlc2suY29tL21vYmlsZV9zZGtfYXBpL3NldHRpbmdzLzAxSlJKNDJGRUIwU1FTQUQ5WjhZV05RQUVQLmpzb24ifQ=='),
  eu_ios(
      'eyJzZXR0aW5nc191cmwiOiJodHRwczovL21vdmF0ZWNoLnplbmRlc2suY29tL21vYmlsZV9zZGtfYXBpL3NldHRpbmdzLzAxSlJIQzhGUjdZNFZRVzdaVkhTTlE5UldaLmpzb24ifQ=='),
  // 北美区域 @谭铁忠
  us_android(
      'eyJzZXR0aW5nc191cmwiOiJodHRwczovL21vdmF0ZWNobmEuemVuZGVzay5jb20vbW9iaWxlX3Nka19hcGkvc2V0dGluZ3MvMDFKVFQ1MEU1NlNZNUtKNjQ0MEQzQUVBNkQuanNvbiJ9'),
  us_ios(
      'eyJzZXR0aW5nc191cmwiOiJodHRwczovL21vdmF0ZWNobmEuemVuZGVzay5jb20vbW9iaWxlX3Nka19hcGkvc2V0dGluZ3MvMDFKVFNIQktNQUNEQUtUMUdFMDk4MkpGNTkuanNvbiJ9'),
  // 新兴区域 @赵敏妍
  other_android(
      'eyJzZXR0aW5nc191cmwiOiJodHRwczovL2RyZWFtZWNhcmUuemVuZGVzay5jb20vbW9iaWxlX3Nka19hcGkvc2V0dGluZ3MvMDFKUllQVDVGWkFUNkczOVQ2MTYzTUs5ODcuanNvbiJ9'),
  other_ios(
      'eyJzZXR0aW5nc191cmwiOiJodHRwczovL2RyZWFtZWNhcmUuemVuZGVzay5jb20vbW9iaWxlX3Nka19hcGkvc2V0dGluZ3MvMDFKUllQNE5BRkpOME0yVzZTVzJHRUE2VEMuanNvbiJ9'),
  ;

  final String apiKey;

  const ZendeskApiKey(this.apiKey);
}
