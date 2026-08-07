import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/api_response.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

import 'order_controller.dart';
import 'widgets/order_card.dart';
import 'widgets/orders_header.dart';
import 'widgets/orders_tab_bar.dart';

class OrderScreen extends GetView<OrderController> {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surfaceContainerHighest,
      body: Obx(() {
        // ── Full‑page loading ──
        if (controller.pageStatus.value == Status.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        // ── Full‑page error ──
        if (controller.pageStatus.value == Status.error) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Iconsax.warning_2, size: 48.r, color: cs.error),
                SizedBox(height: 12.h),
                Text(
                  controller.errorMessage.value,
                  style: theme.textTheme.bodyLarge?.copyWith(color: cs.error),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                ElevatedButton.icon(
                  onPressed: () => controller.onInit(),
                  icon: const Icon(Iconsax.refresh),
                  label: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }

        // ── Content ──
        return _buildContent(context, theme);
      }),
    );
  }

  Widget _buildContent(BuildContext context, ThemeData theme) {
    final cs = theme.colorScheme;
    final isActive = controller.selectedTab.value == 0;
    final pagination = isActive
        ? controller.activePagination
        : controller.pastPagination;
    final orders = isActive ? controller.activeOrders : controller.pastOrders;

    return Column(
      children: [
        // 1. Header
        const OrdersHeader(),

        // 2. Title + Tab Bar
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

        // 3. Order list
        Expanded(
          child: RefreshIndicator(
            onRefresh: controller.refreshCurrentTab,
            color: cs.primary,
            child: CustomScrollView(
              controller: pagination.scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                if (orders.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.r),
                        child: Text(
                          'لا توجد طلبات لعرضها حالياً',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: cs.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.only(top: 4.h, bottom: 24.h),
                    sliver: SliverList.builder(
                      itemCount: orders.length,
                      itemBuilder: (_, index) {
                        final order = orders[index];
                        return Obx(
                          () => OrderCard(
                            order: order,
                            isExpanded: controller.isOrderExpanded(
                              order.orderId,
                            ),
                            onToggleExpand: () =>
                                controller.toggleOrderExpand(order),
                            detail: controller.detailFor(order.apiId),
                            isLoadingDetail:
                                controller.isDetailLoading(order.apiId),
                            onCancel: () =>
                                _confirmCancel(context, order.apiId),
                            onRate: () => _showRateDialog(context, order.apiId),
                            onChat: () =>
                                controller.openOrderChat(order.apiId),
                            onPay: () =>
                                controller.payPendingOrder(order.apiId),
                            onRetryDetail: () =>
                                controller.retryOrderDetails(order.apiId),
                          ),
                        );
                      },
                    ),
                  ),

                // Load‑more indicator
                if (pagination.isLoadingMore.value)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _confirmCancel(BuildContext context, int apiId) {
    Get.dialog(
      AlertDialog(
        title: const Text('إلغاء الطلب'),
        content: const Text('هل أنت متأكد من إلغاء هذا الطلب؟'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('تراجع')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.cancelOrder(apiId);
            },
            child: const Text('إلغاء الطلب'),
          ),
        ],
      ),
    );
  }

  void _showRateDialog(BuildContext context, int apiId) {
    final rate = 5.0.obs;
    final commentCtrl = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('تقييم الطلب'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(
              () => Column(
                children: [
                  Text('${rate.value.toStringAsFixed(1)} / 5'),
                  Slider(
                    value: rate.value,
                    min: 0,
                    max: 5,
                    divisions: 10,
                    onChanged: (v) => rate.value = v,
                  ),
                ],
              ),
            ),
            TextField(
              controller: commentCtrl,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'تعليق (اختياري)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('تراجع')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.rateOrder(
                apiId,
                rate: rate.value,
                comment: commentCtrl.text,
              );
            },
            child: const Text('إرسال'),
          ),
        ],
      ),
    );
  }
}
