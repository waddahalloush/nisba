import 'package:flutter/material.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/data/models/home_category_model.dart';

/// شريط تصنيفات أفقي قابل لإعادة الاستخدام
class HomeCategories extends StatelessWidget {
  final List<HomeCategoryModel> categories;

  const HomeCategories({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 105.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          itemCount: categories.length,
          itemBuilder: (context, index) => _buildItem(theme, categories[index]),
        ),
      ),
    );
  }

  Widget _buildItem(ThemeData theme, HomeCategoryModel item) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
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
                image: DecorationImage(
                  image: AssetImage(item.catIcon),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              item.catName,
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
      ),
    );
  }
}
