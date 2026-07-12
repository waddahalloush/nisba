import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/ui/screens/search/search_controller.dart';

/// صف الترتيب مع dropdown (تصاعدي / تنازلي)
class SortRow extends GetView<SearchhController> {
  const SortRow({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: GestureDetector(
          onTap: () => _showSortMenu(context, controller),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.r),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Iconsax.setting_44, size: 18.sp, color: cs.onSurface),
                SizedBox(width: 8.w),
                Text(
                  'ترتيب حسب الأقرب',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.7),
                  ),
                ),

                Icon(Icons.arrow_drop_down, size: 20.sp, color: cs.onSurface),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSortMenu(BuildContext context, SearchhController controller) {
    final items = ['تصاعدي', 'تنازلي'];
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    final offset = renderBox.localToGlobal(
      Offset(renderBox.size.width, renderBox.size.height),
    );

    final theme = Theme.of(context);

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx - renderBox.size.width + 80.w,
        offset.dy + 4.h,
        offset.dx,
        offset.dy,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      items: items.map((item) {
        return PopupMenuItem<String>(
          value: item,
          child: Text(item, style: theme.textTheme.labelMedium),
        );
      }).toList(),
    ).then((value) {
      if (value != null) controller.setSort(value);
    });
  }
}
