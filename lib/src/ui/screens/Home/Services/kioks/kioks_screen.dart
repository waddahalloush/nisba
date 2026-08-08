import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../BaseService/base_service_screen.dart';
import 'kioks_controller.dart';

class KioskScreen extends StatelessWidget {
  const KioskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KioskController>();
    final name = controller.sectionName;

    return BaseServiceScreen<KioskController>(
      title: name,
      subtitle: 'auto_key_384'.tr,
      searchHint: 'auto_key_385'.tr,
    );
  }
}
