import 'package:nisba_app/src/ui/screens/Home/Services/Base Service/base_service_screen.dart';

import 'mall_controller.dart';

class MallScreen extends BaseServiceScreen<MallController> {
  const MallScreen({super.key})
    : super(
        title: 'مولات',
        subtitle: 'اكتشف افضل المولات القريبة منك',
        searchHint: 'ابحث عن مول...',
      );
}
