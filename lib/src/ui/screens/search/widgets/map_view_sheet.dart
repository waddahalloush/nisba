import 'package:flutter/material.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/ui/screens/search/search_controller.dart';
import 'package:nisba_app/src/ui/screens/search/widgets/nearby_partner_card.dart';

/// عرض الخريطة مع DraggableScrollableSheet للشركاء القريبين
class MapViewSheet extends StatelessWidget {
  final List<PartnerModel> nearbyPartners;

  const MapViewSheet({super.key, required this.nearbyPartners});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Stack(
      children: [
        // --- خلفية الخريطة (محاكاة) ---
        Container(
          color: const Color(0xFFE8ECF2),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.map_rounded,
                  size: 80.sp,
                  color: cs.primary.withValues(alpha: 0.25),
                ),
                SizedBox(height: 8.h),
                Text(
                  'عرض الخريطة',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.3),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'سيتم دمج Google Maps هنا',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.2),
                  ),
                ),
              ],
            ),
          ),
        ),

        // --- أزرار التحكم بالخريطة (يمين) ---
        Positioned(
          top: 12.h,
          right: 16.w,
          child: Column(
            children: [
              _buildMapControlBtn(context, Icons.my_location_rounded),
              SizedBox(height: 8.h),
              _buildMapControlBtn(context, Icons.navigation_rounded),
            ],
          ),
        ),

        // --- DraggableScrollableSheet ---
        DraggableScrollableSheet(
          initialChildSize: 0.11,
          minChildSize: 0.11,
          maxChildSize: 0.47,
          builder: (_, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: cs.shadow.withValues(alpha: 0.12),
                    blurRadius: 16.r,
                    offset: Offset(0, -4.h),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                physics: const ClampingScrollPhysics(),
                child: Column(
                  children: [
                    // --- مقبض السحب ---
                    Padding(
                      padding: EdgeInsets.only(top: 10.h, bottom: 4.h),
                      child: Container(
                        width: 36.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                          color: cs.onSurface.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                      ),
                    ),

                    // --- عنوان الـ Sheet + زر عرض الكل ---
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 9.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'عرض الكل',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: cs.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                          ),
                          Text(
                            'أقرب الشركاء إليك',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // --- قائمة أفقية للشركاء القريبين ---
                    SizedBox(
                      height: 170.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemCount: nearbyPartners.length,
                        itemBuilder: (_, i) =>
                            NearbyPartnerCard(partner: nearbyPartners[i]),
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMapControlBtn(BuildContext context, IconData icon) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 40.r,
      height: 40.r,
      decoration: BoxDecoration(
        color: cs.surface,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.15),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Icon(icon, size: 20.sp, color: cs.onSurface),
    );
  }
}
