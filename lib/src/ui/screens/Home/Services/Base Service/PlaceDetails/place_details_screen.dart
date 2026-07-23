import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

import '../../../../../../data/models/service_model.dart';
import 'place_details_controller.dart';

class PlaceDetailsScreen extends GetView<PlaceDetailsController> {
  const PlaceDetailsScreen({super.key});

  Widget _img(String path, {BoxFit fit = BoxFit.cover}) {
    if (path.isEmpty) {
      return Container(
        color: Colors.grey.shade300,
        child: const Icon(Icons.image, size: 40, color: Colors.grey),
      );
    }
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        fit: fit,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.broken_image, size: 40, color: Colors.grey),
      );
    }
    return Image.asset(
      path,
      fit: fit,
      errorBuilder: (_, __, ___) =>
          const Icon(Icons.broken_image, size: 40, color: Colors.grey),
    );
  }

  ImageProvider _imgProvider(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return NetworkImage(path);
    }
    return AssetImage(path);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final item = controller.item;
    final isHotel =
        item.serviceType.toLowerCase() == 'hotel' ||
        item.serviceType.toLowerCase() == 'فندق';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: cs.surfaceContainerHighest,
        bottomNavigationBar: Obx(
          () => controller.selectedCount.value > 0
              ? _bottomBar(theme)
              : const SizedBox.shrink(),
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _header(theme, item)),
            SliverToBoxAdapter(child: SizedBox(height: isHotel ? 135.h : 55.h)),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Obx(() => _tabBody(theme, item)),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 100.h)),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════
  //  BOTTOM BAR
  // ═══════════════════════════════════════════
  Widget _bottomBar(ThemeData theme) {
    final cs = theme.colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: cs.surface,
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${controller.selectedCount.value} عناصر مختارة',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: 11.sp,
                  color: cs.onSurface.withValues(alpha: 0.55),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                '${controller.totalPrice.value.toInt()} ${controller.item.currency}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: cs.primary,
                ),
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: cs.primary,
              padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              elevation: 0,
            ),
            child: Text(
              'متابعة الحجز',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════
  //  TOP PANORAMIC HEADER + FLOATING STATS CARD
  // ═══════════════════════════════════════════
  Widget _header(ThemeData theme, BaseServiceItem item) {
    final cs = theme.colorScheme;
    final isHotel =
        item.serviceType.toLowerCase() == 'hotel' ||
        item.serviceType.toLowerCase() == 'فندق';
    final img = controller.item.images.isNotEmpty
        ? controller.item.images.first
        : item.imageUrl;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // ── Image Banner ──
        Container(
          height: 310.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(28.r),
              bottomRight: Radius.circular(28.r),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(28.r),
              bottomRight: Radius.circular(28.r),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                _img(img),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.55),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),

                // ── Top Buttons ──
                Positioned(
                  top: 50.h,
                  left: 16.w,
                  right: 16.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button (Top Right in RTL)
                      CircleAvatar(
                        backgroundColor: cs.primary,
                        radius: 20.r,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Iconsax.arrow_right_1,
                            color: cs.onPrimary,
                            size: 20.sp,
                          ),
                          onPressed: () => Get.back(),
                        ),
                      ),
                      // Share & Favorite Buttons (Top Left in RTL)
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: cs.surface.withValues(alpha: 0.95),
                            radius: 20.r,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Iconsax.share,
                                color: cs.primary,
                                size: 18.sp,
                              ),
                              onPressed: () {},
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Obx(
                            () => CircleAvatar(
                              backgroundColor: cs.surface.withValues(
                                alpha: 0.95,
                              ),
                              radius: 20.r,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  controller.isFavorite.value
                                      ? Iconsax.heart5
                                      : Iconsax.heart,
                                  color: controller.isFavorite.value
                                      ? Colors.red
                                      : cs.primary,
                                  size: 18.sp,
                                ),
                                onPressed: controller.toggleFavorite,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ── Location Tag (Top Right for Hotel view) ──
                if (isHotel)
                  Positioned(
                    top: 50.h,
                    left: 70.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: cs.primary,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Iconsax.location,
                            color: Colors.white,
                            size: 14.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            item.address,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // ── Bottom Banner Text & Counter Badge ──
                Positioned(
                  bottom: isHotel ? 65.h : 55.h,
                  left: 16.w,
                  right: 16.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Counter badge
                      Obx(
                        () => Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 5.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Iconsax.gallery,
                                color: Colors.white,
                                size: 12.sp,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                '${controller.currentImageIndex.value} / ${controller.totalImages.value > 1 ? controller.totalImages.value : 25}',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.white,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Mall Title / Address Overlay (Non-Hotel)
                      if (!isHotel)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                item.name,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22.sp,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                item.address,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.white70,
                                  fontSize: 11.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Floating Stats Card ──
        Positioned(
          bottom: isHotel ? -120.h : -40.h,
          left: 16.w,
          right: 16.w,
          child: Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: cs.shadow.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: isHotel
                ? _hotelFloatingCardContent(theme, item)
                : _genericFloatingCardContent(theme, item),
          ),
        ),
      ],
    );
  }

  // ── Hotel Floating Card ──
  Widget _hotelFloatingCardContent(ThemeData theme, BaseServiceItem item) {
    final cs = theme.colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title & Rating Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Row(
                      children: List.generate(
                        5,
                        (i) =>
                            Icon(Iconsax.star1, color: cs.primary, size: 14.sp),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      item.category.isNotEmpty
                          ? item.category
                          : 'فندق خمس نجوم',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 11.sp,
                        color: cs.onSurface.withValues(alpha: 0.55),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Rating summary badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                children: [
                  Text(
                    '${item.rating}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                    ),
                  ),
                  Text(
                    'ممتاز',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),
        // Amenities Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _iconFeature(Iconsax.wifi, 'واي فاي مجاني', theme),
            _iconFeature(Iconsax.activity, 'مسبح', theme),
            _iconFeature(Iconsax.coffee, 'إفطار مجاني', theme),
            _iconFeature(Iconsax.car, 'مواقف سيارات', theme),
          ],
        ),
        SizedBox(height: 14.h),
        // Action Button
        SizedBox(
          width: double.infinity,
          height: 44.h,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: cs.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r),
              ),
              elevation: 0,
            ),
            child: Text(
              'استعلام',
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 10.h),
        // Footer info line
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.clock,
              size: 12.sp,
              color: cs.onSurface.withValues(alpha: 0.5),
            ),
            SizedBox(width: 4.w),
            Text(
              '30 دقيقة',
              style: theme.textTheme.labelSmall?.copyWith(
                fontSize: 10.sp,
                color: cs.onSurface.withValues(alpha: 0.5),
              ),
            ),
            SizedBox(width: 16.w),
            Icon(Iconsax.flash_1, size: 12.sp, color: cs.primary),
            SizedBox(width: 4.w),
            Text(
              'تأكيد فوري',
              style: theme.textTheme.labelSmall?.copyWith(
                fontSize: 10.sp,
                color: cs.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _iconFeature(IconData icon, String label, ThemeData theme) {
    final cs = theme.colorScheme;
    return Column(
      children: [
        Icon(icon, size: 16.sp, color: cs.onSurface.withValues(alpha: 0.6)),
        SizedBox(height: 4.h),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            fontSize: 9.sp,
            color: cs.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  // ── Generic / Mall Floating Card ──
  Widget _genericFloatingCardContent(ThemeData theme, BaseServiceItem item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _buildStats(theme, item),
    );
  }

  List<Widget> _buildStats(ThemeData theme, BaseServiceItem item) {
    final cs = theme.colorScheme;
    final stats = <_Stat>[];
    if (item.stats != null && item.stats!.isNotEmpty) {
      for (final s in item.stats!) {
        stats.add(_Stat(s.icon, s.value, s.title));
      }
    } else {
      stats.add(const _Stat(Iconsax.car, 'مواقف مجانية', 'توفير مواقف'));
      stats.add(const _Stat(Iconsax.shop, '+300 متجر', 'تسوق'));
      stats.add(
        _Stat(
          Iconsax.location,
          item.distance.isNotEmpty ? item.distance : 'الدوحة',
          'الموقع',
        ),
      );
      stats.add(
        _Stat(Iconsax.clock, item.hours ?? '10:00 - 11:00', 'ساعات العمل'),
      );
    }
    return stats
        .map(
          (s) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(s.icon, color: cs.primary, size: 18.sp),
              SizedBox(height: 6.h),
              Text(
                s.value,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                s.label,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: 8.sp,
                  color: cs.onSurface.withValues(alpha: 0.55),
                ),
              ),
            ],
          ),
        )
        .toList();
  }

  // ═══════════════════════════════════════════
  //  TAB BODY ROUTER (SWITCH / CASE STRATEGY)
  // ═══════════════════════════════════════════
  Widget _tabBody(ThemeData theme, BaseServiceItem item) {
    final activeTab = controller.selectedTab.value;
    final type = item.serviceType.toLowerCase();

    if (type == 'hotel' || type == 'فندق') {
      return _buildHotelView(theme, item, activeTab);
    } else if (type == 'mall' || type == 'مول') {
      return _buildMallView(theme, item, activeTab);
    } else if (type == 'beauty' || type == 'تجميل' || type == 'spa') {
      return _buildBeautyOrClinicView(theme, item, activeTab);
    } else {
      return _buildGenericView(theme, item, activeTab);
    }
  }

  // ═══════════════════════════════════════════
  //  1. HOTEL VIEW
  // ═══════════════════════════════════════════
  Widget _buildHotelView(
    ThemeData theme,
    BaseServiceItem item,
    String activeTab,
  ) {
    final cs = theme.colorScheme;
    final selectedRoom = activeTab.isNotEmpty ? activeTab : 'غرفة دبل';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Room header title & capacity badge
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedRoom,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'راحة وأناقة مثالية لإقامة مرحة',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 11.sp,
                    color: cs.onSurface.withValues(alpha: 0.55),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'شخصان',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: cs.primary,
                        ),
                      ),
                      Text(
                        'سرير مزدوج',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontSize: 9.sp,
                          color: cs.primary.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 6.w),
                  Icon(Iconsax.profile_2user, color: cs.primary, size: 18.sp),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // Room Card with specs, image, and price
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left side Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: SizedBox(
                      width: 130.w,
                      height: 170.h,
                      child: _img(
                        'https://images.unsplash.com/photo-1590490360182-c33d57733427?w=500&q=80',
                      ),
                    ),
                  ),
                  SizedBox(width: 14.w),

                  // Right side Specs
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _roomSpecItem('مساحة الغرفة: 28 م²', theme),
                        _roomSpecItem('إطلالة على المدينة', theme),
                        _roomSpecItem('تكييف هواء', theme),
                        _roomSpecItem('تلفزيون ذكي', theme),
                        _roomSpecItem('ميني بار', theme),
                        _roomSpecItem('حمام خاص مع لوازم مجانية', theme),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Price & Booking Action
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'السعر لليلة',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontSize: 10.sp,
                          color: cs.onSurface.withValues(alpha: 0.55),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '450',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: cs.primary,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            controller.item.currency,
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontSize: 11.sp,
                              color: cs.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        controller.toggleItemSelection('room_double', 450.0),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      padding: EdgeInsets.symmetric(
                        horizontal: 28.w,
                        vertical: 12.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'احجز الآن',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _roomSpecItem(String text, ThemeData theme) {
    final cs = theme.colorScheme;
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        children: [
          Icon(Iconsax.tick_circle, color: cs.primary, size: 14.sp),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 10.5.sp,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════
  //  2. MALL VIEW
  // ═══════════════════════════════════════════
  Widget _buildMallView(
    ThemeData theme,
    BaseServiceItem item,
    String activeTab,
  ) {
    final cs = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // About Section with side image
        _secTitle('عن ${item.name}', theme),
        SizedBox(height: 10.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                item.aboutText,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 11.5.sp,
                  color: cs.onSurface.withValues(alpha: 0.65),
                  height: 1.5,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: SizedBox(
                width: 110.w,
                height: 80.h,
                child: _img(
                  'https://images.unsplash.com/photo-1519567241046-7f570eee3ce6?w=500&q=80',
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),

        // Quick Links Row
        Container(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _quickLinkItem(Iconsax.send_2, 'الوصول للمول', theme),
              _quickLinkItem(
                Iconsax.discount_shape,
                'العروض والفعاليات',
                theme,
              ),
              _quickLinkItem(Iconsax.map, 'خريطة المول', theme),
              _quickLinkItem(Iconsax.headphone, 'خدمة العملاء', theme),
            ],
          ),
        ),
        SizedBox(height: 24.h),

        // Featured Restaurants Horizontal Cards
        _horizontalSectionTitle('المطاعم المميزة', theme),
        SizedBox(height: 12.h),
        SizedBox(
          height: 165.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _restaurantCard(
                'ذا تشيز كيك فاكتوري',
                'عالمي',
                4.8,
                'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=500&q=80',
                theme,
              ),
              _restaurantCard(
                'شاي ورد',
                'كافيه',
                4.6,
                'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=500&q=80',
                theme,
              ),
              _restaurantCard(
                'ماكدونالدز',
                'وجبات سريعة',
                4.4,
                'https://images.unsplash.com/photo-1550547660-d9450f859349?w=500&q=80',
                theme,
              ),
              _restaurantCard(
                'KFC',
                'وجبات سريعة',
                4.2,
                'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500&q=80',
                theme,
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),

        // Featured Stores Horizontal Cards
        _horizontalSectionTitle('المتاجر المميزة', theme),
        SizedBox(height: 12.h),
        SizedBox(
          height: 165.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _storeCard(
                'نايك',
                'رياضة',
                'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500&q=80',
                theme,
              ),
              _storeCard(
                'أبل',
                'إلكترونيات',
                'https://images.unsplash.com/photo-1510557880182-3d4d3cba35a5?w=500&q=80',
                theme,
              ),
              _storeCard(
                'سيفورا',
                'تجميل',
                'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=500&q=80',
                theme,
              ),
              _storeCard(
                'زارا',
                'أزياء',
                'https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?w=500&q=80',
                theme,
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),

        // Services & Facilities
        _secTitle('الخدمات والمرافق', theme),
        SizedBox(height: 14.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _facilityItem(Iconsax.man, 'دورات مياه', theme),
            _facilityItem(Iconsax.lamp_1, 'غرف صلاة', theme),
            _facilityItem(Iconsax.wifi, 'خدمة واي فاي', theme),
            _facilityItem(Iconsax.emoji_happy, 'مناطق أطفال', theme),
            _facilityItem(Iconsax.building, 'مصاعد', theme),
          ],
        ),
      ],
    );
  }

  Widget _quickLinkItem(IconData icon, String label, ThemeData theme) {
    final cs = theme.colorScheme;
    return Column(
      children: [
        Icon(icon, color: cs.primary, size: 24.sp),
        SizedBox(height: 6.h),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _horizontalSectionTitle(String title, ThemeData theme) {
    final cs = theme.colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: cs.onSurface,
          ),
        ),
        Text(
          'عرض الكل',
          style: theme.textTheme.labelMedium?.copyWith(
            fontSize: 11.sp,
            fontWeight: FontWeight.bold,
            color: cs.primary,
          ),
        ),
      ],
    );
  }

  Widget _restaurantCard(
    String name,
    String category,
    double rating,
    String imgUrl,
    ThemeData theme,
  ) {
    final cs = theme.colorScheme;
    return Container(
      width: 130.w,
      margin: EdgeInsets.only(left: 10.w),
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          CircleAvatar(radius: 24.r, backgroundImage: _imgProvider(imgUrl)),
          SizedBox(height: 8.h),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium?.copyWith(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            '$category • ⭐ $rating',
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 9.sp,
              color: cs.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const Spacer(),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 6.h),
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16.r),
            ),
            alignment: Alignment.center,
            child: Text(
              'احجز طاولة',
              style: theme.textTheme.labelSmall?.copyWith(
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
                color: cs.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _storeCard(
    String name,
    String category,
    String imgUrl,
    ThemeData theme,
  ) {
    final cs = theme.colorScheme;
    return Container(
      width: 130.w,
      margin: EdgeInsets.only(left: 10.w),
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          CircleAvatar(radius: 24.r, backgroundImage: _imgProvider(imgUrl)),
          SizedBox(height: 8.h),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium?.copyWith(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            category,
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 9.sp,
              color: cs.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const Spacer(),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 6.h),
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16.r),
            ),
            alignment: Alignment.center,
            child: Text(
              'استلام من المتجر',
              style: theme.textTheme.labelSmall?.copyWith(
                fontSize: 9.5.sp,
                fontWeight: FontWeight.bold,
                color: cs.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _facilityItem(IconData icon, String label, ThemeData theme) {
    final cs = theme.colorScheme;
    return Column(
      children: [
        Icon(icon, size: 20.sp, color: cs.onSurface.withValues(alpha: 0.5)),
        SizedBox(height: 6.h),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            fontSize: 9.5.sp,
            color: cs.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════
  //  3. BEAUTY / CLINIC VIEW
  // ═══════════════════════════════════════════
  Widget _buildBeautyOrClinicView(
    ThemeData theme,
    BaseServiceItem item,
    String activeTab,
  ) {
    if (item.productsOrServices != null &&
        item.productsOrServices!.isNotEmpty) {
      return _subItemsList(theme, item.productsOrServices!);
    }
    return _buildGenericView(theme, item, activeTab);
  }

  // ═══════════════════════════════════════════
  //  4. GENERIC FALLBACK VIEW
  // ═══════════════════════════════════════════
  Widget _buildGenericView(
    ThemeData theme,
    BaseServiceItem item,
    String activeTab,
  ) {
    final cs = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _secTitle('عن ${item.name}', theme),
        SizedBox(height: 8.h),
        Text(
          item.aboutText,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 12.sp,
            color: cs.onSurface.withValues(alpha: 0.65),
            height: 1.5,
          ),
        ),
        SizedBox(height: 20.h),
        if (item.productsOrServices != null &&
            item.productsOrServices!.isNotEmpty) ...[
          _secTitle('الخدمات والمنتجات', theme),
          SizedBox(height: 12.h),
          _subItemsList(theme, item.productsOrServices!),
        ],
      ],
    );
  }

  // ═══════════════════════════════════════════
  //  SUB ITEMS LIST
  // ═══════════════════════════════════════════
  Widget _subItemsList(ThemeData theme, List<ServiceSubItem> items) {
    final cs = theme.colorScheme;
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (_, i) {
        final p = items[i];
        final qty = controller.getQuantity(p.id);
        return Obx(() {
          final sel = controller.isSelected(p.id).value;
          return GestureDetector(
            onTap: () => controller.toggleItemSelection(p.id, p.price),
            child: Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: sel ? cs.primary.withValues(alpha: 0.05) : cs.surface,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: sel ? cs.primary : cs.outlineVariant,
                  width: sel ? 1.5 : 1.0,
                ),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: SizedBox(
                      width: 70.w,
                      height: 70.h,
                      child: _img(p.imageUrl),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.name,
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                            color: cs.onSurface,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          p.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontSize: 10.sp,
                            color: cs.onSurface.withValues(alpha: 0.55),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${p.price.toInt()} ${controller.item.currency}',
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: cs.primary,
                              ),
                            ),
                            if (sel) _qtyCtrls(theme, p, qty),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget _qtyCtrls(ThemeData theme, ServiceSubItem item, int qty) {
    final cs = theme.colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => controller.decrementQuantity(item.id, item.price),
            child: Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: cs.primary,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: const Icon(Iconsax.minus, color: Colors.white, size: 12),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Text(
              '$qty',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.primary,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => controller.incrementQuantity(item.id, item.price),
            child: Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: cs.primary,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: const Icon(Iconsax.add, color: Colors.white, size: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _secTitle(String title, ThemeData theme) {
    final cs = theme.colorScheme;
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 18.h,
          decoration: BoxDecoration(
            color: cs.primary,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
            color: cs.onSurface,
          ),
        ),
      ],
    );
  }
}

class _Stat {
  final IconData icon;
  final String value;
  final String label;
  const _Stat(this.icon, this.value, this.label);
}
