import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nisba_app/src/data/repository.dart';
import 'package:nisba_app/src/utils/api_result.dart';
import 'package:nisba_app/src/utils/app_snackbar.dart';
import 'package:nisba_app/src/utils/dio_error_util.dart';

class PrivacySection {
  final IconData icon;
  final String title;
  final String content;

  const PrivacySection({
    required this.icon,
    required this.title,
    required this.content,
  });
}

class PrivacyController extends GetxController {
  final sections = <PrivacySection>[].obs;
  final isLoading = false.obs;

  final Repository repository = Get.find();
  final InternetConnectionChecker connectionChecker = Get.find();

  @override
  void onInit() {
    super.onInit();
    fetchTermPrivacy();
  }

  Future<void> fetchTermPrivacy() async {
    if (!await connectionChecker.hasConnection) {
      AppSnackbar.showError(message: 'check_connection'.tr);
      return;
    }
    isLoading.value = true;
    try {
      final res = await repository.getTermPrivacy();
      final data = ApiResult.ensureSuccess(res);
      final list = data is Map
          ? (data['about'] as List? ?? [])
          : <dynamic>[];
      final mapped = list.whereType<Map>().map((raw) {
        final map = Map<String, dynamic>.from(raw);
        final key = map['key']?.toString() ?? '';
        final value = map['value']?.toString() ?? '';
        return PrivacySection(
          icon: _iconForKey(key),
          title: _titleForKey(key),
          content: value,
        );
      }).toList();
      if (mapped.isNotEmpty) {
        sections.assignAll(mapped);
      } else {
        _seedFallback();
      }
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
      _seedFallback();
    } on DioException catch (e) {
      log(e.toString());
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
      _seedFallback();
    } catch (e) {
      AppSnackbar.showError(message: e.toString());
      _seedFallback();
    } finally {
      isLoading.value = false;
    }
  }

  IconData _iconForKey(String key) {
    final k = key.toLowerCase();
    if (k.contains('privacy') || k.contains('term')) {
      return Iconsax.document_text;
    }
    if (k.contains('about')) return Iconsax.info_circle;
    return Iconsax.document_text;
  }

  String _titleForKey(String key) {
    switch (key.toLowerCase()) {
      case 'terms':
      case 'term':
        return 'auto_key_609'.tr;
      case 'privacy':
        return 'auto_key_610'.tr;
      case 'about':
        return 'about_app'.tr;
      default:
        return key.isNotEmpty ? key : 'auto_key_611'.tr;
    }
  }

  void _seedFallback() {
    if (sections.isNotEmpty) return;
    sections.assignAll([
      PrivacySection(
        icon: Iconsax.document_text,
        title: 'auto_key_612'.tr,
        content:
            'auto_key_613'.tr,
      ),
      PrivacySection(
        icon: Iconsax.mobile,
        title: 'auto_key_614'.tr,
        content:
            'auto_key_615'.tr,
      ),
    ]);
  }
}
