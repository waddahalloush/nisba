import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/ui/screens/Search/search_controller.dart';

/// شريط البحث - حقل أبيض pill-shaped مع أيقونة بحث
class SearchBarWidget extends GetView<SearchhController> {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Container(
      height: 43.h,
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(40.r),
      ),
      child: TextField(
        controller: controller.searchTextController,
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurface),
        onChanged: controller.onSearchChanged,
        onSubmitted: controller.onSearchSubmitted,
        decoration: InputDecoration(
          hintText: 'ابحث عن مطعم أو شريك',
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: cs.onSurface.withValues(alpha: 0.4),
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: cs.onSurface.withValues(alpha: 0.4),
            size: 22.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
        ),
      ),
    );
  }
}
