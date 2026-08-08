import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/api_response.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/data/models/product_details_model.dart';
import 'package:nisba_app/src/services/locale_service.dart';

import 'product_details_controller.dart';
import 'product_details_shimmer.dart';

class ProductDetailsScreen extends GetView<ProductDetailsController> {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Directionality(
      textDirection: Get.find<LocaleService>().textDirection,
      child: Scaffold(
        backgroundColor: cs.surfaceContainerHighest,
        bottomNavigationBar: _buildBottomBar(theme),
        body: Obx(() {
          final resp = controller.productDetailsResponse.value;

          if (resp.status == Status.init || resp.status == Status.loading) {
            return const ProductDetailsShimmer();
          }

          if (resp.status == Status.error) {
            return _buildErrorBody(theme, resp.message);
          }

          final details = resp.data.product;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildImageSection(theme, details: details),
                _buildProductInfo(theme, details: details),
                if (details != null && details.hasOptions)
                  _buildOptionsSection(theme, details),
                SizedBox(height: 16.h),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildErrorBody(ThemeData theme, String message) {
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
              message.isNotEmpty ? message : 'auto_key_242'.tr,
              style: theme.textTheme.bodyLarge?.copyWith(color: cs.error),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            ElevatedButton.icon(
              onPressed: controller.fetchProductDetails,
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

  Widget _buildImageSection(ThemeData theme, {ProductDetails? details}) {
    final cs = theme.colorScheme;
    final imageUrl = details?.image ?? controller.fallbackImage;
    final hasNetwork = imageUrl.startsWith('http');
    final sold = details?.soldCount ?? 0;

    return Stack(
      children: [
        Container(
          height: 230.h,
          width: double.infinity,
          color: cs.surfaceContainerHighest,
          child: hasNetwork
              ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(
                    Iconsax.shop,
                    color: cs.primary.withValues(alpha: 0.3),
                    size: 80.sp,
                  ),
                )
              : Icon(
                  Iconsax.shop,
                  color: cs.primary.withValues(alpha: 0.3),
                  size: 80.sp,
                ),
        ),
        Positioned(
          top: 44.h,
          left: 12.w,
          right: 12.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 38.w,
                  height: 38.h,
                  decoration: BoxDecoration(
                    color: cs.surface.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Iconsax.arrow_right_1,
                    color: cs.onSurface,
                    size: 18.sp,
                  ),
                ),
              ),
              Obx(
                () => GestureDetector(
                  onTap: controller.toggleFavorite,
                  child: Container(
                    width: 38.w,
                    height: 38.h,
                    decoration: BoxDecoration(
                      color: cs.surface.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      controller.isFavorite.value
                          ? Iconsax.heart5
                          : Iconsax.heart,
                      color: controller.isFavorite.value
                          ? cs.error
                          : cs.onSurface.withValues(alpha: 0.5),
                      size: 18.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (sold > 0)
          Positioned(
            bottom: 16.h,
            left: 16.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: cs.primary,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                'auto_key_244'.tr,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  color: cs.onPrimary,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProductInfo(ThemeData theme, {ProductDetails? details}) {
    final cs = theme.colorScheme;

    final name = details?.name ?? controller.fallbackName;
    final description = details?.description ?? controller.fallbackDescription;
    final rating = details?.market.rating ?? 0.0;
    final soldCount = details?.soldCount ?? 0;
    final oldPrice = details?.oldPrice;
    final price = details?.price ?? controller.fallbackPrice;
    final marketName = details?.market.name;
    final marketLocation = details?.market.locationTitle;

    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20.r),
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
          Text(
            name,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
          SizedBox(height: 4.h),
          if (description.isNotEmpty) ...[
            Text(
              description,
              style: TextStyle(
                fontSize: 12.sp,
                color: cs.onSurface.withValues(alpha: 0.55),
              ),
            ),
            SizedBox(height: 6.h),
          ],
          if (marketName != null && marketName.isNotEmpty) ...[
            Row(
              children: [
                Icon(
                  Iconsax.shop,
                  size: 14.sp,
                  color: cs.primary.withValues(alpha: 0.7),
                ),
                SizedBox(width: 4.w),
                Flexible(
                  child: Text(
                    marketName,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: cs.primary,
                    ),
                  ),
                ),
                if (marketLocation != null && marketLocation.isNotEmpty) ...[
                  SizedBox(width: 8.w),
                  Icon(
                    Iconsax.location,
                    size: 12.sp,
                    color: cs.onSurface.withValues(alpha: 0.4),
                  ),
                  SizedBox(width: 2.w),
                  Flexible(
                    child: Text(
                      marketLocation,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: cs.onSurface.withValues(alpha: 0.5),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: 8.h),
          ],
          Row(
            children: [
              Icon(Iconsax.star1, color: cs.primary, size: 16.sp),
              SizedBox(width: 4.w),
              Text(
                'auto_key_245'.tr,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: cs.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Obx(() {
            final unit = controller.unitPrice;
            return Row(
              children: [
                Text(
                  'auto_key_246'.tr,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: cs.primary,
                  ),
                ),
                if (oldPrice != null && oldPrice > price) ...[
                  SizedBox(width: 8.w),
                  Text(
                    'auto_key_247'.tr,
                    style: TextStyle(
                      fontSize: 12.sp,
                      decoration: TextDecoration.lineThrough,
                      color: cs.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                  if (details != null && details.savings.isNotEmpty) ...[
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: cs.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        details.savings,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: cs.error,
                        ),
                      ),
                    ),
                  ],
                ],
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildOptionsSection(ThemeData theme, ProductDetails details) {
    final cs = theme.colorScheme;

    return Column(
      children: details.options.map((option) {
        return Container(
          margin: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(20.r),
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
              Row(
                children: [
                  Expanded(
                    child: Text(
                      option.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: option.isRequired
                          ? cs.error.withValues(alpha: 0.1)
                          : cs.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      option.isRequired ? 'auto_key_85'.tr : 'auto_key_248'.tr,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: option.isRequired ? cs.error : cs.primary,
                      ),
                    ),
                  ),
                ],
              ),
              if (option.selectType.desc.isNotEmpty) ...[
                SizedBox(height: 4.h),
                Text(
                  option.selectType.desc,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: cs.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
              SizedBox(height: 10.h),
              Obx(() {
                // Depend on selectedByOption
                final _ = controller.selectedByOption.length;
                return Column(
                  children: option.values.map((choice) {
                    final selected =
                        option.id != null &&
                        choice.id != null &&
                        controller.isChoiceSelected(option.id!, choice.id!);
                    return Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: InkWell(
                        onTap: () => controller.toggleChoice(option, choice),
                        borderRadius: BorderRadius.circular(12.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? cs.primary.withValues(alpha: 0.08)
                                : cs.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: selected
                                  ? cs.primary
                                  : cs.outline.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                option.isSingleSelect
                                    ? (selected
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_off)
                                    : (selected
                                          ? Icons.check_box
                                          : Icons.check_box_outline_blank),
                                size: 20.sp,
                                color: selected
                                    ? cs.primary
                                    : cs.onSurface.withValues(alpha: 0.4),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Text(
                                  choice.name,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: cs.onSurface,
                                  ),
                                ),
                              ),
                              if (choice.price > 0)
                                Text(
                                  'auto_key_249'.tr,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: cs.primary,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomBar(ThemeData theme) {
    final cs = theme.colorScheme;

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 10.h),
      decoration: BoxDecoration(
        color: cs.surface,
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: controller.decrement,
                  child: Container(
                    width: 36.w,
                    height: 36.h,
                    alignment: Alignment.center,
                    child: Icon(
                      Iconsax.minus,
                      color: cs.onSurface,
                      size: 16.sp,
                    ),
                  ),
                ),
                Obx(
                  () => Text(
                    '${controller.quantity.value}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: controller.increment,
                  child: Container(
                    width: 36.w,
                    height: 36.h,
                    alignment: Alignment.center,
                    child: Icon(Iconsax.add, color: cs.primary, size: 16.sp),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'price'.tr,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: cs.onSurface.withValues(alpha: 0.5),
                ),
              ),
              Obx(
                () => Text(
                  'auto_key_250'.tr,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            height: 44.h,
            child: Obx(
              () => ElevatedButton.icon(
                onPressed: controller.isAdding.value
                    ? null
                    : controller.addToCart,
                icon: Icon(Iconsax.shopping_cart, size: 18.sp),
                label: Text(
                  'auto_key_251'.tr,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
