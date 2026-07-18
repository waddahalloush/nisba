// استدعاء مباشر لشاشة الترفيه بكود من سطر واحد!
import 'package:nisba_app/src/ui/screens/Home/Services/Base%20Service/base_service_screen.dart';

import 'entertainment_controller.dart';

class EntertainmentScreen extends BaseServiceScreen<EntertainmentController> {
  const EntertainmentScreen({super.key})
    : super(
        title: 'الترفيه والتسلية في قطر',
        subtitle:
            'اكتشف أفضل المدن الترفيهية، الحدائق المائية والملاهي القريبة منك',
        searchHint: 'ابحث عن مدينة ألعاب أو وجهة ترفيهية...',
      );
}
