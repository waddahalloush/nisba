import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/utils/locale_extensions.dart';

import 'package:nisba_app/src/services/locale_service.dart';

import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

import '../../../../../generated/assets.gen.dart';
import 'report_controller.dart';

class ReportScreen extends GetView<ReportController> {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Directionality(
      textDirection: Get.find<LocaleService>().textDirection,
      child: Scaffold(
        backgroundColor: cs.surfaceContainerHighest,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(backIconData(context), color: cs.primary),
          ),
          title: Text(
            'reports'.tr,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.primary,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Tab bar ──
              _buildTabBar(theme),

              SizedBox(height: 16.h),

              // ── Total amount card ──
              _buildTotalCard(theme),

              SizedBox(height: 14.h),

              // ── Chart ──
              _buildChartCard(theme),

              SizedBox(height: 14.h),

              // ── Metric cards ──
              _buildMetricGrid(theme),

              SizedBox(height: 16.h),

              // ── Month details ──
              _buildMonthDetails(theme),

              SizedBox(height: 12.h),

              // ── Footer ──
              _buildFooter(theme),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar(ThemeData theme) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _TabChip(
            label: 'auto_key_661'.tr,
            isSelected: controller.selectedTab.value == 0,
            onTap: () => controller.selectTab(0),
          ),
          SizedBox(width: 6.w),
          _TabChip(
            label: 'auto_key_662'.tr,
            isSelected: controller.selectedTab.value == 1,
            onTap: () => controller.selectTab(1),
          ),
          SizedBox(width: 6.w),
          _TabChip(
            label: 'auto_key_663'.tr,
            isSelected: controller.selectedTab.value == 2,
            onTap: () => controller.selectTab(2),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCard(ThemeData theme) {
    final cs = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cs.primary, cs.primary.withValues(alpha: 0.8)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(20.r),
        image: DecorationImage(
          image: Assets.images.reportBg.provider(),
          fit: BoxFit.fill,
        ),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'auto_key_664'.tr,
            style: TextStyle(
              fontSize: 13.sp,
              color: cs.onPrimary.withValues(alpha: 0.85),
            ),
          ),
          SizedBox(height: 4.h),
          Obx(
            () => Text(
              'auto_key_665'.tr,
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: cs.onPrimary,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Obx(
            () => Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'auto_key_666'.tr,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: cs.onPrimary.withValues(alpha: 0.8),
                  ),
                ),
                Icon(
                  Icons.arrow_downward,
                  size: 12.sp,
                  color: cs.onPrimary.withValues(alpha: 0.8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard(ThemeData theme) {
    final cs = theme.colorScheme;
    const chartColor = Color(0xFFF5A623);

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row with title + period dropdown ──
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'auto_key_667'.tr,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'auto_key_668'.tr,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
              Obx(
                () => Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.r),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: controller.chartPeriod.value,
                      isDense: true,
                      icon: Icon(
                        Iconsax.arrow_down_1,
                        size: 14.sp,
                        color: Colors.grey.shade400,
                      ),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade400,
                      ),
                      dropdownColor: cs.surface,
                      borderRadius: BorderRadius.circular(10.r),
                      items: [
                        DropdownMenuItem(value: 'auto_key_669'.tr, child: Text('auto_key_669'.tr)),
                        DropdownMenuItem(
                          value: 'auto_key_658'.tr,
                          child: Text('auto_key_658'.tr),
                        ),
                        DropdownMenuItem(
                          value: 'auto_key_670'.tr,
                          child: Text('auto_key_670'.tr),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) controller.chartPeriod.value = val;
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // ── Line chart ──
          Obx(() {
            final spots = controller.chartSpots.toList();
            if (spots.isEmpty) {
              return SizedBox(
                height: 180.h,
                child: Center(
                  child: Text(
                    'auto_key_671'.tr,
                    style: TextStyle(
                      color: cs.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              );
            }
            final maxY = spots
                .map((s) => s.y)
                .fold<double>(0, (a, b) => a > b ? a : b);
            final chartMaxY = maxY <= 0 ? 100.0 : (maxY * 1.2);
            return SizedBox(
              height: 180.h,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: chartMaxY / 4,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: cs.outlineVariant.withValues(alpha: 0.4),
                      strokeWidth: 1,
                      dashArray: [4, 4],
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        getTitlesWidget: (value, meta) => Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            fontSize: 9.sp,
                            color: cs.onSurface.withValues(alpha: 0.4),
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 20,
                        interval: (spots.length / 6).clamp(1, 10).toDouble(),
                        getTitlesWidget: (value, meta) => Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            fontSize: 9.sp,
                            color: cs.onSurface.withValues(alpha: 0.4),
                          ),
                        ),
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: (spots.length - 1).clamp(1, 100).toDouble(),
                  minY: 0,
                  maxY: chartMaxY,
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (_) => chartColor,
                      getTooltipItems: (touched) => touched.map((spot) {
                        return LineTooltipItem(
                          spot.y.toInt().toString(),
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: chartColor,
                      barWidth: 2.5,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) =>
                            FlDotCirclePainter(
                          radius: 3,
                          color: chartColor,
                          strokeWidth: 0,
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            chartColor.withValues(alpha: 0.15),
                            chartColor.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMetricGrid(ThemeData theme) {
    final cs = theme.colorScheme;

    final metrics = [
      _MetricData(
        icon: Iconsax.discount_shape,
        label: 'auto_key_672'.tr,
        value: controller.discountsValue,
        change: controller.discountsChange,
        color: cs.primary,
      ),
      _MetricData(
        icon: Iconsax.shopping_bag,
        label: 'auto_key_673'.tr,
        value: controller.savingsValue,
        change: controller.savingsChange,
        color: cs.primary,
      ),
      _MetricData(
        icon: Iconsax.medal_star,
        label: 'auto_key_674'.tr,
        value: controller.earnedPoints,
        change: controller.pointsChange,
        color: cs.primary,
        isInt: true,
      ),
      _MetricData(
        icon: Iconsax.shopping_cart,
        label: 'auto_key_675'.tr,
        value: controller.completedOrders,
        change: controller.ordersChange,
        color: cs.primary,
        isInt: true,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10.h,
        crossAxisSpacing: 10.w,
        childAspectRatio: 1.7,
      ),
      itemCount: metrics.length,
      itemBuilder: (context, index) {
        final m = metrics[index];
        return _MetricCard(metric: m);
      },
    );
  }

  Widget _buildMonthDetails(ThemeData theme) {
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'auto_key_676'.tr,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: cs.onSurface,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: cs.shadow.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Obx(() {
            final details = controller.monthDetails.toList();
            if (details.isEmpty) {
              return Padding(
                padding: EdgeInsets.all(16.r),
                child: Text(
                  'auto_key_677'.tr,
                  style: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.45),
                  ),
                ),
              );
            }
            return Column(
            children: List.generate(details.length, (i) {
              final detail = details[i];
              final isLast = i == details.length - 1;

              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 12.h,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36.w,
                          height: 36.h,
                          decoration: BoxDecoration(
                            color: cs.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Icon(
                            Iconsax.calendar_1,
                            color: cs.primary,
                            size: 18.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            detail.month,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: cs.onSurface,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${detail.amount.toStringAsFixed(2)} \$',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: cs.primary,
                              ),
                            ),
                            Text(
                              'auto_key_678'.tr,
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: cs.onSurface.withValues(alpha: 0.45),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    Divider(
                      height: 1,
                      indent: 60.w,
                      color: cs.outlineVariant.withValues(alpha: 0.4),
                    ),
                ],
              );
            }),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildFooter(ThemeData theme) {
    final cs = theme.colorScheme;

    return Obx(
      () => Text(
        'auto_key_679'.tr,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 10.sp,
          color: cs.onSurface.withValues(alpha: 0.35),
        ),
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          border: BoxBorder.fromLTRB(
            bottom: BorderSide(color: isSelected ? cs.primary : cs.surface),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? cs.primary
                : cs.onSurface.withValues(alpha: 0.55),
          ),
        ),
      ),
    );
  }
}

class _MetricData {
  final IconData icon;
  final String label;
  final Rx<num> value;
  final RxDouble change;
  final Color color;
  final bool isInt;

  _MetricData({
    required this.icon,
    required this.label,
    required this.value,
    required this.change,
    required this.color,
    this.isInt = false,
  });
}

class _MetricCard extends StatelessWidget {
  final _MetricData metric;

  const _MetricCard({required this.metric});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            metric.label,
            style: TextStyle(
              fontSize: 11.sp,
              color: cs.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => Text(
                  metric.isInt
                      ? metric.value.value.toInt().toString()
                      : 'auto_key_680'.tr,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                ),
              ),
              Container(
                width: 32.w,
                height: 32.h,
                decoration: BoxDecoration(
                  color: metric.color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(metric.icon, color: metric.color, size: 16.sp),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Obx(
                () => Text(
                  'auto_key_681'.tr,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: cs.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              ),
              Icon(Icons.arrow_downward, size: 12.sp, color: cs.primary),
            ],
          ),
        ],
      ),
    );
  }
}
