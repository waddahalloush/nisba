import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

/// معلومات المطعم (اللوقو + الاسم + العنوان)
class RestaurantInfo extends StatelessWidget {
  final String name;
  final String address;
  final String logoUrl;

  const RestaurantInfo({
    super.key,
    required this.name,
    required this.address,
    required this.logoUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
      children: [
        // لوقو المطعم
        Container(
          width: 40.r,
          height: 40.r,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(7.r),
            child: CachedNetworkImage(
              imageUrl: logoUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) => Icon(
                Icons.storefront,
                color: cs.onSurface.withValues(alpha: 0.3),
                size: 22.sp,
              ),
              errorWidget: (_, __, ___) => Icon(
                Icons.storefront,
                color: cs.onSurface.withValues(alpha: 0.3),
                size: 22.sp,
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        // اسم وعنوان المطعم
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 12.sp,
                    color: cs.onSurface.withValues(alpha: 0.5),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      address,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.55),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
