import 'package:flutter/material.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

import '../../../../../generated/assets.gen.dart';

/// هيدر البروفايل داخل SliverAppBar
class ProfileHeader extends StatelessWidget {
  final String userName;
  final String userPhone;
  final VoidCallback? onBackTap;
  final VoidCallback? onSettingsTap;

  const ProfileHeader({
    super.key,
    required this.userName,
    required this.userPhone,
    this.onBackTap,
    this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 30.h,
        bottom: 90.h,
        left: 20.w,
        right: 20.w,
      ),
      decoration: BoxDecoration(
        color: cs.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(45.r),
          bottomRight: Radius.circular(45.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildGlassButton(
            context,
            icon: Icons.arrow_back_ios_rounded,
            onTap: onBackTap ?? () => Navigator.of(context).maybePop(),
          ),
          SizedBox(width: 10.w),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: cs.onPrimary, width: 3),
            ),
            child: CircleAvatar(
              radius: 20.r,
              backgroundColor: cs.onPrimary.withValues(alpha: 0.15),
              backgroundImage: Assets.images.appIcon.provider(),
            ),
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: cs.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6.h),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.copy_rounded,
                      size: 14.sp,
                      color: cs.onPrimary.withValues(alpha: 0.7),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    userPhone,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onPrimary.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          _buildGlassButton(
            context,
            icon: Icons.settings_outlined,
            onTap: onSettingsTap,
          ),
        ],
      ),
    );
  }

  Widget _buildGlassButton(
    BuildContext context, {
    required IconData icon,
    VoidCallback? onTap,
  }) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.r,
        height: 40.r,
        decoration: BoxDecoration(
          color: cs.onPrimary.withValues(alpha: 0.18),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: cs.onPrimary, size: 18.sp),
      ),
    );
  }
}
