import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../BaseService/base_service_screen.dart';
import 'service_section_controller.dart';

/// List of service vendors for a home `service_sections` item.
class ServiceSectionScreen extends StatelessWidget {
  const ServiceSectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ServiceSectionController>();
    final name = controller.sectionName;

    return BaseServiceScreen<ServiceSectionController>(
      title: name,
      subtitle: 'اكتشف أفضل $name القريبة منك',
      searchHint: 'ابحث في $name...',
    );
  }
}
