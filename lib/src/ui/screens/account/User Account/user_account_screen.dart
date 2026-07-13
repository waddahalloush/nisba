import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/generated/assets.gen.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

import 'user_account_controller.dart';

class UserAccountScreen extends GetView<UserAccountController> {
  const UserAccountScreen({super.key});

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
                'معلومات الحساب',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'قم بتحديث معلوماتك الشخصية',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.5),
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
              children: [
                SizedBox(height: 16.h),

                // ── Avatar with edit badge ──
                _buildAvatar(theme),

                SizedBox(height: 24.h),

                // ── Input fields ──
                _buildInputCard(
                  theme,
                  label: 'الاسم الأول',
                  controller: controller.firstNameController,
                  icon: Iconsax.user,
                  validator: (v) => v!.isEmpty ? 'الاسم الأول مطلوب' : null,
                ),
                SizedBox(height: 12.h),

                _buildInputCard(
                  theme,
                  label: 'اسم العائلة',
                  controller: controller.lastNameController,
                  icon: Iconsax.user,
                  validator: (v) => v!.isEmpty ? 'اسم العائلة مطلوب' : null,
                ),
                SizedBox(height: 12.h),

                _buildInputCard(
                  theme,
                  label: 'البريد الإلكتروني',
                  controller: controller.emailController,
                  icon: Iconsax.sms,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v!.isEmpty) return 'البريد الإلكتروني مطلوب';
                    if (!GetUtils.isEmail(v)) {
                      return 'أدخل بريدًا صحيحًا';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12.h),

                // ── Birth date ──
                _buildDateCard(theme),
                SizedBox(height: 12.h),

                // ── Gender selector ──
                _buildGenderCard(theme),
                SizedBox(height: 32.h),

                // ── Save button ──
                _buildSaveButton(theme),

                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(ThemeData theme) {
    final cs = theme.colorScheme;

    return Center(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: cs.primary, width: 3),
            ),
            child: CircleAvatar(
              radius: 40.r,
              backgroundColor: cs.primary.withValues(alpha: 0.08),
              backgroundImage: Assets.images.appIcon.provider(),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: 28.w,
              height: 28.h,
              decoration: BoxDecoration(
                color: cs.primary,
                shape: BoxShape.circle,
                border: Border.all(color: cs.surface, width: 2),
              ),
              child: Icon(Iconsax.edit_2, color: cs.onPrimary, size: 14.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputCard(
    ThemeData theme, {
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    final cs = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: cs.primary, size: 18.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              validator: validator,
              style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurface),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.45),
                  fontSize: 12.sp,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateCard(ThemeData theme) {
    final cs = theme.colorScheme;

    return Obx(
      () => GestureDetector(
        onTap: controller.pickBirthDate,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: cs.shadow.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 36.w,
                height: 36.h,
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Iconsax.calendar_1, color: cs.primary, size: 18.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تاريخ الميلاد',
                      style: TextStyle(
                        color: cs.onSurface.withValues(alpha: 0.45),
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      controller.birthDate.value,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderCard(ThemeData theme) {
    final cs = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16.r),
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
            'الجنس',
            style: TextStyle(
              color: cs.onSurface.withValues(alpha: 0.45),
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 10.h),
          Obx(
            () => Row(
              children: [
                Expanded(
                  child: _GenderOption(
                    label: 'ذكر',
                    isSelected: controller.selectedGender.value == 'ذكر',
                    onTap: () => controller.selectGender('ذكر'),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _GenderOption(
                    label: 'أنثى',
                    isSelected: controller.selectedGender.value == 'أنثى',
                    onTap: () => controller.selectGender('أنثى'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(ThemeData theme) {
    final cs = theme.colorScheme;

    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        onPressed: controller.save,
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: Text(
          'تم',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _GenderOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? cs.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? cs.primary : cs.outlineVariant,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? cs.onPrimary
                : cs.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }
}
