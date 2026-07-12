import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/ui/screens/search/search_controller.dart';

/// كارد مصغر للشريك القريب - يُستخدم داخل الـ DraggableScrollableSheet
class NearbyPartnerCard extends StatelessWidget {
  final PartnerModel partner;

  const NearbyPartnerCard({super.key, required this.partner});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      width: 130.w,
      margin: EdgeInsets.only(left: 10.w),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.06),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة الشريك
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(14.r),
              topRight: Radius.circular(14.r),
            ),
            child: CachedNetworkImage(
              imageUrl: partner.imageUrl,
              width: 130.w,
              height: 80.h,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                width: 130.w,
                height: 80.h,
                color: cs.surfaceContainerHighest,
                child: Icon(
                  Icons.storefront,
                  color: cs.primary.withValues(alpha: 0.3),
                ),
              ),
              errorWidget: (_, __, ___) => Container(
                width: 130.w,
                height: 80.h,
                color: cs.surfaceContainerHighest,
                child: Icon(
                  Icons.storefront,
                  color: cs.primary.withValues(alpha: 0.3),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // الاسم
                Text(
                  partner.name,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                // المسافة
                Text(
                  '${partner.distanceKm.toStringAsFixed(1)} كم',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.55),
                  ),
                ),
                SizedBox(height: 4.h),
                // شريحة نوع الشريك
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: cs.outlineVariant),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    partner.type.label,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: cs.onSurface.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
