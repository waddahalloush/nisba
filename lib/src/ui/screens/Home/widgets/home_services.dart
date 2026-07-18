import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/generated/assets.gen.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/routes/routes_names.dart';

/// Data model representing a service item
class ServiceItem {
  final String title;
  final String imagePath;
  final String routeName;

  const ServiceItem({
    required this.title,
    required this.imagePath,
    required this.routeName,
  });
}

/// قسم الخدمات الأفقي ثنائي الأسطر (كل سطر يعرض خدمات مختلفة)
class HomeServices extends StatelessWidget {
  const HomeServices({super.key});

  // خدمات الصف الأول (العلوي) - معرّفة كثوابت خارج الـ build لتحسين الأداء
  static final List<ServiceItem> _firstRowServices = [
    ServiceItem(
      title: 'الترفيه',
      imagePath: Assets.images.service1.path,
      routeName: AppRoutesNames.entertain,
    ),
    ServiceItem(
      title: 'الهدايا',
      imagePath: Assets.images.service2.path,
      routeName: AppRoutesNames.gift,
    ),
    ServiceItem(
      title: 'السياحة',
      imagePath: Assets.images.service3.path,
      routeName: AppRoutesNames.tourism,
    ),
    ServiceItem(
      title: 'الأسواق',
      imagePath: Assets.images.service4.path,
      routeName: AppRoutesNames.market,
    ),
  ];

  // خدمات الصف الثاني (السفلي)
  static final List<ServiceItem> _secondRowServices = [
    ServiceItem(
      title: 'Kioks',
      imagePath: Assets.images.service5.path,
      routeName: AppRoutesNames.kioks,
    ),
    ServiceItem(
      title: 'الفنادق',
      imagePath: Assets.images.service6.path,
      routeName: AppRoutesNames.hotel,
    ),
    ServiceItem(
      title: 'المولات',
      imagePath: Assets.images.service7.path,
      routeName: AppRoutesNames.mall,
    ),
    ServiceItem(
      title: 'التجميل',
      imagePath: Assets.images.service8.path,
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
                        height: 10.h,
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
      width: 90.w,
      height: 120.h, // الارتفاع الثابت لكل كارت لضمان اتساق المظهر
      child: Material(
        color: Colors.transparent, // يضمن تفاعل تأثير الضغط (Ripple) بشكل سليم
        child: InkWell(
          borderRadius: BorderRadius.circular(
            16.r,
          ), // لتحديد تأثير الضغط بنفس تدوير زوايا الكرت
          onTap: () => Get.toNamed(item.routeName),
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
                    child: Image.asset(
                      item.imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity, // تضمن ملء مساحة العرض بالكامل
                    ),
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                item.title,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.87),
                ),
                maxLines: 1,
                overflow: TextOverflow
                    .ellipsis, // لضمان عدم حدوث تجاوز في النصوص الطويلة
              ),
            ],
          ),
        ),
      ),
    );
  }
}
