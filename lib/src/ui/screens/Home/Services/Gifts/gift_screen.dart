// استدعاء مباشر لشاشة الهدايا بكود من سطر واحد!
import '../Base Service/base_service_screen.dart';
import 'gift_controller.dart';

class GiftScreen extends BaseServiceScreen<GiftController> {
  const GiftScreen({super.key})
    : super(
        title: 'الهدايا، الألعاب والإكسسوارات',
        subtitle:
            'اعثر على أجمل متاجر التذكارات، تنسيق وتغليف الهدايا وألعاب الأطفال في قطر',
        searchHint: 'ابحث عن متجر هدايا، ألعاب أو محل تغليف...',
      );
}
