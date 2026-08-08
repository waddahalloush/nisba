import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nisba_app/src/data/repository.dart';
import 'package:nisba_app/src/utils/api_result.dart';
import 'package:nisba_app/src/utils/app_snackbar.dart';
import 'package:nisba_app/src/utils/dio_error_util.dart';

class MonthDetail {
  final String month;
  final double amount;
  final int orders;

  const MonthDetail({
    required this.month,
    required this.amount,
    required this.orders,
  });
}

class ReportController extends GetxController {
  final selectedTab = 0.obs; // 0=monthly, 1=quarterly, 2=yearly
  final totalAmount = 0.00.obs;
  final totalChange = 0.00.obs;
  final savingsValue = 0.00.obs;
  final savingsChange = 0.00.obs;
  final discountsValue = 0.00.obs;
  final discountsChange = 0.00.obs;
  final completedOrders = 0.obs;
  final ordersChange = 0.00.obs;
  final earnedPoints = 0.obs;
  final pointsChange = 0.00.obs;
  final lastUpdate = ''.obs;
  final isLoading = false.obs;

  final chartPeriod = 'auto_key_658'.tr.obs;
  final chartSpots = <FlSpot>[].obs;
  final monthDetails = <MonthDetail>[].obs;

  final Repository repository = Get.find();
  final InternetConnectionChecker connectionChecker = Get.find();

  static const _periods = ['monthly', 'quarterly', 'yearly'];

  @override
  void onInit() {
    super.onInit();
    lastUpdate.value = _nowLabel();
    fetchReports();
  }

  void selectTab(int index) {
    selectedTab.value = index;
    chartPeriod.value = switch (index) {
      1 => 'auto_key_659'.tr,
      2 => 'auto_key_660'.tr,
      _ => 'auto_key_658'.tr,
    };
    fetchReports();
  }

  Future<void> fetchReports() async {
    if (!await connectionChecker.hasConnection) {
      AppSnackbar.showError(message: 'check_connection'.tr);
      return;
    }
    isLoading.value = true;
    try {
      final period = _periods[selectedTab.value.clamp(0, 2)];
      final res = await repository.getReports(query: {'period': period});
      final data = ApiResult.ensureSuccess(res);
      _applyData(data);
      lastUpdate.value = _nowLabel();
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
    } on DioException catch (e) {
      log(e.toString());
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    } catch (e) {
      AppSnackbar.showError(message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void _applyData(dynamic data) {
    if (data is! Map) return;
    final map = Map<String, dynamic>.from(data);
    final summary = map['summary'];
    if (summary is Map) {
      totalAmount.value =
          _toDouble(summary['total_amount'] ?? summary['total']);
      savingsValue.value = _toDouble(summary['total_savings']);
      discountsValue.value = _toDouble(summary['total_discounts']);
      earnedPoints.value = _toDouble(summary['earned_points']).toInt();
      completedOrders.value =
          int.tryParse('${summary['completed_orders'] ?? 0}') ?? 0;
    }

    final chart = map['chart'];
    final spots = <FlSpot>[];
    final details = <MonthDetail>[];
    if (chart is List) {
      for (var i = 0; i < chart.length; i++) {
        final item = chart[i];
        if (item is Map) {
          final y = _toDouble(
            item['value'] ?? item['y'] ?? item['amount'] ?? item['total'],
          );
          spots.add(FlSpot(i.toDouble(), y));
          final label =
              item['label']?.toString() ?? item['month']?.toString() ?? '${i + 1}';
          details.add(
            MonthDetail(
              month: label,
              amount: y,
              orders: int.tryParse('${item['orders'] ?? 0}') ?? 0,
            ),
          );
        } else if (item is num) {
          spots.add(FlSpot(i.toDouble(), item.toDouble()));
        }
      }
    }
    chartSpots.assignAll(spots);
    monthDetails.assignAll(
      selectedTab.value == 2
          ? details
          : details.where((d) => d.amount > 0).take(8).toList(),
    );
  }

  double _toDouble(dynamic v) => double.tryParse(v?.toString() ?? '') ?? 0;

  String _nowLabel() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final period = now.hour >= 12 ? 'auto_key_415'.tr : 'auto_key_416'.tr;
    return '$hour:${now.minute.toString().padLeft(2, '0')} $period';
  }
}
