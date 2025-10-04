import 'package:gamers_shield_vpn/localization/language/chinese.dart';
import 'package:get/get.dart';
import 'language/english.dart';
import 'language/german.dart';
import 'language/indo.dart';
import 'language/iran.dart';
import 'language/iraq.dart';
import 'language/russian.dart';
import 'language/turkey.dart';

class AppTranslations extends Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
    'en_US': english,
    'de_DE': german,
    'tr_TR': turkish,
    'id_ID': indonesian,
    'ar_IQ': arabic,
    'fa_IR': farsi,
    'ru_RU': russian,
    'zh_CN': chinese,
  };
}