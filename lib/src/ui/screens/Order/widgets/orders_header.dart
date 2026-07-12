import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/routes/routes_names.dart';

/// هيدر ثابت أعلى شاشة الطلبات
class OrdersHeader extends StatelessWidget {
  const OrdersHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 30.h,
        bottom: 10.h,
        left: 20.w,
        right: 20.w,
      ),
      decoration: BoxDecoration(
        color: cs.primary,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(25.r),
          bottomLeft: Radius.circular(25.r),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // صورة المستخدم والنصوص الترحيبية
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: cs.onPrimary.withValues(alpha: 0.8),
                    width: 1.5,
                  ),
                ),
                child: CircleAvatar(
                  radius: 24.r,
                  backgroundColor: cs.onPrimary.withValues(alpha: 0.15),
                  backgroundImage: const CachedNetworkImageProvider(
                    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=150&q=80',
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'مرحباً محمد عبيد',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: cs.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'أهلاً بك مجدداً 👋🏼',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onPrimary.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          // أيقونة السلة مع Badge
          _buildIconBadge(
            context,
            icon: Iconsax.shopping_cart,
            badgeCount: 2,
            onTap: () {},
          ),
          SizedBox(width: 12.w),
          // أيقونة الإشعارات مع Badge
          _buildIconBadge(
            context,
            icon: Iconsax.notification,
            badgeCount: 1,
            onTap: () {
              Get.toNamed(AppRoutesNames.notification);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIconBadge(
    BuildContext context, {
    required IconData icon,
    required int badgeCount,
    required VoidCallback onTap,
  }) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundColor: cs.onPrimary,
            child: Icon(icon, color: cs.primary, size: 20.sp),
          ),
          if (badgeCount > 0)
            Positioned(
              top: -2.h,
              right: -2.w,
              child: Container(
                padding: EdgeInsets.all(3.r),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: BoxConstraints(minWidth: 16.w, minHeight: 16.h),
                child: Center(
                  child: Text(
                    '$badgeCount',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
