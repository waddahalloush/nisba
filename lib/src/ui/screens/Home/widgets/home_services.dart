import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/generated/assets.gen.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/routes/routes_names.dart';

/// Data model representing a service item
class ServiceItem {
  final String imagePath;
  final String routeName;

  const ServiceItem({required this.imagePath, required this.routeName});
}

/// قسم الخدمات الأفقي ثنائي الأسطر (كل سطر يعرض خدمات مختلفة)
class HomeBrands extends StatelessWidget {
  const HomeBrands({super.key});

  // خدمات الصف الأول (العلوي) - معرّفة كثوابت خارج الـ build لتحسين الأداء
  static final List<ServiceItem> _firstRowServices = [
    ServiceItem(
      imagePath: Assets.images.brand1.path,
      routeName: AppRoutesNames.entertain,
    ),
    ServiceItem(
      imagePath: Assets.images.brand2.path,
      routeName: AppRoutesNames.gift,
    ),
    ServiceItem(
      imagePath: Assets.images.brand4.path,
      routeName: AppRoutesNames.tourism,
    ),
    ServiceItem(
      imagePath: Assets.images.brand5.path,
      routeName: AppRoutesNames.market,
    ),
    ServiceItem(
      imagePath: Assets.images.brand10.path,
      routeName: AppRoutesNames.market,
    ),
    ServiceItem(
      imagePath: Assets.images.brand12.path,
      routeName: AppRoutesNames.market,
    ),
    ServiceItem(
      imagePath: Assets.images.brand14.path,
      routeName: AppRoutesNames.market,
    ),
  ];

  // خدمات الصف الثاني (السفلي)
  static final List<ServiceItem> _secondRowServices = [
    ServiceItem(
      imagePath: Assets.images.brand6.path,
      routeName: AppRoutesNames.kioks,
    ),
    ServiceItem(
      imagePath: Assets.images.brand7.path,
      routeName: AppRoutesNames.hotel,
    ),
    ServiceItem(
      imagePath: Assets.images.brand8.path,
      routeName: AppRoutesNames.mall,
    ),
    ServiceItem(
      imagePath: Assets.images.brand9.path,
      routeName: AppRoutesNames.beauty,
    ),
    ServiceItem(
      imagePath: Assets.images.brand11.path,
      routeName: AppRoutesNames.beauty,
    ),
    ServiceItem(
      imagePath: Assets.images.brand13.path,
      routeName: AppRoutesNames.beauty,
    ),
    ServiceItem(
      imagePath: Assets.images.brand15.path,
      routeName: AppRoutesNames.beauty,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // نأخذ الطول الأكبر لضمان عرض كافة العناصر في حال عدم تساوي القائمتين مستقبلاً
    final int itemCount = _firstRowServices.length > _secondRowServices.length
        ? _firstRowServices.length
        : _secondRowServices.length;

    return SliverPadding(
      padding: EdgeInsets.only(top: 6.h),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // عنوان القسم
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
              child: Text(
                'العلامات المشهورة',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),

            // القائمة الأفقية للخدمات بصفين مختلفين ومربوطين بنفس التمرير
            SizedBox(
              height: 140
                  .h, // الارتفاع الكلي المناسب ليتسع للصفين بالتساوي مع الفاصل
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // كارت الصف الأول (العلوي)
                        if (index < _firstRowServices.length)
                          _ServiceCard(item: _firstRowServices[index])
                        else
                          SizedBox(
                            width: 90.w,
                            height: 120.h,
                          ), // مساحة فارغة للمحافظة على الأبعاد

                        SizedBox(
                          height: 12.h,
                        ), // مسافة رأسية تفصل بين الصف العلوي والسفلي
                        // كارت الصف الثاني (السفلي)
                        if (index < _secondRowServices.length)
                          _ServiceCard(item: _secondRowServices[index])
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
      ),
    );
  }
}

/// كارت الخدمة الفردي كـ Widget مستقل لتقليل التعقيد البرمجي وتسهيل الصيانة
class _ServiceCard extends StatelessWidget {
  final ServiceItem item;

  const _ServiceCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 60.w,
      height: 60.h, // الارتفاع الثابت لكل كارت لضمان اتساق المظهر
      child: Material(
        color: Colors.transparent, // يضمن تفاعل تأثير الضغط (Ripple) بشكل سليم
        child: InkWell(
          borderRadius: BorderRadius.circular(
            16.r,
          ), // لتحديد تأثير الضغط بنفس تدوير زوايا الكرت
          onTap: () => Get.toNamed(item.routeName),
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
              child: Image.asset(
                item.imagePath,
                fit: BoxFit.cover,
                width: double.infinity, // تضمن ملء مساحة العرض بالكامل
              ),
            ),
          ),
        ),
      ),
    );
  }
}
