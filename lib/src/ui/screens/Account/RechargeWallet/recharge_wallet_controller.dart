import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nisba_app/src/data/repository.dart';
import 'package:nisba_app/src/routes/routes_names.dart';
import 'package:nisba_app/src/utils/api_result.dart';
import 'package:nisba_app/src/utils/app_snackbar.dart';
import 'package:nisba_app/src/utils/dio_error_util.dart';
import 'package:nisba_app/src/utils/payment_flow_helper.dart';

class RechargeWalletController extends GetxController {
  Repository repository = Get.find();
  InternetConnectionChecker connectionChecker = Get.find();

  final amountController = TextEditingController();
  final selectedAmount = 0.0.obs;
  final isSubmitting = false.obs;

  final presetAmounts = <double>[500, 200, 100, 5000, 1000, 2000];
  final minAmount = 100.0;

  void selectAmount(double amount) {
    selectedAmount.value = amount;
    amountController.text = amount.toStringAsFixed(0);
  }

  void onAmountChanged(String value) {
    final parsed = double.tryParse(value);
    selectedAmount.value = parsed ?? 0;
  }

  Future<void> proceed() async {
    final amount = double.tryParse(amountController.text.trim());
    if (amount == null || amount < minAmount) {
      Get.snackbar('خطأ', 'الحد الأدنى للشحن هو ${minAmount.toInt()} ر.ق');
      return;
    }
    isSubmitting.value = true;
    try {
      if (!await connectionChecker.hasConnection) {
        AppSnackbar.showError(message: 'check_connection'.tr);
        return;
      }
      final res = await repository.chargeWallet(data: {
        'amount': amount,
      });
      final data = ApiResult.ensureSuccess(res);

      final gateway = await PaymentFlowHelper.openIfNeeded(
        data: data,
        purpose: PaymentWebViewPurpose.wallet,
      );
      if (gateway == PaymentGatewayResult.paid) {
        Get.offNamedUntil(AppRoutesNames.wallet, (route) => route.isFirst);
        return;
      }
      if (gateway == PaymentGatewayResult.dismissed) {
        AppSnackbar.showInfo(message: 'الشحن لم يكتمل بعد');
        return;
      }
      if (gateway == PaymentGatewayResult.unavailable) {
        AppSnackbar.showError(message: 'تعذر فتح صفحة الدفع');
        return;
      }

      AppSnackbar.showSuccess(
        message: ApiResult.message(res).isNotEmpty
            ? ApiResult.message(res)
            : 'تم شحن المحفظة بنجاح',
      );
    } on DioException catch (e) {
      log(e.toString());
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
    } catch (e) {
      AppSnackbar.showError(message: e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    amountController.dispose();
    super.onClose();
  }
}
