import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

import '../../../configs/api_response.dart';
import '../../../data/models/Home/notification_model.dart';
import 'notification_controller.dart';

class NotificationScreen extends GetView<NotificationnController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surfaceContainerHighest,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        title: Text(
          'الإشعارات',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: cs.primary,
          ),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Iconsax.arrow_right_1, color: cs.primary),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Iconsax.search_normal_1, color: cs.onSurface),
          ),
          IconButton(
            tooltip: 'حذف الكل',
            onPressed: () => _confirmDeleteAll(context),
            icon: Icon(Iconsax.trash, color: cs.error),
          ),
        ],
      ),
      body: Obx(() => _buildBody(theme)),
    );
  }

  void _confirmDeleteAll(BuildContext context) {
    Get.defaultDialog(
      title: 'حذف الكل',
      middleText: 'هل أنت متأكد من حذف جميع الإشعارات؟',
      textConfirm: 'حذف',
      textCancel: 'إلغاء',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        controller.deleteAllNotifications();
      },
    );
  }

  Widget _buildBody(ThemeData theme) {
    final cs = theme.colorScheme;

    // ── Full‑page loading ──
    if (controller.pageStatus.value == Status.loading &&
        controller.filteredNotifications.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // ── Full‑page error ──
    if (controller.pageStatus.value == Status.error &&
        controller.filteredNotifications.isEmpty) {
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
              onPressed: controller.loadInitialNotifications,
              icon: const Icon(Iconsax.refresh),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.refreshNotifications,
      color: cs.primary,
      child: CustomScrollView(
        controller: controller.pagination.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // ── Tab bar ──
          SliverToBoxAdapter(child: _buildTabBar(theme)),
          SliverToBoxAdapter(child: SizedBox(height: 5.h)),

          // ── Filter chips ──
          SliverToBoxAdapter(child: _buildFilterChips(theme)),
          SliverToBoxAdapter(child: SizedBox(height: 5.h)),

          // ── Notification list ──
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            sliver: SliverList.separated(
              itemCount: controller.filteredNotifications.length,
              separatorBuilder: (_, __) => SizedBox(height: 10.h),
              itemBuilder: (context, index) {
                final notif = controller.filteredNotifications[index];
                return Dismissible(
                  key: ValueKey('notification_${notif.id}'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    decoration: BoxDecoration(
                      color: cs.error,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: const Icon(Iconsax.trash, color: Colors.white),
                  ),
                  onDismissed: (_) => controller.deleteOneNotification(notif.id),
                  child: GestureDetector(
                    onLongPress: () => controller.deleteOneNotification(notif.id),
                    child: _NotificationCard(notification: notif),
                  ),
                );
              },
            ),
          ),

          // ── Load‑more indicator ──
          if (controller.pagination.isLoadingMore.value)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),

          // ── Show older notifications button ──
          if (controller.pagination.hasMore.value &&
              !controller.pagination.isLoadingMore.value)
            SliverToBoxAdapter(
              child: Align(
                alignment: Alignment.center,
                child: TextButton.icon(
                  onPressed: () => controller.pagination.loadMore(),
                  label: Text(
                    'عرض الإشعارات القديمة',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: cs.primary,
                      fontSize: 12.sp,
                    ),
                  ),
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: cs.primary,
                  ),
                ),
              ),
            ),

          // ── Bottom safe area ──
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }

  Widget _buildTabBar(ThemeData theme) {
    final cs = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          _TabChip(
            label: 'اليوم',
            isSelected: controller.selectedTab.value == 0,
            onTap: () => controller.selectTab(0),
          ),
          SizedBox(width: 4.w),
          _TabChip(
            label: 'الكل',
            isSelected: controller.selectedTab.value == 1,
            onTap: () => controller.selectTab(1),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(ThemeData theme) {
    final cs = theme.colorScheme;

    return SizedBox(
      height: 36.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: controller.filters.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final filter = controller.filters[index];
          return Obx(() {
            final isSelected = controller.selectedFilter.value == filter;
            return GestureDetector(
              onTap: () => controller.toggleFilter(filter),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected ? cs.primary : cs.surface,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isSelected
                        ? cs.primary
                        : cs.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? cs.onPrimary : cs.onSurface,
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────
//  _TabChip
// ────────────────────────────────────────────────────────────────
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
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? cs.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8.w,
            children: [
              Icon(
                isSelected ? Iconsax.calendar_1 : Iconsax.calendar,
                color: cs.primary,
                size: 16.r,
              ),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected
                      ? cs.onSurface
                      : cs.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────
//  _NotificationCard
// ────────────────────────────────────────────────────────────────
class _NotificationCard extends StatelessWidget {
  final NotificationItem notification;

  const _NotificationCard({required this.notification});

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon / image container
          Container(
            width: 60.w,
            height: 60.h,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12.r),
            ),
            clipBehavior: Clip.antiAlias,
            child: notification.image != null
                ? Image.network(
                    notification.image!,
                    width: 36.w,
                    height: 36.h,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Icon(
                      Iconsax.notification,
                      color: cs.primary,
                      size: 24.r,
                    ),
                  )
                : Icon(Iconsax.notification, color: cs.primary, size: 24.r),
          ),
          SizedBox(width: 12.w),

          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  notification.message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.55),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 8.w),

          // Time
          Text(
            _formatTime(notification.createdAt),
            style: theme.textTheme.labelSmall?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }

  /// Extracts a short time string (e.g. "10:30 ص") from the API date format.
  String _formatTime(String rawDate) {
    final dt = NotificationnController.tryParseApiDate(rawDate);
    if (dt == null) return '';
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final min = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'م' : 'ص';
    return '$hour:$min $period';
  }
}
