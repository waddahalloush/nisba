import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/services/locale_service.dart';

import 'package:nisba_app/src/configs/api_response.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/ui/screens/Search/search_controller.dart';
import 'package:nisba_app/src/ui/screens/search/widgets/main_tabs.dart';
import 'package:nisba_app/src/ui/screens/search/widgets/map_view_sheet.dart';
import 'package:nisba_app/src/ui/screens/search/widgets/restaurant_card.dart';
import 'package:nisba_app/src/ui/screens/search/widgets/search_bar_widget.dart';
import 'package:nisba_app/src/ui/screens/search/widgets/search_header.dart';
import 'package:nisba_app/src/ui/screens/search/widgets/search_toggle.dart';
import 'package:nisba_app/src/ui/screens/search/widgets/sort_row.dart';
import 'package:nisba_app/src/ui/screens/search/widgets/sub_tabs.dart';

class SearchScreen extends GetView<SearchhController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Directionality(
      textDirection: Get.find<LocaleService>().textDirection,
      child: Scaffold(
        backgroundColor: cs.surfaceContainerHighest,
        body: Column(
          children: [
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
            Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 12.h),
              child: MainTabs(
                selectedTab: controller.selectedMainTab,
                onTabSelected: controller.selectMainTab,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: const SubTabs(),
            ),
            const SortRow(),
            SizedBox(height: 4.h),
            Expanded(
              child: Obx(
                () => controller.isMapView.value
                    ? const MapViewSheet()
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
    if (ctrl.pageStatus.value == Status.loading && ctrl.partners.isEmpty) {
      return Center(child: SpinKitThreeBounce(color: cs.primary, size: 28.sp));
    }

    if (ctrl.pageStatus.value == Status.error && ctrl.partners.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              ctrl.errorMessage.value.isNotEmpty
                  ? ctrl.errorMessage.value
                  : 'auto_key_546'.tr,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.6),
              ),
            ),
            SizedBox(height: 12.h),
            TextButton(
              onPressed: ctrl.fetchList,
              child: Text('auto_key_243'.tr),
            ),
          ],
        ),
      );
    }

    final partners = ctrl.filteredPartners;
    if (partners.isEmpty) {
      return Center(
        child: Text(
          'auto_key_547'.tr,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: cs.onSurface.withValues(alpha: 0.5),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ctrl.fetchList(),
      child: ListView.builder(
        padding: EdgeInsets.only(top: 6.h, bottom: 24.h),
        itemCount: partners.length,
        itemBuilder: (_, index) {
          final partner = partners[index];
          return RestaurantCard(
            partner: partner,
            onFavoriteToggle: () => ctrl.toggleFavorite(index),
            onTap: () => ctrl.openPartner(partner),
          );
        },
      ),
    );
  }
}
