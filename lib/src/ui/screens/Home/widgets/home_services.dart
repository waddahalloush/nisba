import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/generated/assets.gen.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/routes/routes_names.dart';

/// قسم الخدمات الأفقي
class HomeServices extends StatelessWidget {
  const HomeServices({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان القسم
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
            child: Text(
              'الخدمات',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          // القائمة الأفقية للخدمات
          SizedBox(
            height: 130.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              children: [
                _buildCard(theme, 'الترفيه', Assets.images.service1.path),
                SizedBox(width: 4.w),
                _buildCard(theme, 'الهدايا', Assets.images.service2.path),
                SizedBox(width: 4.w),
                _buildCard(theme, 'السياحة', Assets.images.service3.path),
                SizedBox(width: 4.w),
                _buildCard(theme, 'الأسواق', Assets.images.service4.path),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(ThemeData theme, String title, String imageUrl) {
    return InkWell(
      onTap: () {
        Get.toNamed(AppRoutesNames.mall);
      },
      child: SizedBox(
        width: 90.w,
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.shadow.withValues(alpha: 0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: Image.asset(imageUrl, fit: BoxFit.cover),
                ),
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.87),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
