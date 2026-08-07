import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/data/models/Home/home_model.dart';
import 'package:nisba_app/src/ui/screens/Home/Services/BaseService/base_service_screen.dart';

import 'mall_controller.dart';

class MallScreen extends StatelessWidget {
  const MallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final section = _sectionFromArgs();
    final name = section?.name.isNotEmpty == true ? section!.name : 'مولات';
    return BaseServiceScreen<MallController>(
      title: name,
      subtitle: 'اكتشف أفضل $name القريبة منك — ثم تصفّح المتاجر داخل كل مول',
      searchHint: 'ابحث عن مول...',
    );
  }

  Section? _sectionFromArgs() {
    final args = Get.arguments;
    if (args is Map && args['section'] is Section) {
      return args['section'] as Section;
    }
    return null;
  }
}
