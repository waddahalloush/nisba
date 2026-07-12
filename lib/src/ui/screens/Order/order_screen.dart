import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/ui/screens/Order/widgets/order_card.dart';
import 'package:nisba_app/src/ui/screens/Order/widgets/orders_header.dart';
import 'package:nisba_app/src/ui/screens/Order/widgets/orders_tab_bar.dart';

import 'controller/order_controller.dart';

class OrderScreen extends GetView<OrderController> {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surfaceContainerHighest,
      body: Column(
        children: [
          // 1. Header ثابت (لا يتحرك عند التمرير)
          const OrdersHeader(),

          // 2. عنوان الصفحة + Tab Bar (ثابت أيضاً)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                Text('طلباتك', style: theme.textTheme.headlineSmall),
                SizedBox(height: 12.h),
                OrdersTabBar(
                  selectedTab: controller.selectedTab,
                  onTabChanged: controller.changeTab,
                ),
                SizedBox(height: 12.h),
              ],
            ),
          ),

          // 3. قائمة الطلبات القابلة للتمرير
          Expanded(
            child: Obx(() {
              final orders = controller.selectedTab.value == 0
                  ? controller.activeOrders
                  : controller.pastOrders;

              if (orders.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.r),
                    child: Text(
                      'لا توجد طلبات لعرضها حالياً',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.only(top: 4.h, bottom: 24.h),
                itemCount: orders.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (_, index) {
                  final order = orders[index];
                  return Obx(
                    () => OrderCard(
                      order: order,
                      isExpanded: controller.isOrderExpanded(order.orderId),
                      onToggleExpand: () =>
                          controller.toggleOrderExpand(order.orderId),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
