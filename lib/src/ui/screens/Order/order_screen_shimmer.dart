import 'package:flutter/material.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/utils/custom_shimmer_widget.dart';

class OrderScreenShimmer extends StatelessWidget {
  const OrderScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: [
        // ── 1. Header shimmer ──
        _buildHeaderShimmer(cs),
        // ── 2. Title + Tab bar ──
        _buildTitleAndTabs(cs),
        // ── 3. Order cards shimmer ──
        Expanded(child: _buildOrderListShimmer(cs)),
      ],
    );
  }

  Widget _buildHeaderShimmer(ColorScheme cs) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 30.h,
        bottom: 10.h,
        left: 20.w,
        right: 20.w,
      ),
      decoration: BoxDecoration(
        color: cs.primary,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(25.r),
          bottomLeft: Radius.circular(25.r),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomShimmerWidget.circular(size: 48.r),
              SizedBox(width: 8.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomShimmerWidget(
                    width: 120.w,
                    height: 14.h,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  SizedBox(height: 6.h),
                  CustomShimmerWidget(
                    width: 80.w,
                    height: 10.h,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          CustomShimmerWidget.circular(size: 40.r),
          SizedBox(width: 12.w),
          CustomShimmerWidget.circular(size: 40.r),
        ],
      ),
    );
  }

  Widget _buildTitleAndTabs(ColorScheme cs) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          CustomShimmerWidget(
            width: 100.w,
            height: 20.h,
            borderRadius: BorderRadius.circular(4.r),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              CustomShimmerWidget(
                width: 80.w,
                height: 34.h,
                borderRadius: BorderRadius.circular(20.r),
              ),
              SizedBox(width: 10.w),
              CustomShimmerWidget(
                width: 80.w,
                height: 34.h,
                borderRadius: BorderRadius.circular(20.r),
              ),
            ],
          ),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }

  Widget _buildOrderListShimmer(ColorScheme cs) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 4.h, bottom: 24.h),
      itemCount: 4,
      itemBuilder: (_, __) => _buildOrderCardShimmer(cs),
    );
  }

  Widget _buildOrderCardShimmer(ColorScheme cs) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomShimmerWidget(
                width: 70.w,
                height: 70.h,
                borderRadius: BorderRadius.circular(12.r),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomShimmerWidget(
                      width: double.infinity,
                      height: 14.h,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    SizedBox(height: 8.h),
                    CustomShimmerWidget(
                      width: 150.w,
                      height: 12.h,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    SizedBox(height: 6.h),
                    CustomShimmerWidget(
                      width: 100.w,
                      height: 12.h,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          CustomShimmerWidget(
            width: 80.w,
            height: 24.h,
            borderRadius: BorderRadius.circular(12.r),
          ),
          SizedBox(height: 12.h),
          const Divider(height: 1),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(3, (_) {
              return CustomShimmerWidget(
                width: 60.w,
                height: 12.h,
                borderRadius: BorderRadius.circular(4.r),
              );
            }),
          ),
          SizedBox(height: 12.h),
          CustomShimmerWidget(
            width: 130.w,
            height: 36.h,
            borderRadius: BorderRadius.circular(20.r),
          ),
        ],
      ),
    );
  }
}
