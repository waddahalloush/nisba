
import '../Base Service/base_service_screen.dart';
import 'kioks_controller.dart';

class KioskScreen extends BaseServiceScreen<KioskController> {
  const KioskScreen({super.key})
      : super(
          title: 'الأكشاك السريعة (Kiosks)',
          subtitle: 'استكشف أكشاك القهوة المختصة، الوجبات الخفيفة، نقاط المعلومات والخدمات السريعة في قطر',
          searchHint: 'ابحث عن كشك قهوة، وجبات خفيفة أو كشك خدمات...',
        );
}