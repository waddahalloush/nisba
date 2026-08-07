import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/data/models/Home/home_model.dart';
import 'package:nisba_app/src/ui/screens/Home/Services/BaseService/base_service_screen.dart';

import 'commercial_center_controller.dart';

class CommercialCenterScreen extends StatelessWidget {
  const CommercialCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final section = _sectionFromArgs();
    final name =
        section?.name.isNotEmpty == true ? section!.name : 'مراكز تجارية';
    return BaseServiceScreen<CommercialCenterController>(
      title: name,
      subtitle: 'اكتشف $name القريبة — ثم تصفّح المتاجر داخل كل مركز',
      searchHint: 'ابحث عن مركز تجاري...',
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
