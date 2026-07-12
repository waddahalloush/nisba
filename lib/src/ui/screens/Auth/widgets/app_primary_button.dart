import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

/// A reusable primary button styled with the app's theme.
///
/// Features:
/// - Automatically uses [Theme] primary colors
/// - Shows a [CircularProgressIndicator] when [isLoading] is true
/// - Disables itself when [isLoading] or [isDisabled] is true
/// - Fully responsive using .w/.h/.r/.sp extensions
class AppPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final double? width;
  final double height;
  final double borderRadius;

  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.height = 56,
    this.borderRadius = 30,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isInactive = isLoading || isDisabled || onPressed == null;

    return SizedBox(
      width: width ?? double.infinity,
      height: height.h,
      child: ElevatedButton(
        onPressed: isInactive ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          disabledBackgroundColor: theme.colorScheme.primary.withValues(
            alpha: 0.5,
          ),
          disabledForegroundColor: theme.colorScheme.onPrimary.withValues(
            alpha: 0.7,
          ),
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius.r),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                width: 24.w,
                height: 24.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: theme.colorScheme.onPrimary,
                ),
              )
            : Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: isInactive
                      ? theme.colorScheme.onPrimary.withValues(alpha: 0.7)
                      : theme.colorScheme.onPrimary,
                ),
              ),
      ),
    );
  }
}
