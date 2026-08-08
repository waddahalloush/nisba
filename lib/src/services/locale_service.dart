import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../configs/locale_constants.dart';
import '../data/local/get_storage_helper.dart';
import '../data/repository.dart';

/// Persists locale and drives [Get.updateLocale] for reactive rebuilds + RTL.
class LocaleService extends GetxService {
  final Rx<Locale> locale = const Locale(LocaleConstants.arabic).obs;

  GetStorageHelper get _storage => Get.find<GetStorageHelper>();

  @override
  void onInit() {
    super.onInit();
    final code = _normalize(_storage.languageCode);
    locale.value = Locale(code);
  }

  bool get isRtl => locale.value.languageCode == LocaleConstants.arabic;

  TextDirection get textDirection =>
      isRtl ? TextDirection.rtl : TextDirection.ltr;

  /// Human-readable label for the settings row (native names, not translated).
  String get currentLanguageLabel {
    switch (locale.value.languageCode) {
      case LocaleConstants.arabic:
        return 'lang_arabic'.tr;
      case LocaleConstants.english:
      default:
        return 'lang_english'.tr;
    }
  }

  Future<void> setLocaleCode(String rawCode) async {
    final code = _normalize(rawCode);
    _storage.saveLanguageCode(code);
    final next = Locale(code);
    locale.value = next;
    Get.updateLocale(next);
    await _syncLangWithApi(code);
  }

  Future<void> _syncLangWithApi(String code) async {
    if (!Get.isRegistered<Repository>()) return;
    try {
      await Get.find<Repository>().updateLang(data: {'lang': code});
    } catch (_) {
      // Local locale already applied; ignore API failure.
    }
  }

  String _normalize(String code) {
    if (code == LocaleConstants.english || code == LocaleConstants.arabic) {
      return code;
    }
    return LocaleConstants.arabic;
  }
}
