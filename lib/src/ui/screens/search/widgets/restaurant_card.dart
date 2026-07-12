import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/ui/screens/search/search_controller.dart';

/// كارد عرض المطعم/الشريك في وضع القائمة
class RestaurantCard extends StatelessWidget {
  final PartnerModel partner;
  final VoidCallback? onFavoriteToggle;

  const RestaurantCard({
    super.key,
    required this.partner,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.06),
            blurRadius: 10.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Row(
        children: [
          // صورة المطعم (يمين)
          ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: CachedNetworkImage(
              imageUrl: partner.imageUrl,
              width: 140.w,
              height: 90.h,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                width: 100.w,
                height: 120.h,
                color: cs.surfaceContainerHighest,
                child: Icon(
                  Icons.restaurant,
                  color: cs.primary.withValues(alpha: 0.3),
                  size: 32.sp,
                ),
              ),
              errorWidget: (_, __, ___) => Container(
                width: 100.w,
                height: 120.h,
                color: cs.surfaceContainerHighest,
                child: Icon(
                  Icons.restaurant,
                  color: cs.primary.withValues(alpha: 0.3),
                  size: 32.sp,
                ),
              ),
            ),
          ),
          // محتوى الكارد (يسار)
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // صف: أيقونة القلب + اسم المطعم
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          partner.name,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: onFavoriteToggle,
                        child: Icon(
                          partner.isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: partner.isFavorite
                              ? AppColorsHelper.favoriteRed
                              : cs.onSurface.withValues(alpha: 0.3),
                          size: 20.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  // التقييم + الموقع
                  Row(
                    children: [
                      Icon(Iconsax.location, size: 10.sp, color: cs.onSurface),
                      SizedBox(width: 2.w),
                      Text(
                        partner.location,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontSize: 8.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.star_rounded,
                        size: 14.sp,
                        color: AppColorsHelper.starColor,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        partner.rating.toStringAsFixed(1),
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: cs.onSurface,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  // شريحة العرض الترويجي
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColorsHelper.promoBg,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.discount_rounded,
                          size: 12.sp,
                          color: AppColorsHelper.promoText,
                        ),
                        SizedBox(width: 4.w),
                        Flexible(
                          child: Text(
                            partner.promotion,
                            style: TextStyle(
                              fontSize: 8.sp,
                              color: AppColorsHelper.promoText,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ألوان مساعدة داخلية للكارد - لا تستخدم ألوان الثيم المباشرة
class AppColorsHelper {
  AppColorsHelper._();

  static const Color starColor = Color(0xFFFFC107);
  static const Color favoriteRed = Color(0xFFEB5757);
  static const Color promoBg = Color(0xFFFFEAEA);
  static const Color promoText = Color(0xFFC62828);
}
