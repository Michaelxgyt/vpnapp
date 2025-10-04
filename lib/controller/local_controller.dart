import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../localization/storage_service.dart';

class LocaleController extends GetxController {
  final storage = Get.find<StorageService>();
  final RxString local = Get.locale.toString().obs;
  final RxString selectedCurrency = ''.obs;
  final box = GetStorage();

  final Map<String, dynamic> optionsLocales = {
    'en': {
      'languageCode': 'en',
      'countryCode': 'US',
      'description': 'English',
    },
    'de': {
      'languageCode': 'de',
      'countryCode': 'DE',
      'description': 'German',
    },
    'tr': {
      'languageCode': 'tr',
      'countryCode': 'TR',
      'description': 'Turkey',
    },
    'id': {
      'languageCode': 'id',
      'countryCode': 'ID',
      'description': 'Indonesian',
    },
    'ar': {
      'languageCode': 'ar',
      'countryCode': 'IQ',
      'description': 'Iraq',
    },
    'fa': {
      'languageCode': 'fa',
      'countryCode': 'IR',
      'description': 'Iran',
    },
    'ru': {
      'languageCode': 'ru',
      'countryCode': 'RU',
      'description': 'Russian',
    },
    'zh': {
      'languageCode': 'zh',
      'countryCode': 'CN',
      'description': 'Chinese',
    },
  };

  void updateLocale(String key) {
    final String languageCode = optionsLocales[key]['languageCode'];
    final String countryCode = optionsLocales[key]['countryCode'];
    Get.updateLocale(Locale(languageCode, countryCode));
    local.value = Get.locale.toString();
    storage.write("languageCode", languageCode);
    storage.write("countryCode", countryCode);
  }


}