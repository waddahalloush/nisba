import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

import '../login_controller.dart';

/// Top bar with skip button.
class LoginTopBar extends StatelessWidget {
  final LoginController controller;

  const LoginTopBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: EdgeInsets.only(top: 16.h),
      child: Row(
        children: [
          TextButton(
            onPressed: controller.skipLogin,
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            child: Text(
              'skip'.tr,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
