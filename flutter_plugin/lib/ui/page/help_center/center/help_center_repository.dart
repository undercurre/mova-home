import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:dreame_flutter_base_network/dreame_flutter_base_network.dart';
import 'package:dreame_flutter_widget_dialog/dreame_flutter_widget_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/common/bridge/ui_module.dart';
import 'package:flutter_plugin/common/network/http/api_client.dart';
import 'package:flutter_plugin/common/network/http/http_result_ext.dart';
import 'package:flutter_plugin/common/providers/api_client_provider.dart';
import 'package:flutter_plugin/common/providers/region_store.dart';
import 'package:flutter_plugin/model/webview_request.dart';
import 'package:flutter_plugin/ui/page/help_center/model/after_sale_fix_info.dart';
import 'package:flutter_plugin/ui/page/help_center/model/after_sale_info.dart';
import 'package:flutter_plugin/ui/page/help_center/model/after_sale_item.dart';
import 'package:flutter_plugin/ui/page/help_center/model/app_faq.dart';
import 'package:flutter_plugin/ui/page/help_center/model/feed_back_upload.dart';
import 'package:flutter_plugin/ui/page/help_center/model/feedback_tag.dart';
import 'package:flutter_plugin/ui/page/help_center/model/help_center_product.dart';
import 'package:flutter_plugin/ui/page/help_center/model/suggest_history_box.dart';
import 'package:flutter_plugin/ui/page/help_center/model/suggest_report_media.dart';
import 'package:flutter_plugin/ui/page/help_center/model/suggest_report_param.dart';
import 'package:flutter_plugin/ui/page/help_center/zendesk/zendesk_config.dart';
import 'package:flutter_plugin/ui/page/mall/mall/web_page.dart';
import 'package:flutter_plugin/utils/string_extension.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_plugin/ui/page/help_center/model/help_center_product_medias.dart';

part 'help_center_repository.g.dart';

class HelpCenterRepository {
  final ApiClient apiClient;

  HelpCenterRepository(this.apiClient);

  Future<List<HelpCenterProduct>> getHelpCenterProductList() async {
    try {
      final response = await apiClient.getHelpCenterProductList();
      return response.data ?? [];
    } catch (e) {
      rethrow;
    }
  }

  Future<AfterSaleInfo> _getSaleInfo() async {
    try {
      String langTag = await LocalModule().getCountryCode();
      final response = await apiClient.getAfterSale(langTag);
      if (response.successed()) {
        return Future.value(response.data);
      } else {
        return Future.error(DreameException(response.code, response.msg));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AfterSaleContactItem>> getContactInfo() async {
    AfterSaleInfo info = await _getSaleInfo();

    AfterSaleFixInfo fixInfo = AfterSaleFixInfo.fromOriInfo(info);
    print('fixInfo.onlineServiceInfo: ${fixInfo.onlineServiceInfo}');
    List<AfterSaleContactItem> saleContacts = [];
    if (fixInfo.onlineServiceInfo != null) {
      saleContacts.add(AfterSaleContactItem(
        image: 'ic_feedback_customer',
        contact: AfterSaleContact.onlineServer,
        title: 'online_server'.tr(),
        isShowEnter: true,
        onlineServiceInfo: fixInfo.onlineServiceInfo,
        onTap: (_) {},
      ));
    }
    for (var item in info.saleItems) {
      item.valueList.first;
      switch (item.key) {
        case 'text_offical_website':
          saleContacts.add(AfterSaleContactItem(
            image: 'ic_feedback_official_web',
            contact: AfterSaleContact.webSite,
            title: 'text_offical_website'.tr(),
            desc: item.valueList.first.channelContent ?? '',
            valueList: item.valueList,
            onTap: (contactItem) {
              LogModule().eventReport(7, 29);
              if (contactItem == null) {
                return;
              }
              toOuterBrowser((Platform.isIOS
                      ? contactItem.iosJumpLink
                      : contactItem.androidJumpLink) ??
                  '');
            },
          ));
          break;
        case 'hot_online':
          saleContacts.add(AfterSaleContactItem(
            image: 'ic_feedback_hotline',
            contact: AfterSaleContact.hotLine,
            title: 'hot_online'.tr(),
            desc: item.valueList.first.channelContent ?? '',
            valueList: item.valueList,
            onTap: (contactItem) {
              if (contactItem == null) {
                return;
              }
              toOuterBrowser((Platform.isIOS
                      ? contactItem.iosJumpLink
                      : contactItem.androidJumpLink) ??
                  '');
            },
          ));
          break;
        case 'text_email_service':
          saleContacts.add(AfterSaleContactItem(
            image: 'ic_feedback_email',
            contact: AfterSaleContact.email,
            title: 'text_email_service'.tr(),
            desc: item.valueList.first.channelContent ?? '',
            valueList: item.valueList,
            onTap: (contactItem) {
              if (contactItem == null) {
                return;
              }
              toOuterBrowser((Platform.isIOS
                      ? contactItem.iosJumpLink
                      : contactItem.androidJumpLink) ??
                  '');
            },
          ));
          break;
        case 'text_customer_service_center':
          saleContacts.add(AfterSaleContactItem(
            image: 'ic_feedback_customer',
            contact: AfterSaleContact.serviceCenter,
            title: 'text_customer_service_center'.tr(),
            desc: item.valueList.first.channelContent ?? '',
            valueList: item.valueList,
            onTap: (contactItem) {
              if (contactItem == null) {
                return;
              }
              toOuterBrowser((Platform.isIOS
                      ? contactItem.iosJumpLink
                      : contactItem.androidJumpLink) ??
                  '');
            },
          ));
          break;
        default:
          saleContacts.add(AfterSaleContactItem(
            image: 'ic_feedback_customer',
            desc: item.valueList.first.channelContent ?? '',
            contact: AfterSaleContact.other,
            title: item.key ?? '',
            valueList: item.valueList,
            onTap: (contactItem) {
              if (contactItem == null) {
                return;
              }
              toOuterBrowser((Platform.isIOS
                      ? contactItem.iosJumpLink
                      : contactItem.androidJumpLink) ??
                  '');
            },
          ));
          break;
      }
    }
    return saleContacts;
  }

  Future<List<AppFaq>> getfaqs({String? product}) async {
    try {
      String langTag = await LocalModule().getLangTag();
      final response =
          await apiClient.getHelpCenterProductFaq(langTag, product);
      if (response.successed()) {
        return Future.value(response.data);
      } else {
        return Future.error(DreameException(response.code, response.msg));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getPDF(String model) async {
    try {
      String langTag = await LocalModule().getLangTag();
      final response = await apiClient.getHelpCenterProductPdf(langTag, model);
      if (response.successed()) {
        return Future.value(response.data);
      } else {
        return Future.error(DreameException(response.code, response.msg));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> uploadDeviceLog(
      {required String did, required String model}) async {
    Map<String, dynamic> params = {
      'did': did,
      'model': model,
    };
    try {
      await apiClient.uploadDeviceLog(params);
      return Future.value();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<FeedBackTag>> getFeedBackTags({required String category}) {
    try {
      return apiClient.getFeedBackTags(category).then((value) {
        if (value.successed()) {
          return Future.value(value.data);
        } else {
          return Future.error(DreameException(value.code, value.msg));
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<String> uploadFeedBack(SuggestReportMedia media) async {
    try {
      final file = await media.assetEntity?.file;
      if (file == null) {
        return Future.error(DreameException(0, 'file is null'));
      }
      String fileName = '';
      if (media.type == SuggestReportMediaType.image) {
        fileName = '${await _getFileName()}.jpg';
      } else if (media.type == SuggestReportMediaType.video) {
        fileName = '${await _getFileName()}.mp4';
      }
      final upload = await _uploadFeedBackFileName(fileName: fileName);

      final result = await _uploadFile(upload.uploadUrl, file);
      if (result) {
        return upload.url;
      } else {
        return Future.error(DreameException(0, 'upload failed'));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<FeedBackUpload> _uploadFeedBackFileName(
      {required String fileName}) async {
    try {
      final result = await apiClient.getFeedBacUploadUrl(fileName);
      if (result.successed()) {
        return Future.value(result.data);
      } else {
        return Future.error(DreameException(result.code, result.msg));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> _uploadFile(String url, File file) async {
    Dio dio = Dio();

    // Create a file stream
    var fileStream = file.openRead();

    Response response = await dio.put(
      url,
      data: fileStream,
      options: Options(
        headers: {
          'Content-Type': null, // Set Content-Type to null
        },
        contentType: null, // Ensure the Content-Type is set to null
      ),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> _getFileName() async {
    String uid = (await AccountModule().getUserInfo())?.uid ?? '';
    String randomString = _generateRandomString(
        12); // replace with your logic to generate a random string
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    String combinedString = '$uid$randomString$timestamp';
    var bytes = utf8.encode(combinedString);
    var md5Hash = md5.convert(bytes);
    return md5Hash.toString();
  }

  String _generateRandomString(int len) {
    final random = Random();
    final result = String.fromCharCodes(
        List.generate(len, (index) => random.nextInt(33) + 89));
    return result;
  }

  Future<void> submitFeedBack(SuggestReportParam param) async {
    try {
      final result = await apiClient.postFeedBack(param.toJson());
      if (!result.successed()) {
        return Future.error(DreameException(result.code, result.msg));
      } else {
        return Future.value();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<SuggestHistoryBox> getSuggestHistory({required int page}) async {
    try {
      final result = await apiClient.getSuggestList(page, 10, 1);
      if (!result.successed()) {
        return Future.error(DreameException(result.code, result.msg));
      } else {
        return Future.value(result.data);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> submitSuggestHistory({required String model}) async {
    try {
      Dio dio = Dio();
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final url =
          'https://cnbj2.fds.api.xiaomi.com/dreame-product/app/$model/instructions.json?$timestamp';

      dio.options.headers['Content-Type'] = 'application/json';
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        debugPrint('response------: ${response.data}');

        // Handle successful response
        Map<String, dynamic> responseData = response.data;
        if (responseData.keys.contains('video')) {
          return responseData['video'];
        }
        return null;

        //ow you can access the response data as a Map<String, dynamic>
        // You can access the response body using response.data
      } else {
        // Handle error response
        return null;
      }
    } catch (e) {
      // Handle exception
      return null;
    }
  }

  Future<String> getProductDetail({required String productID}) async {
    try {
      final result = await apiClient.productContent(productID);
      if (!result.successed()) {
        return Future.error(DreameException(result.code, result.msg));
      } else {
        return Future.value(result.data as String);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<HelpCenterProductMedias?> getProductMediaList(
      {required String productID}) async {
    try {
      final result =
          await processApiResponse(apiClient.productMediaList(productID));
      return result;
    } catch (e) {
      return null;
    }
  }

  Future<void> pushToChat(
      {required BuildContext context,
      OnlineServiceInfo? info,
      List<BaseDeviceModel>? deviceList}) async {
    OnlineServiceInfo? fiInfo = info;
    if (fiInfo == null) {

      AfterSaleInfo info = await _getSaleInfo();
      AfterSaleFixInfo fixInfo = AfterSaleFixInfo.fromOriInfo(info);
      fiInfo = fixInfo.onlineServiceInfo;
    }
    if (fiInfo == null) {
      SmartDialog.showToast('operate_failed'.tr());
      return;
    }
    try {
      if (fiInfo is LiveChatOnlineServiceInfo) {
        final liveChatInfo = fiInfo;
        String short = RegionStore().currentRegion.countryCode.toLowerCase();
        String? email = (await AccountModule().getUserInfo())?.email;
        late String id = liveChatInfo.id;
        late String token = liveChatInfo.token;
        String encryptEmail =
            (email ?? '').aESCBCencrypt(secrectKey: 'dream_app_shulex');
        encryptEmail = Uri.encodeComponent(encryptEmail);
        final webrequest = WebViewRequest(
          uri: WebUri(
              'https://apps.voc.ai/live-chat?id=$id&token=$token&email=$encryptEmail&encrypt=true&country=$short&language=$short&lang=$short&noBrand=true'),
          defaultTitle: 'online_server'.tr(),
          cacheEnabled: false,
          clearCache: true,
          useHybridComposition: true,
        );
        if (context.mounted) {
          await GoRouter.of(context).push(WebPage.routePath, extra: webrequest);
        }
      } else if (fiInfo.type == OnlineServiceType.zhiChi) {
        await UIModule().openZhiChiCustomerService();
      } else {
        final params = await ZendeskConfigManager.instance
            .getZendeskConfigWithList(deviceList);
        await UIModule().openZendeskCustomerService(params);
      }
    } catch (e) {
      SmartDialog.showToast('operate_failed'.tr());
    }
  }

  // String encrypt(String data) {
  //   final key = Key.fromUtf8('dream_app_shulex'); // 128-bit key
  //   final iv = IV.fromSecureRandom(16); // 16-byte IV
  //   final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));
  //   final plainText = data;
  //   final encrypted = encrypter.encrypt(plainText, iv: iv);
  //   final combined = iv.bytes + encrypted.bytes;
  //   return base64.encode(combined);
  // }

  Future<void> toOuterBrowser(String url) async {
    debugPrint('toOuterBrowser: $url');
    Uri uri = Uri.parse(url);
    String scheme = uri.scheme;
    if (scheme == 'map') {
    } else {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    }
  }
}

@riverpod
HelpCenterRepository helpCenterRepository(HelpCenterRepositoryRef ref) {
  return HelpCenterRepository(ref.watch(apiClientProvider));
}
