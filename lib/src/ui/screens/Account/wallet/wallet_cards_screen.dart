import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

import 'wallet_controller.dart';

/// Lists the user's gift cards (`nisba_cards`) and saved payment cards
/// (`visas`) returned by `walletCards()`.
class WalletCardsScreen extends GetView<WalletController> {
  const WalletCardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: cs.surfaceContainerHighest,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Iconsax.arrow_right_1, color: cs.primary),
          ),
          title: Text(
            'بطاقاتي',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.primary,
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: controller.fetchCards,
          child: Obx(() {
            if (controller.isCardsLoading.value &&
                controller.nisbaCards.isEmpty &&
                controller.visas.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.nisbaCards.isEmpty && controller.visas.isEmpty) {
              return ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 40.h),
                children: [
                  Icon(Iconsax.card, size: 48.sp, color: cs.onSurface.withValues(alpha: 0.3)),
                  SizedBox(height: 12.h),
                  Center(
                    child: Text(
                      'لا توجد بطاقات حالياً',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ],
              );
            }

            return ListView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              children: [
                if (controller.nisbaCards.isNotEmpty) ...[
                  Text(
                    'بطاقات الهدايا',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  ...controller.nisbaCards.map(
                    (card) => _CardTile(
                      theme: theme,
                      icon: Iconsax.gift,
                      title: card.name,
                      subtitle: '${card.price.toStringAsFixed(2)} ر.ق',
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
                if (controller.visas.isNotEmpty) ...[
                  Text(
                    'بطاقات الدفع',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  ...controller.visas.map(
                    (visa) => _CardTile(
                      theme: theme,
                      icon: Iconsax.card,
                      title: visa.displayNumber,
                      subtitle: visa.isDefault
                          ? 'البطاقة الافتراضية'
                          : (visa.isUsable ? 'نشطة' : 'تحتاج إلى إعادة تفعيل'),
                      trailingColor: visa.isDefault ? cs.primary : null,
                    ),
                  ),
                ],
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _CardTile extends StatelessWidget {
  final ThemeData theme;
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? trailingColor;

  const _CardTile({
    required this.theme,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailingColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = theme.colorScheme;
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
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
        children: [
          Container(
            width: 44.w,
            height: 44.h,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: cs.primary, size: 22.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: trailingColor ?? cs.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          if (trailingColor != null)
            Icon(Iconsax.tick_circle, color: trailingColor, size: 18.sp),
        ],
      ),
    );
  }
}
