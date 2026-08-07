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
      subtitle: 'استكشف الأكشاك والمتاجر السريعة القريبة منك',
      searchHint: 'ابحث في $name...',
    );
  }
}
