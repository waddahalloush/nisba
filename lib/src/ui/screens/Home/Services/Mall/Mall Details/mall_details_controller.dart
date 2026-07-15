import 'package:get/get.dart';

/// Data model for a featured restaurant.
class FeaturedRestaurant {
  final String name;
  final String imageUrl;
  final double rating;

  const FeaturedRestaurant({
    required this.name,
    required this.imageUrl,
    required this.rating,
  });
}

/// Data model for a featured store.
class FeaturedStore {
  final String name;
  final String imageUrl;

  const FeaturedStore({required this.name, required this.imageUrl});
}

class MallDetailsController extends GetxController {
  // ── Reactive state ──
  final selectedTab = 'نظرة عامة'.obs;
  final isLoading = false.obs;

  // ── Mall info ──
  final mallName = 'جلف مول';
  final address = 'منطقة الخليج الغربي، الدوحة';
  final locationDetail = 'شارع الخليج الغربي، الدوحة';
  final rating = 4.4;
  final stars = 5;
  final workingHours = '10:00 ص - 11:00 م';
  final storesCount = '300+';
  final hasFreeParking = true;

  final aboutText =
      'جلف مول هو واحد من أكبر وأفخم مراكز التسوق في قطر، ويقع في منطقة الخليج '
      'الغربي بالدوحة. يضم المول أكثر من 300 متجر عالمي ومحلي، بالإضافة إلى مجموعة '
      'واسعة من المطاعم والمقاهي. يوفر المول تجربة تسوق فريدة تجمع بين العلامات '
      'التجارية الفاخرة والمرافق الترفيهية المتنوعة، مما يجعله وجهة مثالية للعائلات '
      'والزوار من جميع الأعمار.';

  // ── Tabs ──
  final tabs = <String>[
    'نظرة عامة',
    'العروض والفعاليات',
    'الترفيه',
    'المطاعم',
    'المتاجر',
  ];

  // ── Info cards ──
  final infoCards = <_InfoCard>[
    const _InfoCard(
      title: 'ساعات العمل',
      value: '10:00 ص - 11:00 م',
      iconLabel: 'ساعات العمل',
    ),
    const _InfoCard(
      title: 'الموقع',
      value: 'شارع الخليج الغربي، الدوحة',
      iconLabel: 'الموقع',
    ),
    const _InfoCard(title: '300+ متجر', value: 'تسوق', iconLabel: 'تسوق'),
    const _InfoCard(
      title: 'مواقف مجانية',
      value: 'توفر مواقف',
      iconLabel: 'توفر مواقف',
    ),
  ];

  // ── Action buttons ──
  final actions = <String>[
    'خدمة العملاء',
    'خريطة المول',
    'العروض والفعاليات',
    'الوصول للمول',
  ];

  // ── Featured restaurants ──
  final featuredRestaurants = <FeaturedRestaurant>[
    const FeaturedRestaurant(name: 'KFC', imageUrl: '', rating: 4.2),
    const FeaturedRestaurant(name: 'ماكدونالدز', imageUrl: '', rating: 4.0),
    const FeaturedRestaurant(name: 'شاي ورد', imageUrl: '', rating: 4.5),
    const FeaturedRestaurant(
      name: 'ذا تشيز كيك فاكتوري',
      imageUrl: '',
      rating: 4.3,
    ),
  ];

  // ── Featured stores ──
  final featuredStores = <FeaturedStore>[
    const FeaturedStore(name: 'Zara', imageUrl: ''),
    const FeaturedStore(name: 'سيفورا', imageUrl: ''),
    const FeaturedStore(name: 'Apple', imageUrl: ''),
    const FeaturedStore(name: 'Nike', imageUrl: ''),
  ];

  // ── Facilities ──
  final facilities = <String>[
    'مصاعد',
    'منطقة أطفال',
    'واي فاي مجاني',
    'غرفة صلاة',
    'دورات مياه',
  ];

  void selectTab(String tab) {
    selectedTab.value = tab;
  }
}

/// Internal model for info cards.
class _InfoCard {
  final String title;
  final String value;
  final String iconLabel;

  const _InfoCard({
    required this.title,
    required this.value,
    required this.iconLabel,
  });
}
