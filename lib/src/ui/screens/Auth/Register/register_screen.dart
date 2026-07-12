import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

import '../widgets/app_primary_button.dart';
import 'register_controller.dart';

class RegisterScreen extends GetView<RegisterController> {
  const RegisterScreen({super.key});

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
            child: Form(
              key: controller.formKey,
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
                  SizedBox(height: 12.h),

                  // ── Header with profile icon ──
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 64.w,
                        height: 64.h,
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person_outline_rounded,
                          color: primaryColor,
                          size: 36,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'register_personal_info_title'.tr,
                              style: textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                                fontSize: 18.sp,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              'register_personal_info_subtitle'.tr,
                              style: textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.55,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 36.h),

                  // ── First name field ──
                  _buildLabel(context, 'first_name_label'.tr),
                  _buildTextField(
                    context: context,
                    controller: controller.firstNameController,
                    hint: 'first_name_hint'.tr,
                    icon: Icons.person_outline_rounded,
                    textInputAction: TextInputAction.next,
                    validator: (v) => v!.isEmpty ? 'name_is_required'.tr : null,
                  ),
                  SizedBox(height: 20.h),

                  // ── Last name field ──
                  _buildLabel(context, 'last_name_label'.tr),
                  _buildTextField(
                    context: context,
                    controller: controller.lastNameController,
                    hint: 'last_name_hint'.tr,
                    icon: Icons.person_outline_rounded,
                    textInputAction: TextInputAction.next,
                    validator: (v) => v!.isEmpty ? 'name_is_required'.tr : null,
                  ),
                  SizedBox(height: 20.h),

                  // ── Email field ──
                  _buildLabel(context, 'email_label'.tr),
                  _buildTextField(
                    context: context,
                    controller: controller.emailController,
                    hint: 'email_hint'.tr,
                    icon: Icons.mail_outline_rounded,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (v) {
                      if (v!.isEmpty) return 'email_is_required'.tr;
                      if (!GetUtils.isEmail(v)) {
                        return 'enter_a_valid_email'.tr;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.h),

                  // ── Date of birth field ──
                  _buildLabel(context, 'date_of_birth_label'.tr),
                  Obx(
                    () => _buildDateField(
                      context: context,
                      hint: 'date_hint'.tr,
                      value: controller.formattedDate.isEmpty
                          ? null
                          : controller.formattedDate,
                      icon: Icons.calendar_today_outlined,
                      onTap: () => controller.pickDate(context),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // ── Gender selection ──
                  _buildLabel(context, 'gender_label'.tr),
                  _buildGenderSection(context),
                  SizedBox(height: 40.h),

                  // ── Next button ──
                  Obx(
                    () => AppPrimaryButton(
                      label: 'next'.tr,
                      onPressed: controller.onNext,
                      isLoading: controller.isLoading.value,
                    ),
                  ),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String text) {
    final theme = Theme.of(context);
    final isMandatory = text.contains('*');
    final cleanText = text.replaceAll('*', '').trim();

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, right: 4.w),
      child: RichText(
        text: TextSpan(
          text: cleanText,
          style: context.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface,
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
          ),
          children: [
            if (isMandatory)
              TextSpan(
                text: ' *',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputAction? textInputAction,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return TextFormField(
      controller: controller,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
          fontSize: 14,
        ),
        suffixIcon: Icon(icon, size: 24.w, color: primaryColor),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.4,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(
            color: theme.colorScheme.outlineVariant,
            width: 1.2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: theme.colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDateField({
    required BuildContext context,
    required String hint,
    required String? value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(
            alpha: 0.4,
          ),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: theme.colorScheme.outlineVariant,
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value ?? hint,
                style: TextStyle(
                  fontSize: 14,
                  color: value != null
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.onSurface.withValues(alpha: 0.45),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Icon(icon, size: 24.w, color: primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderSection(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(
      () => Row(
        children: [
          Expanded(
            child: _GenderOption(
              label: 'male'.tr,
              biologicalIcon: Icons.male_rounded,
              isSelected: controller.selectedGender.value == 'male',
              onTap: () => controller.selectGender('male'),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: _GenderOption(
              label: 'female'.tr,
              biologicalIcon: Icons.female_rounded,
              isSelected: controller.selectedGender.value == 'female',
              onTap: () => controller.selectGender('female'),
            ),
          ),
        ],
      ),
    );
  }
}

class _GenderOption extends StatelessWidget {
  final String label;
  final IconData biologicalIcon;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderOption({
    required this.label,
    required this.biologicalIcon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected ? primaryColor : theme.colorScheme.outlineVariant,
            width: isSelected ? 1.5 : 1.2,
          ),
        ),
        child: Row(
          children: [
            Icon(biologicalIcon, size: 24, color: primaryColor),
            Expanded(
              child: Text(
                label,
                style: context.theme.textTheme.labelLarge?.copyWith(
                  color: primaryColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? primaryColor : theme.colorScheme.outline,
                  width: isSelected ? 5.5 : 1.5,
                ),
                color: theme.colorScheme.surface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
