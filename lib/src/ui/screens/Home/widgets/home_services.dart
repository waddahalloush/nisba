import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/generated/assets.gen.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/routes/routes_names.dart';

/// قسم الخدمات الأفقي ثنائي الأسطر (كل سطر يعرض خدمات مختلفة)
class HomeServices extends StatelessWidget {
  const HomeServices({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // خدمات الصف الأول (العلوي)
    final firstRowServices = [
      {'title': 'الترفيه', 'image': Assets.images.service1.path},
      {'title': 'الهدايا', 'image': Assets.images.service2.path},
      {'title': 'السياحة', 'image': Assets.images.service3.path},
      {'title': 'الأسواق', 'image': Assets.images.service4.path},
    ];

    // خدمات الصف الثاني (السفلي)
    final secondRowServices = [
      {'title': 'Kioks', 'image': Assets.images.service5.path},
      {'title': 'الفنادق', 'image': Assets.images.service6.path},
      {'title': 'المولات', 'image': Assets.images.service7.path},
      {'title': 'التجميل', 'image': Assets.images.service8.path},
    ];

    // نأخذ الطول الأكبر لضمان عرض كافة العناصر في حال عدم تساوي القائمتين مستقبلاً
    final itemCount = firstRowServices.length > secondRowServices.length
        ? firstRowServices.length
        : secondRowServices.length;

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

          // القائمة الأفقية للخدمات بصفين مختلفين ومربوطين بنفس التمرير
          SizedBox(
            height:
                270.h, // الارتفاع الكلي المناسب ليتسع للصفين بالتساوي مع الفاصل
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              itemCount: itemCount,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // كارت الصف الأول (العلوي)
                      if (index < firstRowServices.length)
                        _buildCard(
                          theme,
                          firstRowServices[index]['title']!,
                          firstRowServices[index]['image']!,
                        )
                      else
                        SizedBox(
                          width: 90.w,
                          height: 120.h,
                        ), // مساحة فارغة للمحافظة على الأبعاد

                      SizedBox(
                        height: 10.h,
                      ), // مسافة رأسية تفصل بين الصف العلوي والسفلي
                      // كارت الصف الثاني (السفلي)
                      if (index < secondRowServices.length)
                        _buildCard(
                          theme,
                          secondRowServices[index]['title']!,
                          secondRowServices[index]['image']!,
                        )
                      else
                        SizedBox(
                          width: 90.w,
                          height: 120.h,
                        ), // مساحة فارغة للمحافظة على الأبعاد
                    ],
                  ),
                );
              },
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
        height: 120.h, // الارتفاع الثابت لكل كارت لضمان اتساق المظهر
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
