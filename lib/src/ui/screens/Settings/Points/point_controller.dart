import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nisba_app/src/configs/api_response.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/data/repository.dart';
import 'package:nisba_app/src/utils/api_result.dart';
import 'package:nisba_app/src/utils/app_snackbar.dart';
import 'package:nisba_app/src/utils/dio_error_util.dart';

class PointLogEntry {
  final String title;
  final String date;
  final String points;
  final bool isEarned;

  const PointLogEntry({
    required this.title,
    required this.date,
    required this.points,
    required this.isEarned,
  });
}

class PointController extends GetxController {
  final totalPoints = 120.obs;
  final totalEarned = 320.obs;
  final totalRedeemed = 200.obs;
  final expiryDate = 'auto_key_625'.tr.obs;

  final log = <PointLogEntry>[].obs;

  Repository repository = Get.find();
  InternetConnectionChecker connectionChecker = Get.find();

  final Rx<ApiResponse<dynamic>> pointsResponse =
      ApiResponse<dynamic>.init().obs;

  @override
  void onInit() {
    super.onInit();
    _seedMockLog();
    fetchPoints();
  }

  Future<void> fetchPoints() async {
    pointsResponse.value = ApiResponse<dynamic>.loading('');
    if (!await connectionChecker.hasConnection) {
      pointsResponse.value = ApiResponse<dynamic>.error('check_connection'.tr);
      return;
    }
    try {
      final res = await repository.getPoints();
      final data = ApiResult.ensureSuccess(res);
      pointsResponse.value = ApiResponse<dynamic>.completed(res);
      if (data is Map) {
        final user = data['user'];
        if (user is Map) {
          final pts = user['points'];
          if (pts != null) {
            totalPoints.value = (double.tryParse(pts.toString()) ?? 0).round();
          }
        }
        final list = data['points'] as List? ?? [];
        if (list.isNotEmpty) {
          log.assignAll(list.whereType<Map>().map(_mapEntry).toList());
          _recomputeTotals(list);
        }
      }
    } on DioException catch (error) {
      developer.log(
        error.response?.data?['message']?.toString() ?? error.toString(),
      );
      pointsResponse.value = ApiResponse<dynamic>.error(
        DioErrorUtil.handleError(error),
      );
      AppSnackbar.showError(message: pointsResponse.value.message);
    } on ApiException catch (e) {
      pointsResponse.value = ApiResponse<dynamic>.error(e.message);
      AppSnackbar.showError(message: e.message);
    } catch (e) {
      pointsResponse.value = ApiResponse<dynamic>.error(e.toString());
    }
  }

  PointLogEntry _mapEntry(Map raw) {
    final map = Map<String, dynamic>.from(raw);
    final direction = map['direction'];
    final type = map['type'];
    final dirValue = direction is Map
        ? direction['value']?.toString() ?? ''
        : direction?.toString() ?? '';
    final typeDesc = type is Map
        ? type['desc']?.toString() ?? 'points'.tr
        : type?.toString() ?? 'points'.tr;
    final isEarned = dirValue == 'deposit';
    final amount = map['amount']?.toString() ?? '0';
    return PointLogEntry(
      title: typeDesc,
      date: map['created_at']?.toString() ?? '',
      points: '${isEarned ? '+' : '-'}\$amount',
      isEarned: isEarned,
    );
  }

  void _recomputeTotals(List list) {
    int earned = 0;
    int redeemed = 0;
    for (final raw in list.whereType<Map>()) {
      final direction = raw['direction'];
      final dirValue = direction is Map
          ? direction['value']?.toString() ?? ''
          : direction?.toString() ?? '';
      final amt = (double.tryParse(raw['amount']?.toString() ?? '') ?? 0)
          .round();
      if (dirValue == 'deposit') {
        earned += amt;
      } else {
        redeemed += amt;
      }
    }
    totalEarned.value = earned;
    totalRedeemed.value = redeemed;
  }

  void _seedMockLog() {
    log.assignAll([
      PointLogEntry(
        title: 'auto_key_627'.tr,
        date: 'auto_key_628'.tr,
        points: 'auto_key_629'.tr,
        isEarned: true,
      ),
      PointLogEntry(
        title: 'auto_key_630'.tr,
        date: 'auto_key_631'.tr,
        points: 'auto_key_632'.tr,
        isEarned: false,
      ),
    ]);
  }

  void calculatePoints() {
    // Calculator UI remains local; balance comes from API.
  }

  Future<void> sendToFriend() async {
    final amountCtrl = TextEditingController();
    final recipientCtrl = TextEditingController();
    final isQr = true.obs;
    final formKey = GlobalKey<FormState>();

    final confirmed = await Get.bottomSheet<bool>(
      Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Theme.of(Get.context!).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: amountCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'auto_key_633'.tr,
                  labelText: 'auto_key_633'.tr,
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'auto_key_85'.tr;
                  if ((double.tryParse(v) ?? 0) <= 0) return 'auto_key_634'.tr;
                  return null;
                },
              ),
              SizedBox(height: 12.h),
              Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: RadioListTile<bool>(
                        title: Text('auto_key_636'.tr),
                        value: true,
                        groupValue: isQr.value,
                        onChanged: (v) => isQr.value = v!,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool>(
                        title: Text('auto_key_635'.tr),
                        value: false,
                        groupValue: isQr.value,
                        onChanged: (v) => isQr.value = v!,
                      ),
                    ),
                  ],
                ),
              ),
              TextFormField(
                controller: recipientCtrl,
                decoration: InputDecoration(
                  hintText: isQr.value ? 'auto_key_636'.tr : 'auto_key_635'.tr,
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'auto_key_85'.tr;
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Get.back(result: true);
                    }
                  },
                  child: Text('send'.tr),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final amount = double.tryParse(amountCtrl.text) ?? 0;
    final recipient = recipientCtrl.text.trim();
    final useQr = isQr.value;
    amountCtrl.dispose();
    recipientCtrl.dispose();

    if (confirmed != true || amount <= 0 || recipient.isEmpty) return;

    final body = <String, dynamic>{'amount': amount};
    if (useQr) {
      body['gift_user_qr'] = recipient;
    } else {
      body['gift_user_phone'] = recipient;
      body['gift_user_key'] = '+974';
    }

    try {
      final res = await repository.giftPoints(data: body);
      ApiResult.ensureSuccess(res);
      AppSnackbar.showSuccess(
        message:
            (res is Map ? res['message'] : null)?.toString() ??
            'auto_key_637'.tr,
      );
      await fetchPoints();
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
    } on DioException catch (e) {
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    }
  }

  Future<void> redeemToBalance() async {
    final amountCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: Text('auto_key_630'.tr),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: amountCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'auto_key_633'.tr,
              labelText: 'auto_key_633'.tr,
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'auto_key_85'.tr;
              if ((double.tryParse(v) ?? 0) <= 0) return 'auto_key_634'.tr;
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Get.back(result: true);
              }
            },
            child: Text('confirm'.tr),
          ),
        ],
      ),
    );

    final amount = double.tryParse(amountCtrl.text) ?? 0;
    amountCtrl.dispose();

    if (confirmed != true || amount <= 0) return;

    try {
      final res = await repository.convertPointsToWallet(
        data: {'amount': amount},
      );
      ApiResult.ensureSuccess(res);
      AppSnackbar.showSuccess(
        message:
            (res is Map ? res['message'] : null)?.toString() ??
            'auto_key_638'.tr,
      );
      await fetchPoints();
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
    } on DioException catch (e) {
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    }
  }
}
