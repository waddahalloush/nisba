import 'package:flutter/material.dart';
import 'package:nisba_app/generated/assets.gen.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

/// شريط التصنيفات الأفقي (مطاعم، بقالة، مقاهي، عروض)
class HomeCategories extends StatelessWidget {
  const HomeCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 105.h,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          children: [
            _buildItem(theme, 'مطاعم', Assets.images.catFood.path),
            _buildItem(theme, 'بقالة', Assets.images.catVigi.path),
            _buildItem(theme, 'مقاهي', Assets.images.catCafee.path),
            _buildItem(theme, 'العروض اليومية', Assets.images.catOffer.path),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(ThemeData theme, String title, String imageUrl) {
    return Container(
      width: 81.w,
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        children: [
          Container(
            height: 75.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(18.r),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(alpha: 0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
              image: DecorationImage(image: AssetImage(imageUrl)),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.87),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
