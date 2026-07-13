import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/routes/routes_names.dart';

/// كارد المحفظة + الطلبات السابقة
class WalletOrdersCard extends StatelessWidget {
  final int walletPoints;

  const WalletOrdersCard({super.key, required this.walletPoints});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // العنوان
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'الطلبات السابقة',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 10.sp,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'عرض الكل',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: cs.primary,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 12.sp,
                    color: cs.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),

        // صندوق الطلبات السابقة
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.r, vertical: 4.h),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 42.r,
                height: 42.r,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Icon(Iconsax.bag_24, color: cs.primary, size: 22.sp),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'المحفوظة',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '0 طلب',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),

        // صندوق المحفظة البرتقالي
        GestureDetector(
          onTap: () {
            Get.toNamed(AppRoutesNames.wallet);
          },
          child: Container(
            padding: EdgeInsets.only(
              left: 8.w,
              right: 8.w,
              bottom: 8.w,
              top: 0.w,
            ),
            decoration: BoxDecoration(
              color: cs.primary,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                // نقاط المحفظة
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutesNames.points);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$walletPoints',
                        style: TextStyle(
                          fontSize: 36.sp,
                          fontWeight: FontWeight.bold,
                          color: cs.onPrimary,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child: Text(
                          'نقطة',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: cs.onPrimary.withValues(alpha: 0.85),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 14.h),
                // أزرار شحن وإهداء
                Row(
                  children: [
                    Expanded(
                      child: _buildCapsuleButton(
                        context,
                        label: 'شحن المحفظة',
                        icon: Iconsax.wallet,
                        onTap: () {
                          Get.toNamed(AppRoutesNames.rechargeWallet);
                        },
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _buildCapsuleButton(
                        context,
                        label: 'إهداء رصيد',
                        icon: Icons.person,
                        onTap: () {
                          Get.toNamed(AppRoutesNames.giftCredit);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCapsuleButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: cs.onPrimary,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16.sp, color: cs.primary),
            SizedBox(width: 6.w),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
