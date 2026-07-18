import 'package:nisba_app/src/ui/screens/Home/Services/Markets/market_controller.dart';

import '../Base Service/base_service_screen.dart';

class MarketScreen extends BaseServiceScreen<MarketController> {
  const MarketScreen({super.key})
    : super(
        title: 'الأسواق والتجارة في قطر',
        subtitle:
            'استكشف الأسواق الشعبية العريقة، أسواق الجملة، الشوارع التجارية النابضة بالنشاط والأسواق المتخصصة',
        searchHint: 'ابحث عن سوق، شارع تجاري أو مركز جملة...',
      );
}
