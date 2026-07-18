import '../Base Service/base_service_screen.dart';
import 'beauty_controller.dart';

class BeautyScreen extends BaseServiceScreen<BeautyController> {
  const BeautyScreen({super.key})
    : super(
        title: 'التجميل والعناية في قطر',
        subtitle:
            'احجز موعدك في أرقى الصالونات النسائية والرجالية، مراكز السبا والاسترخاء، ومحلات التجميل الفاخرة',
        searchHint: 'ابحث عن صالون، مركز سبا، أو محل تجميل...',
      );
}
