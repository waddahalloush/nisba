import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

import 'faq_controller.dart';

class FaqScreen extends GetView<FaqController> {
  const FaqScreen({super.key});

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
            'الأسئلة الشائعة',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              // ── Search bar ──
              _buildSearchBar(theme),

              SizedBox(height: 16.h),

              // ── FAQ list ──
              _buildFaqList(theme),

              SizedBox(height: 20.h),

              // ── Support banner ──
              _buildSupportBanner(theme),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    final cs = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller.searchController,
        onChanged: controller.onSearch,
        style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurface),
        decoration: InputDecoration(
          hintText: 'ابحث عن سؤال أو موضوع...',
          hintStyle: TextStyle(
            color: cs.onSurface.withValues(alpha: 0.35),
            fontSize: 13.sp,
          ),
          prefixIcon: Icon(
            Iconsax.search_normal_1,
            color: cs.onSurface.withValues(alpha: 0.4),
            size: 20.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14.h),
        ),
      ),
    );
  }

  Widget _buildFaqList(ThemeData theme) {
    final cs = theme.colorScheme;

    return Obx(
      () => Column(
        children: List.generate(controller.filteredFaqs.length, (index) {
          final faq = controller.filteredFaqs[index];
          final isExpanded = controller.expandedIndex.value == index;

          return Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: _FaqCard(faq: faq, index: index),
          );
        }),
      ),
    );
  }

  Widget _buildSupportBanner(ThemeData theme) {
    final cs = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: cs.primary,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Icon
          Container(
            width: 56.w,
            height: 56.h,
            decoration: BoxDecoration(
              color: cs.onPrimary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Iconsax.headphone, color: cs.onPrimary, size: 28.sp),
          ),
          SizedBox(height: 12.h),

          // Text
          Text(
            'لم تجد إجابتك؟',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: cs.onPrimary,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'فريق الدعم لدينا جاهز لمساعدتك',
            style: TextStyle(
              fontSize: 12.sp,
              color: cs.onPrimary.withValues(alpha: 0.85),
            ),
          ),

          SizedBox(height: 16.h),

          // Button
          SizedBox(
            width: double.infinity,
            height: 44.h,
            child: ElevatedButton(
              onPressed: controller.contactSupport,
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.onPrimary,
                foregroundColor: cs.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'تواصل معنا',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqCard extends StatelessWidget {
  final FaqItem faq;
  final int index;

  const _FaqCard({required this.faq, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final controller = Get.find<FaqController>();
    final isExpanded = controller.expandedIndex.value == index;

    return Container(
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
        children: [
          // ── Header (always visible) ──
          GestureDetector(
            onTap: () => controller.toggleExpand(index),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.all(14.r),
              child: Row(
                children: [
                  // Icon circle
                  Container(
                    width: 42.w,
                    height: 42.h,
                    decoration: BoxDecoration(
                      color: isExpanded
                          ? cs.primary.withValues(alpha: 0.1)
                          : cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      faq.icon,
                      color: isExpanded
                          ? cs.primary
                          : cs.onSurface.withValues(alpha: 0.5),
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),

                  // Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          faq.question,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: cs.onSurface,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          faq.subtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Expand chevron
                  AnimatedRotation(
                    turns: isExpanded ? 0.25 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Iconsax.arrow_left_2,
                      color: cs.onSurface.withValues(alpha: 0.3),
                      size: 18.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Expanded content ──
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: faq.answerTitle != null
                ? Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(14.w, 0, 14.w, 14.h),
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: cs.primary.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Iconsax.info_circle,
                          color: cs.primary,
                          size: 20.sp,
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                faq.answerTitle!,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: cs.primary,
                                ),
                              ),
                              if (faq.answerDesc != null) ...[
                                SizedBox(height: 4.h),
                                Text(
                                  faq.answerDesc!,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: cs.onSurface.withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }
}
