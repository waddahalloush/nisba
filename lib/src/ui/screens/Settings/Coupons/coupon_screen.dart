import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

import '../../../../../generated/assets.gen.dart';
import 'coupon_controller.dart';

class CouponScreen extends GetView<CouponController> {
  const CouponScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: cs.surfaceContainerHighest,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Iconsax.arrow_right_1, color: cs.primary),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'قسائم التوفير',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.primary,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'اختر القسيمة الأنسب لاحتياجاتك وابدأ التوفير الآن.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurface,
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Tab bar ──
              _buildTabBar(theme),

              SizedBox(height: 10.h),

              // ── Section title ──
              Text(
                'القسائم المتاحة',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
              SizedBox(height: 10.h),

              // ── Coupon list ──
              _buildCouponList(theme),

              SizedBox(height: 10.h),

              // ── Bottom code input ──
              _buildCodeInput(theme),

              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar(ThemeData theme) {
    final cs = theme.colorScheme;

    return Obx(
      () => Row(
        children: List.generate(controller.tabs.length, (i) {
          final isSelected = controller.selectedTab.value == i;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: GestureDetector(
                onTap: () => controller.selectTab(i),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    border: BoxBorder.fromLTRB(
                      bottom: BorderSide(
                        color: isSelected ? cs.primary : cs.surface,
                      ),
                    ),
                  ),
                  child: Text(
                    controller.tabs[i],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? cs.primary : cs.onSurface,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCouponList(ThemeData theme) {
    return Obx(
      () => Column(
        children: controller.filteredCoupons.map((coupon) {
          return Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: _CouponCard(coupon: coupon),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCodeInput(ThemeData theme) {
    final cs = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Iconsax.ticket_discount, color: cs.primary, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                'ولديك قسيمة أخرى؟',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'أدخل رمز القسيمة الخاصة بك للحصول على خصم إضافي.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.5),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.codeController,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: 'أدخل رمز القسيمة',
                    hintStyle: TextStyle(
                      color: cs.onSurface.withValues(alpha: 0.3),
                      fontSize: 12.sp,
                    ),
                    filled: true,
                    fillColor: cs.primary.withAlpha(16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 12.h,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              SizedBox(
                height: 44.h,
                child: ElevatedButton(
                  onPressed: controller.applyCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: cs.onPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'تطبيق',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CouponCard extends StatelessWidget {
  final CouponModel coupon;

  const _CouponCard({required this.coupon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    // نعتمد اللون الأصفر المستعمل في بطاقة الخصم والزر من لوحة الألوان الأساسية
    final primaryColor = cs.primary;
    final darkTextColor = cs.onSurface; // لون النصوص الداكنة في التصميم
    final grayTextColor = cs.onSurface.withAlpha(190);

    // تحديد الأيقونة المناسبة للبطاقة بناءً على العنوان
    IconData couponIcon = Iconsax.percentage_square;
    String prefixText = 'وفر';
    String discountValue = '15%';

    if (coupon.title.contains('شحن')) {
      couponIcon = Iconsax.truck_fast;
      prefixText = 'شحن مجاني';
      discountValue = '100%';
    } else if (coupon.title.contains('عروض')) {
      couponIcon = Iconsax.gift;
      prefixText = 'وفر';
      discountValue = '20%';
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(12.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── السطر الأول ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الابن الأول: عمود يحتوي على اسم القسيمة والوصف
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12.h),
                    Text(
                      coupon.title,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: darkTextColor,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      coupon.description,
                      style: TextStyle(fontSize: 11.sp, color: grayTextColor),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              // الابن الثاني: حاوية باللون الأساسي تحتوي على قيمة التوفير والحد الأقصى والأيقونة
              Container(
                width: 135.w,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),

                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: Assets.images.ticket.provider(),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      prefixText,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          discountValue,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.1,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Icon(couponIcon, color: Colors.white, size: 32.sp),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      coupon.maxSaving,
                      style: TextStyle(
                        fontSize: 8.sp,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // خط فاصل رفيع جداً قبل السطر الثاني كما بالصورة
          Divider(color: Colors.grey.shade100, height: 1),

          SizedBox(height: 12.h),

          // ── السطر الثاني ──
          Row(
            children: [
              // الحد الأدنى
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Iconsax.bag_2, size: 14.sp, color: primaryColor),
                  SizedBox(width: 4.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الحد الأدنى للطلب',
                        style: TextStyle(fontSize: 8.sp, color: grayTextColor),
                      ),
                      Text(
                        coupon.minOrder,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: darkTextColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // ديفايدر رأسي
              Container(
                height: 20.h,
                width: 1,
                color: Colors.grey.shade300,
                margin: EdgeInsets.symmetric(horizontal: 12.w),
              ),

              // المدة
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Iconsax.clock, size: 14.sp, color: primaryColor),
                  SizedBox(width: 4.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ينتهي خلال',
                        style: TextStyle(fontSize: 8.sp, color: grayTextColor),
                      ),
                      Text(
                        coupon.expiry.replaceAll('ينتهي خلال ', ''),
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: darkTextColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const Spacer(),
              // زر استخدم القسيمة (مفرغ ذو حواف دائرية)
              SizedBox(
                height: 34.h,
                child: OutlinedButton(
                  onPressed: () =>
                      Get.find<CouponController>().useCoupon(coupon),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: primaryColor, width: 1.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                  ),
                  child: Text(
                    'استخدم القسيمة',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
