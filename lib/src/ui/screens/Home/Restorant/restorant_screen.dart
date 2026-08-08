import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/utils/locale_extensions.dart';

import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/api_response.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/routes/routes_names.dart';

import '../../../../../generated/assets.gen.dart';
import 'restorant_controller.dart';
import 'restorant_screen_shimmer.dart';

class RestorantScreen extends GetView<RestorantController> {
  const RestorantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surfaceContainerHighest,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(backIconData(context), color: cs.primary),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.args.name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.primary,
              ),
            ),
            Text(
              'auto_key_260'.tr,
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.5),
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Iconsax.notification, color: cs.primary),
          ),
        ],
      ),
      body: Obx(() {
        final status = controller.sectionResponse.value.status;

        // ── Shimmer for init / loading ──
        if (status == Status.init || status == Status.loading) {
          return const RestorantScreenShimmer();
        }

        // ── Error ──
        if (status == Status.error) {
          return _buildErrorBody(theme);
        }

        // ── Content ──
        return _buildContent(theme);
      }),
    );
  }

  Widget _buildErrorBody(ThemeData theme) {
    final cs = theme.colorScheme;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Iconsax.warning_2, size: 48.r, color: cs.error),
            SizedBox(height: 12.h),
            Text(
              controller.sectionResponse.value.message.isNotEmpty
                  ? controller.sectionResponse.value.message
                  : 'auto_key_242'.tr,
              style: theme.textTheme.bodyLarge?.copyWith(color: cs.error),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            ElevatedButton.icon(
              onPressed: () {
                final int args = Get.arguments['sectionId'] as int? ?? 0;
                controller.fetchSectionDetails(args);
              },
              icon: const Icon(Iconsax.refresh),
              label: Text('auto_key_243'.tr),
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.primary,
                foregroundColor: cs.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Promo cards ──
          _buildPromoCards(theme),

          SizedBox(height: 16.h),

          // ── Search bar ──
          _buildSearchBar(theme),

          SizedBox(height: 14.h),

          // ── Category icons ──
          _buildCategoryIcons(theme),

          SizedBox(height: 16.h),

          // ── Discount banner ──
          _buildDiscountBanner(theme),

          SizedBox(height: 16.h),

          // ── Nearby restaurants section ──
          _buildNearbySection(theme),

          SizedBox(height: 16.h),

          // ── Footer actions ──
          _buildFooterActions(theme),

          SizedBox(height: 16.h),

          // ── Nearby restaurants section ──
          _buildResturantSection(theme),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildPromoCards(ThemeData theme) {
    final cs = theme.colorScheme;

    return SizedBox(
      height: 120.h,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.passthrough,
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: cs.primary.withAlpha(20),

                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ClipOval(
                          child: Assets.images.appIcon.image(
                            width: 40,
                            height: 40,
                          ),
                        ),
                        Text(
                          'auto_key_261'.tr,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w900,
                            color: cs.onSurface,
                          ),
                        ),

                        Text(
                          'auto_key_262'.tr,
                          style: TextStyle(fontSize: 9.sp, color: cs.onSurface),
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            color: cs.primary.withAlpha(42),
                          ),
                          child: Text(
                            'auto_key_263'.tr,
                            style: TextStyle(
                              fontSize: 9.sp,
                              color: cs.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    left: 8,
                    child: Assets.images.resIcon.image(width: 80),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),

            Expanded(
              child: Stack(
                fit: StackFit.passthrough,
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: cs.primary.withAlpha(20),

                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ClipOval(
                          child: Assets.images.appIcon.image(
                            width: 40,
                            height: 40,
                          ),
                        ),
                        Text(
                          'auto_key_264'.tr,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w900,
                            color: cs.onSurface,
                          ),
                        ),

                        Text(
                          'auto_key_265'.tr,
                          style: TextStyle(fontSize: 9.sp, color: cs.onSurface),
                        ),

                        Row(
                          children: [
                            Icon(
                              Iconsax.tick_circle,
                              color: cs.error,
                              size: 14.sp,
                            ),
                            Text(
                              'auto_key_266'.tr,
                              style: TextStyle(
                                fontSize: 9.sp,
                                color: cs.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    left: 8,
                    child: Assets.images.resIcon2.image(width: 80),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    final cs = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
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
          decoration: InputDecoration(
            hintText: 'auto_key_267'.tr,
            hintStyle: TextStyle(
              color: cs.onSurface.withValues(alpha: 0.35),
              fontSize: 13.sp,
            ),
            prefixIcon: Icon(
              Iconsax.search_normal_1,
              color: cs.onSurface.withValues(alpha: 0.4),
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 14.h),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryIcons(ThemeData theme) {
    final cs = theme.colorScheme;

    return SizedBox(
      height: 80.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: controller.categories.length,
        separatorBuilder: (_, __) => SizedBox(width: 10.w),
        itemBuilder: (context, index) {
          final cat = controller.categories[index];
          return Column(
            children: [
              Container(
                width: 52.w,
                height: 52.h,
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [
                    BoxShadow(
                      color: cs.shadow.withValues(alpha: 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CachedNetworkImage(
                  imageUrl: cat['icon'] as String,
                  placeholder: (context, url) =>
                      const Icon(Icons.local_dining_sharp),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                cat['label'] as String,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDiscountBanner(ThemeData theme) {
    final cs = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [cs.primary, cs.primary.withValues(alpha: 0.7)],
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'auto_key_268'.tr,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: cs.onPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'auto_key_269'.tr,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: cs.onPrimary.withValues(alpha: 0.85),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: cs.onPrimary,
                    ),
                    child: Text(
                      'auto_key_270'.tr,
                      style: TextStyle(fontSize: 11.sp, color: cs.primary),
                    ),
                  ),
                ],
              ),
            ),
            Assets.images.resIcon.image(width: 80.w),
            Stack(
              alignment: Alignment.center,
              children: [
                Assets.images.bubble.image(width: 80.w),
                Text(
                  'auto_key_271'.tr,
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: cs.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNearbySection(ThemeData theme) {
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'auto_key_272'.tr,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        SizedBox(
          height: 230.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            itemCount: controller.restaurants.length,
            itemBuilder: (context, index) {
              final r = controller.restaurants[index];
              return GestureDetector(
                onTap: () {
                  if (r.id == null) return;
                  Get.toNamed(
                    AppRoutesNames.restorantDetails,
                    arguments: {
                      'id': r.id,
                      'name': r.name,
                      'main_image': r.imagePath,
                      'rating': r.rating,
                      'preparation_time': r.deliveryTime,
                      'distance': r.distance,
                      'is_fav': r.isFavorite,
                    },
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(left: 10.w),
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
                      // Image
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: CachedNetworkImage(
                            imageUrl: r.imagePath,
                            placeholder: (context, url) =>
                                const Icon(Icons.local_dining_sharp),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(10.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                r.name,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: cs.onSurface,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Row(
                                children: [
                                  Icon(
                                    Iconsax.star1,
                                    color: cs.primary,
                                    size: 14.sp,
                                  ),
                                  Icon(
                                    Iconsax.star1,
                                    color: cs.primary,
                                    size: 14.sp,
                                  ),
                                  SizedBox(width: 3.w),
                                  Text(
                                    r.rating.toString(),
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: cs.primary,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 2.h),
                              Row(
                                children: [
                                  Icon(
                                    Iconsax.timer_14,
                                    color: cs.onSurface,
                                    size: 14.sp,
                                  ),
                                  SizedBox(width: 3.w),
                                  Text(
                                    r.deliveryTime,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: cs.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 2.h),
                              Row(
                                children: [
                                  Icon(
                                    Iconsax.location,
                                    color: cs.onSurface,
                                    size: 14.sp,
                                  ),
                                  SizedBox(width: 3.w),
                                  Text(
                                    r.distance,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: cs.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildResturantSection(ThemeData theme) {
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            controller.restorantTitle.value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 9 / 12,
          ),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: controller.restaurants.length,
          itemBuilder: (context, index) {
            final r = controller.restaurants[index];
            return GestureDetector(
              onTap: () {
                if (r.id == null) return;
                Get.toNamed(
                  AppRoutesNames.restorantDetails,
                  arguments: {
                    'id': r.id,
                    'name': r.name,
                    'main_image': r.imagePath,
                    'rating': r.rating,
                    'preparation_time': r.deliveryTime,
                    'distance': r.distance,
                    'is_fav': r.isFavorite,
                  },
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: cs.shadow.withValues(alpha: 0.14),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: CachedNetworkImage(
                          imageUrl: r.imagePath,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r.name,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: cs.onSurface,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Icon(
                                Iconsax.star1,
                                color: cs.primary,
                                size: 14.sp,
                              ),
                              Icon(
                                Iconsax.star1,
                                color: cs.primary,
                                size: 14.sp,
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                r.rating.toString(),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: cs.primary,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              Icon(
                                Iconsax.timer_14,
                                color: cs.onSurface,
                                size: 14.sp,
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                r.deliveryTime,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: cs.onSurface,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              Icon(
                                Iconsax.location,
                                color: cs.onSurface,
                                size: 14.sp,
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                r.distance,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: cs.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFooterActions(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Row(
        children: [
          Expanded(
            child: _FooterChip(
              icon: Icons.compare_arrows_rounded,
              label: 'all'.tr,
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: _FooterChip(icon: Icons.restaurant_menu, label: 'auto_key_273'.tr),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: _FooterChip(
              icon: Icons.star_border_rounded,
              label: 'auto_key_274'.tr,
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: _FooterChip(icon: Iconsax.truck_fast, label: 'auto_key_275'.tr),
          ),
        ],
      ),
    );
  }
}

class _FooterChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FooterChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 6.w),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: cs.primary, size: 14.sp),
          SizedBox(width: 2.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: cs.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
