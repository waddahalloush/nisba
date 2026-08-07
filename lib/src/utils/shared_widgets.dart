import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

import '../../generated/assets.gen.dart';

class SharedWidgets {
  static void showAwesomeSuccessSnack({required String msg}) {
    Get.showSnackbar(
      GetSnackBar(
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
        backgroundColor: Colors.teal,
        duration: const Duration(seconds: 3),
        messageText: Text(
          msg,
          style: Get.textTheme.headlineMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  static void showAwesomeErrorSnack({required String msg}) {
    Get.showSnackbar(
      GetSnackBar(
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        messageText: Text(
          msg,
          style: Get.textTheme.headlineMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  static void showAwesomeWarningSnack({required String msg}) {
    Get.showSnackbar(
      GetSnackBar(
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.orange,
        messageText: Text(
          msg,
          style: Get.textTheme.headlineMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  static void showAwesomeNoWifiDialog({
    required String msg,
    required VoidCallback onRetry,
  }) {
    Get.defaultDialog(
      title: msg,
      titleStyle: Get.textTheme.bodySmall!.copyWith(
        fontWeight: FontWeight.w800,
      ),
      content: Assets.images.logo.image(height: 200),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
        onPressed: onRetry,
        child: Text(
          'retry'.tr,
          style: Get.textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  static Widget onLoading({Color? color}) {
    return Center(
      child: FittedBox(
        child: SpinKitThreeBounce(
          color: color ?? Theme.of(Get.context!).primaryColor,
          size: 30,
        ),
      ),
    );
  }

  static Widget emptyListView(
    BuildContext context, {
    required String text,
    required VoidCallback onRefresh,
  }) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Assets.images.logo.image(width: 250.w),
          Text(
            text,
            style: Get.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: ElevatedButton(
              onPressed: onRefresh,
              child: Text('confirm'.tr),
            ),
          ),
        ],
      ),
    );
  }
}
