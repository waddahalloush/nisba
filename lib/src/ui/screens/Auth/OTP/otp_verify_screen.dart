import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:pinput/pinput.dart';

import '../widgets/app_primary_button.dart';
import 'otp_verify_controller.dart';

class OtpVerifyScreen extends GetView<OtpVerifyController> {
  const OtpVerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Back button ──
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 16.h),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_forward_outlined,
                        color: primaryColor,
                        size: 28,
                      ),
                      onPressed: () => Get.back(),
                      style: IconButton.styleFrom(padding: EdgeInsets.zero),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),

                // ── Title ──
                Text(
                  'auth_otp_title'.tr,
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),

                // ── Subtitles ──
                Text(
                  'auth_otp_subtitle_line1'.tr,
                  style: textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.87),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'auth_otp_subtitle_line2'.tr,
                  style: textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.87),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),

                // ── Phone number display ──
                Text(
                  controller.phoneNumber,
                  style: textTheme.titleLarge?.copyWith(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    fontSize: 16.sp,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.ltr,
                ),
                SizedBox(height: 48.h),

                // ── OTP input (Pinput) ──
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Pinput(
                    length: 6,
                    onChanged: (value) => controller.otpCode.value = value,
                    onCompleted: (_) => controller.verifyOtp(),
                    keyboardType: TextInputType.number,
                    pinAnimationType: PinAnimationType.fade,
                    separatorBuilder: (index) => index == 2
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Text(
                              '-',
                              style: TextStyle(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.45),
                                fontSize: 24,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          )
                        : SizedBox(width: 6.w),
                    defaultPinTheme: PinTheme(
                      width: 50.w,
                      height: 64.h,
                      textStyle: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: theme.colorScheme.outlineVariant,
                          width: 1.5,
                        ),
                      ),
                    ),
                    focusedPinTheme: PinTheme(
                      width: 50.w,
                      height: 64.h,
                      textStyle: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(color: primaryColor, width: 1.5),
                      ),
                    ),
                    useNativeKeyboard: true,
                    preFilledWidget: Text(
                      '0',
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.45,
                        ),
                      ),
                    ),
                    cursor: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 2.w,
                          height: 28.h,
                          color: primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40.h),

                // ── Security notice card ──
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          'auth_security_notice'.tr,
                          style: textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.87,
                            ),
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Icon(
                        Icons.privacy_tip_outlined,
                        color: primaryColor,
                        size: 24,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 48.h),

                // ── Resend & countdown area ──
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => InkWell(
                        onTap: controller.canResend.value
                            ? controller.resendOtp
                            : null,
                        borderRadius: BorderRadius.circular(4.r),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.refresh_rounded,
                              color: controller.canResend.value
                                  ? primaryColor
                                  : theme.colorScheme.onSurface.withValues(
                                    alpha: 0.45,
                                  ),
                              size: 20,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              'auth_resend_link'.tr,
                              style: textTheme.bodyLarge?.copyWith(
                                color: controller.canResend.value
                                    ? primaryColor
                                    : theme.colorScheme.onSurface.withValues(
                                      alpha: 0.45,
                                    ),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Obx(
                      () => RichText(
                        text: TextSpan(
                          style: textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                          ),
                          children: [
                            TextSpan(
                              text: 'auth_resend_countdown_prefix'.tr,
                            ),
                            TextSpan(
                              text: controller.formattedTime,
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: 'auth_resend_countdown_suffix'.tr,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50.h),

                // ── Next button ──
                Obx(
                  () => AppPrimaryButton(
                    label: 'next'.tr,
                    onPressed: controller.otpCode.value.length >= 6
                        ? controller.verifyOtp
                        : null,
                    isLoading: controller.isLoading.value,
                  ),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
