import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

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
            icon: Icon(Iconsax.arrow_right_1, color: cs.onSurface),
          ),
          title: Text(
            'الشروط و الخدمات',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              // ── Intro banner ──
              _buildIntroBanner(theme),

              SizedBox(height: 14.h),

              // ── Sections ──
              const _SectionCard(
                icon: Iconsax.document_text,
                title: 'سياسة الاستخدام',
                content:
                    'باستخدام تطبيق نسبة فإنك توافق على الالتزام بهذه الشروط والأحكام.',
              ),
              SizedBox(height: 10.h),

              const _SectionCard(
                icon: Iconsax.mobile,
                title: 'وصف الخدمة',
                content:
                    'يوفر تطبيق نسبة منصة لعرض وبيع الطعام والمنتجات من المطاعم والمتاجر مع إمكانية الطلب والدفع والهدايا.',
              ),
              SizedBox(height: 10.h),

              const _SectionCard(
                icon: Iconsax.user,
                title: 'حساب المستخدم',
                content: 'يلتزم المستخدم بما يلي:',
                bulletPoints: [
                  'تقديم معلومات صحيحة ودقيقة.',
                  'الحفاظ على سرية الحساب وكلمة السر.',
                  'عدم استخدام التطبيق بشكل مخالف للقانون.',
                  'يحق لنا تعليق أو إلغاء الحسابات المخالفة.',
                ],
              ),
              SizedBox(height: 10.h),

              const _SectionCard(
                icon: Iconsax.bag_2,
                title: 'الطلبات والدفع',
                content: '',
                bulletPoints: [
                  'جميع الطلبات تخضع لتوفر المنتجات.',
                  'الأسعار قابلة للتغيير دون إشعار مسبق.',
                  'يتحمل المستخدم مسؤولية صحة معلومات التوصيل.',
                  'تتم عمليات الدفع عبر وسائل دفع معتمدة وآمنة.',
                ],
              ),
              SizedBox(height: 10.h),

              const _SectionCard(
                icon: Iconsax.refresh,
                title: 'الإلغاء والاسترجاع',
                content: '',
                bulletPoints: [
                  'يمكن إلغاء الطلب قبل التحضير والشحن.',
                  'لا يمكن استرجاع المنتجات الغذائية بعد استلامها إلا في حال وجود خطأ أو تلف.',
                  'يتم التعامل مع الشكاوى خلال مدة معقولة وفق سياسة التطبيق.',
                ],
              ),
              SizedBox(height: 10.h),

              const _SectionCard(
                icon: Iconsax.shield_cross,
                title: 'الاستخدام الممنوع',
                content: 'يمنع استخدام التطبيق في:',
                bulletPoints: [
                  'أي نشاط غير قانوني.',
                  'إرسال محتوى مسيء أو ضار.',
                  'محاولة اختراق أو تعطيل التطبيق.',
                  'انتحال شخصية الآخرين.',
                ],
              ),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntroBanner(ThemeData theme) {
    final cs = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.h,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Iconsax.message_question,
              color: cs.primary,
              size: 22.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'مرحباً بك في مركز المساعدة. تصفح الأقسام أدناه للتعرف على سياسات وشروط استخدام تطبيق نسبة.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.65),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final List<String>? bulletPoints;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.content,
    this.bulletPoints,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16.r),
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
          // ── Header ──
          Row(
            children: [
              Container(
                width: 36.w,
                height: 36.h,
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, color: cs.primary, size: 18.sp),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                ),
              ),
            ],
          ),

          // ── Content ──
          if (content.isNotEmpty) ...[
            SizedBox(height: 10.h),
            Text(
              content,
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.65),
                height: 1.5,
              ),
            ),
          ],

          // ── Bullet points ──
          if (bulletPoints != null && bulletPoints!.isNotEmpty) ...[
            SizedBox(height: 10.h),
            ...bulletPoints!.map(
              (point) => Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 6.h),
                      width: 6.w,
                      height: 6.h,
                      decoration: BoxDecoration(
                        color: cs.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        point,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurface.withValues(alpha: 0.75),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
