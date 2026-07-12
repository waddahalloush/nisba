import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/ui/screens/search/widgets/main_tabs.dart';
import 'package:nisba_app/src/ui/screens/search/widgets/map_view_sheet.dart';
import 'package:nisba_app/src/ui/screens/search/widgets/restaurant_card.dart';
import 'package:nisba_app/src/ui/screens/search/widgets/search_bar_widget.dart';
import 'package:nisba_app/src/ui/screens/search/widgets/search_header.dart';
import 'package:nisba_app/src/ui/screens/search/widgets/search_toggle.dart';
import 'package:nisba_app/src/ui/screens/search/widgets/sort_row.dart';
import 'package:nisba_app/src/ui/screens/search/widgets/sub_tabs.dart';

import 'search_controller.dart';

class SearchScreen extends GetView<SearchhController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: cs.surfaceContainerHighest,
        body: Column(
          children: [
            // 1. هيدر ثابت (خلفية برتقالية + بحث + مفتاح تبديل)
            SearchHeader(
              child: Column(
                children: [
                  const SearchBarWidget(),
                  SizedBox(height: 12.h),
                  SearchToggle(
                    isMapView: controller.isMapView,
                    onToggle: controller.toggleMapView,
                  ),
                ],
              ),
            ),

            // 2. التبويبات الرئيسية
            Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 12.h),
              child: MainTabs(
                selectedTab: controller.selectedMainTab,
                onTabSelected: controller.selectMainTab,
              ),
            ),

            // 3. التبويبات الفرعية (كبسولات)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SubTabs(
                selectedTab: controller.selectedSubTab,
                onTabSelected: controller.selectSubTab,
              ),
            ),

            // 4. صف الترتيب
            const SortRow(),
            SizedBox(height: 4.h),
            // 5. المحتوى الرئيسي (قائمة أو خريطة)
            Expanded(
              child: Obx(
                () => controller.isMapView.value
                    ? MapViewSheet(nearbyPartners: controller.nearbyPartners)
                    : _buildContentList(controller, theme, cs),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentList(
    SearchhController ctrl,
    ThemeData theme,
    ColorScheme cs,
  ) {
    final partners = ctrl.filteredPartners;
    if (partners.isEmpty) {
      return Center(
        child: Text(
          'لا توجد نتائج',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: cs.onSurface.withValues(alpha: 0.5),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(top: 6.h, bottom: 24.h),
      itemCount: partners.length,
      itemBuilder: (_, index) {
        return RestaurantCard(
          partner: partners[index],
          onFavoriteToggle: () => ctrl.toggleFavorite(index),
        );
      },
    );
  }
}
