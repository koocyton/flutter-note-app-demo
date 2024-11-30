import 'package:onote/i18n/locale/en.dart';
import 'package:onote/i18n/locale/cn.dart';
import 'package:onote/i18n/locale/tw.dart';
import 'package:onote/i18n/locale/hk.dart';
import 'package:onote/i18n/locale/de.dart';
import 'package:onote/i18n/locale/jp.dart';
import 'package:onote/i18n/locale/kr.dart';
import 'package:onote/i18n/locale/id.dart';
import 'package:onote/i18n/locale/in.dart';
import 'package:onote/i18n/locale/ru.dart';
import 'package:onote/i18n/locale/ar.dart';
import 'package:onote/i18n/locale/ng.dart';
import 'package:onote/i18n/locale/he.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension Transs on String {

  String get xtr {
    if (tr.contains(":")) {
      int trIndexOf = tr.indexOf(":");
      return tr.substring(trIndexOf+1);
    }
    return tr;
  }

  String xtrParams([Map<String, String> params = const {}]) {
    var trans = tr;
    if (tr.contains(":")) {
      int trIndexOf = tr.indexOf(":");
      trans = tr.substring(trIndexOf+1);
    }
    if (params.isNotEmpty) {
      params.forEach((key, value) {
        trans = trans.replaceAll('@$key', value);
      });
    }
    return trans;
  }
}

class TranslationService extends Translations {

  static Locale? get locale => Get.deviceLocale;

  static const fallbackLocale = Locale("en", "US");

  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enLang,
    'zh_CN': cnLang,
    'zh_TW': twLang,
    'zh_HK': hkLang,
    'de_DE': deLang,
    'ja_JP': jpLang,
    'ko_KR': krLang,
    'ru_RU': ruLang,
    'ar_AR': arLang,
    'hi_IN': inLang,
    'id_ID': idLang,
    'en_NG': ngLang,
    'he_IL': heLang
  };
}