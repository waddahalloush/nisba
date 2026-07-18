import 'package:nisba_app/src/ui/screens/Home/Services/Tourism/tourism_controller.dart';

import '../Base Service/base_service_screen.dart';

class TourismScreen extends BaseServiceScreen<TourismController> {
  const TourismScreen({super.key})
    : super(
        title: 'السياحة والمعالم السياحية',
        subtitle:
            'اكتشف جمال قطر التاريخي والحديث، متاحفها الفخمة وحدائقها الخلابة',
        searchHint: 'ابحث عن معلم، متحف، حديقة أو شاطئ...',
      );
}
