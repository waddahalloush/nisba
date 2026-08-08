import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/generated/assets.gen.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/data/local/get_storage_helper.dart';
import 'package:nisba_app/src/routes/routes_names.dart';

/// هيدر ثابت أعلى شاشة الطلبات
class OrdersHeader extends StatelessWidget {
  const OrdersHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final storage = Get.find<GetStorageHelper>();
    final user = storage.getUser;
    final userName = user?.name ?? 'auto_key_276'.tr;
    final userImage = user?.image;

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
              // البروفايل
              GestureDetector(
                onTap: () {
                  if (!storage.isLoggedIn()) {
                    Get.toNamed(AppRoutesNames.login);
                    return;
                  }
                  Get.toNamed(AppRoutesNames.userAccount);
                },
                child: Container(
                  width: 36.w,
                  height: 36.h,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18.r),
                    child: userImage != null
                        ? CachedNetworkImage(
                            imageUrl: userImage,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) =>
                                Assets.images.appIcon.image(fit: BoxFit.cover),
                          )
                        : Assets.images.appIcon.image(fit: BoxFit.cover),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'auto_key_460'.tr,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: cs.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'auto_key_461'.tr,
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
            onTap: () {
              if (!storage.isLoggedIn()) {
                Get.toNamed(AppRoutesNames.login);
                return;
              }
              Get.toNamed(AppRoutesNames.cart);
            },
          ),
          SizedBox(width: 12.w),
          // أيقونة الإشعارات مع Badge
          _buildIconBadge(
            context,
            icon: Iconsax.notification,
            badgeCount: 1,
            onTap: () {
              if (!storage.isLoggedIn()) {
                Get.toNamed(AppRoutesNames.login);
                return;
              }
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
