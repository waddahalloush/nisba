import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BackCircleButton extends StatelessWidget {
  const BackCircleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: cs.primary,
                child: Icon(
                  Icons.arrow_back,
                  color: cs.surfaceContainerHighest,
                ),
              ),
            ),
          );
  }
}