import '../Base Service/base_service_screen.dart';
import 'hotel_controller.dart';

class HotelScreen extends BaseServiceScreen<HotelController> {
  const HotelScreen({super.key})
    : super(
        title: 'الفنادق والمنتجعات',
        subtitle:
            'احجز مكان إقامتك المثالي بين أفخم فنادق الـ 5 نجوم، المنتجعات الشاطئية، والشقق الفندقية العائلية في قطر',
        searchHint: 'ابحث عن فندق، منتجع، أو شقة فندقية...',
      );
}
