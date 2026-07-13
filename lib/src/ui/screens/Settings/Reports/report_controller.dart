import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  final lastUpdate = '2:32 م'.obs;

  // 30-day chart data
  final chartSpots = <FlSpot>[
    const FlSpot(0, 3),
    const FlSpot(1, 5),
    const FlSpot(2, 4),
    const FlSpot(3, 8),
    const FlSpot(4, 6),
    const FlSpot(5, 10),
    const FlSpot(6, 7),
    const FlSpot(7, 9),
    const FlSpot(8, 12),
    const FlSpot(9, 8),
    const FlSpot(10, 11),
    const FlSpot(11, 14),
    const FlSpot(12, 10),
    const FlSpot(13, 15),
    const FlSpot(14, 13),
    const FlSpot(15, 18),
    const FlSpot(16, 16),
    const FlSpot(17, 20),
    const FlSpot(18, 17),
    const FlSpot(19, 22),
    const FlSpot(20, 19),
    const FlSpot(21, 24),
    const FlSpot(22, 21),
    const FlSpot(23, 26),
    const FlSpot(24, 23),
    const FlSpot(25, 28),
    const FlSpot(26, 25),
    const FlSpot(27, 30),
    const FlSpot(28, 27),
    const FlSpot(29, 32),
  ];

  final monthDetails = <MonthDetail>[
    const MonthDetail(month: 'يناير 2026', amount: 0.00, orders: 0),
    const MonthDetail(month: 'فبراير 2026', amount: 0.00, orders: 0),
  ];

  void selectTab(int index) => selectedTab.value = index;
}
