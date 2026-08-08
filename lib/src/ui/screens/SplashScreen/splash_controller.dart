import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/configs/app_enums.dart';
import 'package:nisba_app/src/data/repository.dart';
import 'package:nisba_app/src/routes/routes_names.dart';
import 'package:nisba_app/src/utils/api_result.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../generated/assets.gen.dart';
import '../../../data/local/get_storage_helper.dart';

class SplashController extends GetxController {
  GetStorageHelper storageHelper = Get.find();
  Repository repository = Get.find();

  /// Matches the `version` in `pubspec.yaml`.
  static const String _appVersion = '1.0.0';

  @override
  onInit() {
    moveToNextPage();
    super.onInit();
  }

  String imgLogo = Assets.images.logo3d.path;

  Future<void> moveToNextPage() async {
    await Future.delayed(const Duration(seconds: 2));

    final allowedToContinue = await _checkAppVersion();
    if (!allowedToContinue) return;

    await _loadBasics();

    if (storageHelper.isLoggedIn()) {
      _syncFcmQuietly();
      Get.offAllNamed(AppRoutesNames.dashboard);
    } else {
      Get.offAllNamed(AppRoutesNames.login);
    }
  }

  /// Returns `false` when a mandatory update dialog is shown and navigation
  /// must stop here.
  Future<bool> _checkAppVersion() async {
    try {
      final res = await repository.checkAppVersion(
        data: {
          'platform': Platform.isIOS ? 'ios' : 'android',
          'version': _appVersion,
        },
      );
      final data = ApiResult.data(res);
      if (data is Map) {
        final status = data['update_status'];
        final statusValue = status is Map
            ? status['value']?.toString()
            : status?.toString();
        if (statusValue == AppEnums.updateMandatory) {
          final link = data['link']?.toString() ?? '';
          _showMandatoryUpdateDialog(link);
          return false;
        }
      }
    } catch (_) {
      // Ignore version-check failures; don't block app startup.
    }
    return true;
  }

  void _showMandatoryUpdateDialog(String link) {
    Get.dialog(
      PopScope(
        canPop: false,
        child: AlertDialog(
          title: Text('auto_key_688'.tr),
          content: Text(
            'auto_key_689'.tr,
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (link.isEmpty) return;
                final uri = Uri.tryParse(link);
                if (uri != null && await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              child: Text('auto_key_690'.tr),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _loadBasics() async {
    try {
      final res = await repository.getBasics();
      final data = ApiResult.data(res);
      if (data is Map) {
        final countries = data['countries'];
        if (countries is List && countries.isNotEmpty) {
          storageHelper.saveCountries(countries);
          if (storageHelper.countryId.isEmpty) {
            final first = countries.first;
            if (first is Map) {
              final id = first['id']?.toString() ?? '';
              if (id.isNotEmpty) storageHelper.saveCountryId(id);
            }
          }
        }
      }
    } catch (_) {
      // Non-blocking: app can continue with previously cached data.
    }
  }

  Future<void> _syncFcmQuietly() async {
    final token = storageHelper.fcmToken;
    if (token.isEmpty) return;
    try {
      await repository.updateFcm(data: {'fcm': token});
    } catch (_) {}
  }
}
