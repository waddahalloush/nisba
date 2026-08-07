import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../login_controller.dart';

/// "Don't have an account? Create one" row.
class LoginBottomRegister extends StatelessWidget {
  final LoginController controller;

  const LoginBottomRegister({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final primaryColor = theme.colorScheme.primary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'dont_have_account'.tr,
          style: textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        GestureDetector(
          onTap: controller.navigateToRegister,
          child: Text(
            'create_account'.tr,
            style: textTheme.bodyMedium?.copyWith(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationColor: primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
