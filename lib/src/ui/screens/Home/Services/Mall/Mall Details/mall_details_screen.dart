import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/utils/locale_extensions.dart';

import 'package:nisba_app/src/services/locale_service.dart';

import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/configs/theme_extensions.dart';

import 'mall_details_controller.dart';

class MallDetailsScreen extends GetView<MallDetailsController> {
  const MallDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Directionality(
      textDirection: Get.find<LocaleService>().textDirection,
      child: Scaffold(
        backgroundColor: cs.surfaceContainerHighest,
        body: Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : CustomScrollView(
                  slivers: [
                    // ── Header image gallery ──
                    _buildHeaderGallery(theme),

                    // ── Info cards ──
                    SliverToBoxAdapter(child: _buildInfoCards(theme)),

                    // ── Tabs ──
                    SliverToBoxAdapter(child: _buildTabs(theme)),

                    // ── Tabs content ──
                    if (controller.selectedTab.value == 'auto_key_391'.tr) ...[
                      SliverToBoxAdapter(child: _buildAboutSection(theme)),
                      SliverToBoxAdapter(child: _buildActionButtons(theme)),
                      if (controller.featuredRestaurants.isNotEmpty)
                        SliverToBoxAdapter(
                          child: _buildFeaturedRestaurants(theme),
                        ),
                      if (controller.featuredStores.isNotEmpty)
                        SliverToBoxAdapter(child: _buildFeaturedStores(theme)),
                      SliverToBoxAdapter(child: _buildFacilities(theme)),
                    ] else if (controller.selectedTab.value ==
                        'auto_key_377'.tr) ...[
                      SliverToBoxAdapter(child: _buildFeaturedStores(theme)),
                    ] else if (controller.selectedTab.value ==
                        'auto_key_179'.tr) ...[
                      SliverToBoxAdapter(
                        child: _buildFeaturedRestaurants(theme),
                      ),
                    ],

                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  ],
                ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Header Gallery
  // ─────────────────────────────────────────────
  Widget _buildHeaderGallery(ThemeData theme) {
    final cs = theme.colorScheme;

    return SliverAppBar(
      expandedHeight: 300.h,
      pinned: true,
      backgroundColor: cs.surface,
      leading: Padding(
        padding: EdgeInsets.only(left: 8.w),
        child: Container(
          margin: EdgeInsets.all(6.r),
          decoration: BoxDecoration(
            color: cs.shadow.withValues(alpha: 0.4),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(backIconData(), color: cs.onPrimary, size: 20.sp),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 8.w),
          child: Container(
            margin: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: cs.shadow.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Iconsax.heart, color: cs.onPrimary, size: 20.sp),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 2.w),
          child: Container(
            margin: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: cs.shadow.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Iconsax.share, color: cs.onPrimary, size: 20.sp),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // ── Mall image ──
            if (controller.mallImage.value.isNotEmpty)
              Image.network(
                controller.mallImage.value,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: cs.primary,
                  child: Icon(
                    Iconsax.shop,
                    color: cs.onPrimary.withValues(alpha: 0.2),
                    size: 80.sp,
                  ),
                ),
              )
            else
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      cs.primary.withValues(alpha: 0.9),
                      cs.primary.withValues(alpha: 0.4),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Iconsax.shop,
                    color: cs.onPrimary.withValues(alpha: 0.2),
                    size: 80.sp,
                  ),
                ),
              ),

            // ── Bottom info overlay ──
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.fromLTRB(16.w, 30.h, 16.w, 14.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      cs.shadow.withValues(alpha: 0.7),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            controller.mallName.value,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: cs.onPrimary,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            controller.address.value,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: cs.onPrimary.withValues(alpha: 0.85),
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Row(
                            children: [
                              ...List.generate(
                                controller.stars.value,
                                (_) => Padding(
                                  padding: EdgeInsets.only(left: 2.w),
                                  child: Icon(
                                    Iconsax.star1,
                                    color: cs.primary,
                                    size: 12.sp,
                                  ),
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                '${controller.rating.value}',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                  color: cs.onPrimary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // ── Logo placeholder ──
                    Container(
                      width: 50.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: cs.onPrimary,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Center(
                        child: Text(
                          'GM',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: cs.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Info Cards
  // ─────────────────────────────────────────────
  Widget _buildInfoCards(ThemeData theme) {
    final cs = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(top: 14.h, bottom: 8.h),
      child: SizedBox(
        height: 90.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: controller.infoCards.length,
          itemBuilder: (context, index) {
            final card = controller.infoCards[index];
            return Container(
              width: 150.w,
              margin: EdgeInsets.only(left: 10.w),
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: cs.shadow.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 36.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      color: cs.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      _infoCardIcon(index),
                      color: cs.primary,
                      size: 18.sp,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          card.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                            color: cs.onSurface,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          card.value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: cs.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  IconData _infoCardIcon(int index) {
    switch (index) {
      case 0:
        return Iconsax.clock;
      case 1:
        return Iconsax.location;
      case 2:
        return Iconsax.shop;
      case 3:
        return Iconsax.car;
      default:
        return Iconsax.info_circle;
    }
  }

  // ─────────────────────────────────────────────
  //  Tabs
  // ─────────────────────────────────────────────
  Widget _buildTabs(ThemeData theme) {
    final cs = theme.colorScheme;

    return SizedBox(
      height: 42.h,
      child: Obx(
        () => ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: controller.tabs.length,
          itemBuilder: (context, index) {
            final tab = controller.tabs[index];
            final isSelected = controller.selectedTab.value == tab;
            return Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: GestureDetector(
                onTap: () => controller.selectTab(tab),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? cs.primary : cs.surface,
                    borderRadius: BorderRadius.circular(22.r),
                    border: Border.all(
                      color: isSelected ? cs.primary : cs.outlineVariant,
                      width: 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: cs.primary.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    tab,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: isSelected ? cs.onPrimary : cs.onSurface,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  About Section
  // ─────────────────────────────────────────────
  Widget _buildAboutSection(ThemeData theme) {
    final cs = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'auto_key_398'.tr,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            controller.aboutText.value,
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.7),
              height: 1.6,
            ),
          ),
          SizedBox(height: 12.h),

          // ── Interior image placeholder ──
          Container(
            height: 160.h,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
              gradient: LinearGradient(
                colors: [
                  cs.primary.withValues(alpha: 0.85),
                  cs.primary.withValues(alpha: 0.45),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            child: Center(
              child: Icon(
                Iconsax.gallery,
                color: cs.onPrimary.withValues(alpha: 0.3),
                size: 48.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Action Buttons
  // ─────────────────────────────────────────────
  Widget _buildActionButtons(ThemeData theme) {
    final cs = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10.h,
          crossAxisSpacing: 10.w,
          childAspectRatio: 3.2,
        ),
        itemCount: controller.actions.length,
        itemBuilder: (context, index) {
          final action = controller.actions[index];
          return GestureDetector(
            onTap: () {
              // TODO: handle action
            },
            child: Container(
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: cs.outlineVariant, width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(_actionIcon(index), color: cs.primary, size: 16.sp),
                  SizedBox(width: 8.w),
                  Text(
                    action,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _actionIcon(int index) {
    switch (index) {
      case 0:
        return Iconsax.headphone;
      case 1:
        return Iconsax.map;
      case 2:
        return Iconsax.discount_shape;
      case 3:
        return Iconsax.location;
      default:
        return Iconsax.info_circle;
    }
  }

  // ─────────────────────────────────────────────
  //  Featured Restaurants
  // ─────────────────────────────────────────────
  Widget _buildFeaturedRestaurants(ThemeData theme) {
    final cs = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(top: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              'auto_key_355'.tr,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          SizedBox(
            height: 175.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: controller.featuredRestaurants.length,
              itemBuilder: (context, index) {
                final rest = controller.featuredRestaurants[index];
                return GestureDetector(
                  onTap: () => controller.openVendor(rest),
                  child: Container(
                    width: 140.w,
                    margin: EdgeInsets.only(left: 10.w),
                    clipBehavior: Clip.antiAlias,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ── Image ──
                        SizedBox(
                          height: 90.h,
                          child: rest.imageUrl.isNotEmpty
                              ? Image.network(
                                  rest.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: cs.primary.withValues(alpha: 0.2),
                                    child: Icon(
                                      Iconsax.coffee,
                                      color: cs.primary,
                                    ),
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        cs.primary.withValues(alpha: 0.8),
                                        cs.primary.withValues(alpha: 0.4),
                                      ],
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Iconsax.coffee,
                                      color: cs.onPrimary.withValues(
                                        alpha: 0.3,
                                      ),
                                      size: 30.sp,
                                    ),
                                  ),
                                ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                rest.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: cs.onSurface,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Row(
                                children: [
                                  Icon(
                                    Iconsax.star1,
                                    color: context.zatheExtras.star,
                                    size: 11.sp,
                                  ),
                                  SizedBox(width: 3.w),
                                  Text(
                                    '${rest.rating}',
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w600,
                                      color: cs.onSurface,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    'auto_key_3'.tr,
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600,
                                      color: cs.primary,
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
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Featured Stores
  // ─────────────────────────────────────────────
  Widget _buildFeaturedStores(ThemeData theme) {
    final cs = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(top: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              'auto_key_362'.tr,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          SizedBox(
            height: 150.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: controller.featuredStores.length,
              itemBuilder: (context, index) {
                final store = controller.featuredStores[index];
                return GestureDetector(
                  onTap: () => controller.openVendor(store),
                  child: Container(
                    width: 120.w,
                    margin: EdgeInsets.only(left: 10.w),
                    clipBehavior: Clip.antiAlias,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 80.h,
                          child: store.imageUrl.isNotEmpty
                              ? Image.network(
                                  store.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: cs.primary.withValues(alpha: 0.2),
                                    child: Icon(Iconsax.bag, color: cs.primary),
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        cs.primary.withValues(alpha: 0.75),
                                        cs.primary.withValues(alpha: 0.35),
                                      ],
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Iconsax.bag,
                                      color: cs.onPrimary.withValues(
                                        alpha: 0.3,
                                      ),
                                      size: 28.sp,
                                    ),
                                  ),
                                ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                store.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: cs.onSurface,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'auto_key_399'.tr,
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                  color: cs.primary,
                                ),
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
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Facilities
  // ─────────────────────────────────────────────
  Widget _buildFacilities(ThemeData theme) {
    final cs = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'auto_key_400'.tr,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.all(14.r),
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
            child: Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: controller.facilities
                  .map(
                    (f) => Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: cs.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _facilityIcon(f),
                            color: cs.primary,
                            size: 14.sp,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            f,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: cs.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  IconData _facilityIcon(String facility) {
    if (facility == 'auto_key_376'.tr) return Iconsax.arrow_up_1;
    if (facility == 'auto_key_392'.tr) return Iconsax.smileys;
    if (facility == 'auto_key_306'.tr) return Iconsax.wifi;
    if (facility == 'auto_key_393'.tr) return Iconsax.building;
    if (facility == 'auto_key_372'.tr) return Iconsax.empty_wallet;
    return Iconsax.tick_circle;
  }
}
