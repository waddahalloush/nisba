import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

import 'add_visa_controller.dart';

class AddVisaScreen extends GetView<AddVisaController> {
  const AddVisaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: cs.surfaceContainerHighest,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Iconsax.arrow_right_1, color: cs.onSurface),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'إضافة بطاقة Visa',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'أضف بيانات بطاقتك لإجراء مدفوعات آمنة وسريعة',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.5),
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
        ),
        body: Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 8.h),

                // ── Visa card preview ──
                _buildCardPreview(theme),

                SizedBox(height: 20.h),

                // ── Name field ──
                _buildFieldLabel(theme, 'الاسم *'),
                SizedBox(height: 8.h),
                _buildTextField(
                  theme,
                  controller: controller.nameController,
                  hint: 'الاسم كما هو على البطاقة',
                  icon: Iconsax.user,
                  validator: (v) => v!.isEmpty ? 'الاسم مطلوب' : null,
                ),

                SizedBox(height: 16.h),

                // ── Card number field ──
                _buildFieldLabel(theme, 'رقم البطاقة *'),
                SizedBox(height: 8.h),
                _buildTextField(
                  theme,
                  controller: controller.cardNumberController,
                  hint: 'رقم البطاقة',
                  icon: Iconsax.card,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(16),
                  ],
                  suffixIcon: Obx(
                    () => IconButton(
                      onPressed: controller.toggleCardMask,
                      icon: Icon(
                        controller.isCardNumberMasked.value
                            ? Iconsax.eye_slash
                            : Iconsax.eye,
                        color: cs.onSurface.withValues(alpha: 0.4),
                        size: 18.sp,
                      ),
                    ),
                  ),
                  isObscured: controller.isCardNumberMasked,
                  validator: (v) {
                    if (v!.isEmpty) return 'رقم البطاقة مطلوب';
                    if (v.replaceAll(RegExp(r'\s'), '').length < 16) {
                      return 'رقم البطاقة غير صحيح';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16.h),

                // ── Expiry + CVV row ──
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel(theme, 'التاريخ *'),
                          SizedBox(height: 8.h),
                          _buildTextField(
                            theme,
                            controller: controller.expiryController,
                            hint: 'MM/YY',
                            icon: Iconsax.calendar_1,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
                            validator: (v) {
                              if (v!.isEmpty) return 'مطلوب';
                              if (v.length < 4) return 'غير صحيح';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _buildFieldLabel(theme, 'الرمز *'),
                              SizedBox(width: 4.w),
                              Icon(
                                Iconsax.info_circle,
                                color: cs.onSurface.withValues(alpha: 0.35),
                                size: 12.sp,
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          _buildTextField(
                            theme,
                            controller: controller.cvvController,
                            hint: 'CVV',
                            icon: Iconsax.lock,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3),
                            ],
                            suffixIcon: Obx(
                              () => IconButton(
                                onPressed: controller.toggleCvvMask,
                                icon: Icon(
                                  controller.isCvvMasked.value
                                      ? Iconsax.eye_slash
                                      : Iconsax.eye,
                                  color: cs.onSurface.withValues(alpha: 0.4),
                                  size: 18.sp,
                                ),
                              ),
                            ),
                            isObscured: controller.isCvvMasked,
                            validator: (v) {
                              if (v!.isEmpty) return 'مطلوب';
                              if (v.length < 3) return 'غير صحيح';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 32.h),

                // ── Submit button ──
                SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed: controller.addCard,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    child: Text(
                      'إضافة',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16.h),

                // ── Security note ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Iconsax.shield_tick,
                      color: cs.onSurface.withValues(alpha: 0.35),
                      size: 14.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'بياناتك محمية ومشفرة بالكامل',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: cs.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardPreview(ThemeData theme) {
    final cs = theme.colorScheme;

    return Container(
      width: double.infinity,
      height: 180.h,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cs.primary, cs.primary.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ── Top row: chip + Visa logo ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40.w,
                height: 28.h,
                decoration: BoxDecoration(
                  color: cs.onPrimary.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
              Text(
                'VISA',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: cs.onPrimary,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),

          // ── Card number ──
          Obx(
            () => Text(
              controller.isCardNumberMasked.value
                  ? '•••• •••• •••• ••••'
                  : _formatCardNumber(controller.cardNumberController.text),
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: cs.onPrimary,
                letterSpacing: 3,
              ),
            ),
          ),

          // ── Bottom row: name + expiry ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  controller.nameController.text.isEmpty
                      ? 'الاسم على البطاقة'
                      : controller.nameController.text.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: cs.onPrimary.withValues(alpha: 0.85),
                    letterSpacing: 1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                controller.expiryController.text.isEmpty
                    ? 'MM/YY'
                    : controller.expiryController.text,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: cs.onPrimary.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatCardNumber(String input) {
    final digits = input.replaceAll(RegExp(r'\s'), '');
    if (digits.isEmpty) return '•••• •••• •••• ••••';
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  Widget _buildFieldLabel(ThemeData theme, String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.onSurface,
      ),
    );
  }

  Widget _buildTextField(
    ThemeData theme, {
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    Widget? suffixIcon,
    RxBool? isObscured,
    String? Function(String?)? validator,
  }) {
    final cs = theme.colorScheme;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      obscureText: isObscured?.value ?? false,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: cs.onSurface,
        letterSpacing: isObscured != null ? 2 : 0,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: cs.onSurface.withValues(alpha: 0.3),
          fontSize: 13.sp,
        ),
        filled: true,
        fillColor: cs.surface,
        prefixIcon: Container(
          margin: EdgeInsets.all(10.r),
          child: Icon(icon, color: cs.primary, size: 20.sp),
        ),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: cs.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: cs.error),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      ),
    );
  }
}
