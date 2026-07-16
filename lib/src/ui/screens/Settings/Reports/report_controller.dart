import 'package:fl_chart/fl_chart.dart';
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

  final chartPeriod = '30 يوم'.obs;

  // 30-day chart data (values 0-1000 range)
  final chartSpots = <FlSpot>[
    const FlSpot(0, 300),
    const FlSpot(1, 420),
    const FlSpot(2, 350),
    const FlSpot(3, 550),
    const FlSpot(4, 480),
    const FlSpot(5, 620),
    const FlSpot(6, 510),
    const FlSpot(7, 680),
    const FlSpot(8, 590),
    const FlSpot(9, 720),
    const FlSpot(10, 640),
    const FlSpot(11, 780),
    const FlSpot(12, 700),
    const FlSpot(13, 830),
    const FlSpot(14, 750),
    const FlSpot(15, 880),
    const FlSpot(16, 810),
    const FlSpot(17, 910),
    const FlSpot(18, 850),
    const FlSpot(19, 950),
    const FlSpot(20, 890),
    const FlSpot(21, 980),
    const FlSpot(22, 920),
    const FlSpot(23, 1000),
    const FlSpot(24, 930),
    const FlSpot(25, 970),
    const FlSpot(26, 880),
    const FlSpot(27, 940),
    const FlSpot(28, 860),
    const FlSpot(29, 910),
  ];

  final monthDetails = <MonthDetail>[
    const MonthDetail(month: 'يناير 2026', amount: 0.00, orders: 0),
    const MonthDetail(month: 'فبراير 2026', amount: 0.00, orders: 0),
  ];

  void selectTab(int index) => selectedTab.value = index;
}
