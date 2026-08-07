import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

import '../login_controller.dart';

/// Phone number input field with country code picker.
class LoginPhoneField extends StatelessWidget {
  final LoginController controller;

  const LoginPhoneField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final primaryColor = theme.colorScheme.primary;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: IntlPhoneField(
        controller: controller.phoneController,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: 'phone_number_hint'.tr,
          hintStyle: textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
          ),
          filled: true,
          fillColor: theme.colorScheme.surface,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(color: primaryColor, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(color: primaryColor, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(color: primaryColor, width: 2.0),
          ),
        ),
        initialCountryCode: 'QA',
        disableLengthCheck: true,
        dropdownIconPosition: IconPosition.trailing,
        dropdownIcon: Icon(
          Icons.keyboard_arrow_down,
          color: theme.colorScheme.onSurface,
        ),
        style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
        onChanged: (phone) {
          controller.phoneNumber.value = phone.number;
          controller.countryCode.value = phone.countryCode.replaceAll('+', '');
        },
        onCountryChanged: (country) {
          controller.countryCode.value = country.dialCode.replaceAll('+', '');
        },
      ),
    );
  }
}
