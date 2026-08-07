import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/configs/api_response.dart';
import 'package:nisba_app/src/configs/app_colors.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/routes/routes_names.dart';
import 'package:nisba_app/src/ui/screens/Home/Services/service_section_navigator.dart';
import 'package:nisba_app/src/ui/screens/Home/home_screen_shimmer.dart';
import 'package:nisba_app/src/ui/screens/Home/widgets/home_categories.dart';
import 'package:nisba_app/src/ui/screens/Home/widgets/home_daily_offers.dart';
import 'package:nisba_app/src/ui/screens/Home/widgets/home_header.dart';
import 'package:nisba_app/src/ui/screens/Home/widgets/home_services.dart';

import 'home_controller.dart';
import 'widgets/home_offer_market.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Obx(() {
        final status = controller.homeResponse.value.status;
        log('HomeScreen: status = $status');
        // Show shimmer while the API call is still pending
        if (status == Status.completed) {
          return _buildContent(context);
        }

        // Show real content once data is loaded (or on error — fallback
        // placeholder data is already populated in onInit).
        return const HomeScreenShimmer();
      }),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    return CustomScrollView(
      controller: controller.scrollController,
      slivers: [
        // ─── 1 & 2. القسم العلوي المتداخل (الخلفية المتدرجة + العناصر) ───
        HomeHeader(controller: controller),

        if (controller.marketSections.isNotEmpty) ...[
          _buildSectionTitle('أقسام الماركت', false),
          HomeCategories(
            categories: controller.marketSections,
            trailing: _buildOfferTile(theme),
            onSectionTap: (section) {
              // Market section flow: open section stores screen, then request
              // `/api/v1/sections/{id}` for stores/popular_stores/tags.
              Get.toNamed(
                AppRoutesNames.restorant,
                arguments: {'section': section},
              );
            },
          ),
        ],

        if (controller.serviceSections.isNotEmpty) ...[
          _buildSectionTitle('أقسام الخدمات', true),
          HomeCategories(
            categories: controller.serviceSections,
            onSectionTap: (section) {
              // Branches by Section.route_key: booking list / mall / kioks / store.
              ServiceSectionNavigator.open(section);
            },
          ),
        ],

        ...controller.offers.map((offer) {
          if (offer.products != null) {
            return HomeDailyOffers(
              title: offer.title,
              productList: offer.products!,
            );
          }
          if (offer.markets != null) {
            return HomeOfferMarket(
              title: offer.title,
              marketList: offer.markets!,
            );
          }
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }),

        // ─── 5. العلامات المشهورة ───
        HomeBrands(brands: controller.brands),
        // ─── 6. وجبات (أنواع الوجبات من API) ───
        HomeOfferMarket(
          title: "القريبة منك",
          marketList: controller.nearFromYou,
        ),

        // مسافة أمان سفليّة
        SliverToBoxAdapter(child: SizedBox(height: 30.h)),
      ],
    );
  }

  Widget _buildOfferTile(ThemeData theme) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutesNames.offer),
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
                image: const DecorationImage(
                  image: AssetImage('assets/images/cat-offer.jpg'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'العروض',
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

  Widget _buildSectionTitle(String title, bool isShowMore) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
            ),
            if (isShowMore)
              GestureDetector(
                onTap: () {
                  Get.toNamed(
                    AppRoutesNames.allHomeServices,
                    arguments: {'sections': controller.serviceSections},
                  );
                },
                child: Text(
                  "عرض الكل",
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
