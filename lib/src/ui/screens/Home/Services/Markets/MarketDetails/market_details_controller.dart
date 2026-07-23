import 'package:get/get.dart';

/// نموذج المنتجات والمجوهرات المتاحة في الماركت
class MarketProduct {
  final String id;
  final String name;
  final String specification;
  final double price; // السعر بالريال القطري
  final String category;
  final String imageUrl;
  final String description;

  const MarketProduct({
    required this.id,
    required this.name,
    required this.specification,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.description,
  });
}

class MarketDetailsController extends GetxController {
  // ── الحالة التفاعلية ──
  final selectedTab = 'نبذة عن السوق'.obs;
  final isLoading = false.obs;
  final selectedProductId = ''.obs;

  // ── معلومات الماركت (سوق الذهب بالدوحة) ──
  final marketName = 'سوق الذهب بالدوحة';
  final marketSubTitle = 'أفخم تصاميم الذهب والمجوهرات واللؤلؤ الطبيعي ورش معتمدة';
  final location = 'بجانب سوق واقف، الدوحة';
  final double rating = 4.9; // التقييم من 5
  final int reviewsCount = 840; // عدد التقييمات
  final workingHours = '09:00 ص - 10:00 م';

  // صور مباشرة عالية الجودة من موقع Unsplash
  final coverImageUrl =
      'https://images.unsplash.com/photo-1721807644561-9efcabee5c42?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fGdvbGQlMjBqZXdlbGxlcnl8ZW58MHx8MHx8fDA%3D';
  final logoImageUrl =
      'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?q=80&w=300';

  // ── التبويبات الرئيسية ──
  final categories = <String>[
    'نبذة عن السوق',
    'المنتجات والأسعار',
    'المميزات',
    'ساعات العمل والتقييم',
  ];

  // ── البيانات الإحصائية للكارد المتداخل ──
  final marketStats = <Map<String, String>>[
    {'title': 'التقييم', 'value': '4.9 ★', 'icon': 'star'},
    {'title': 'التقييمات', 'value': '840 تقييم', 'icon': 'like'},
    {'title': 'ساعات العمل', 'value': '09:00ص - 10:00م', 'icon': 'clock'},
    {'title': 'الموقع', 'value': 'سوق واقف', 'icon': 'location'},
  ];

  // ── 1. نبذة عن الماركت ──
  final aboutText =
      'يُعد سوق الذهب بالدوحة واحداً من أعرق وأشهر الأسواق المتخصصة في دولة قطر. يضم أحدث أطقم الذهب والمجوهرات واللؤلؤ الطبيعي، مع وجود ورش فحص وصياغة معتمدة تضمن أعلى مستويات الجودة والضمان لجميع الزوار والمشترين.';

  final marketHighlights = <String>[
    'ورش فحص وصياغة معتمدة رسمياً من الجهات المختصة',
    'تشكيلة واسعة من الذهب عيار 18، 21، و22 والسبائك الاستثمارية',
    'تصاميم تراثية قطرية أصيلة بأسعار تنافسية',
    'موقع استراتيجي بالقرب من سوق واقف وسهل الوصول إليه',
  ];

  // ── 2. قائمة المنتجات المتاحة مع التسعير بالريال القطري (ر.ق) ──
  final products = <MarketProduct>[
    const MarketProduct(
      id: 'm1',
      name: 'طقم ذهب تراثي عيار 21 (طاسات ومرعشة)',
      specification: 'وزن 45 غرام - عيار 21',
      price: 11250.0,
      category: 'أطقم تراثية',
      imageUrl:
          'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?q=80&w=500',
      description: 'طقم ذهب خليجي تراثي مصمم بدقة عالية ومزين بالنقوش العربية الأصيلة.',
    ),
    const MarketProduct(
      id: 'm2',
      name: 'سبيكة ذهب سويسري صَافية 999.9',
      specification: 'وزن 10 غرامات - عيار 24',
      price: 2850.0,
      category: 'سبائك واستثمار',
      imageUrl:
          'https://images.unsplash.com/photo-1610375461246-83df859d849d?q=80&w=500',
      description: 'سبيكة ذهب استثمارية نقية ومغلفة بغلاف أمان مع رقم تسلسلي معتمد.',
    ),
    const MarketProduct(
      id: 'm3',
      name: 'خاتم ألماس نقي مع لؤلؤ طبيعي قطري',
      specification: 'ذهب أبيض - عيار 18',
      price: 4500.0,
      category: 'مجوهرات وألماس',
      imageUrl:
          'https://images.unsplash.com/photo-1605100804763-247f67b3557e?q=80&w=500',
      description: 'خاتم راقٍ مرصع بقطع الألماس النقي ويتوسطه لؤلؤة طبيعية مميزة.',
    ),
    const MarketProduct(
      id: 'm4',
      name: 'سوار ذهب عيار 21 (حيول قطرية)',
      specification: 'وزن 20 غرام - عيار 21',
      price: 5100.0,
      category: 'أساور وخواتم',
      imageUrl:
          'https://images.unsplash.com/photo-1569397288884-4d43d6738fbd?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTJ8fGdvbGQlMjBqZXdlbGxlcnl8ZW58MHx8MHx8fDA%3D',
      description: 'سوار ذهبي كلاسيكي بتفاصيل دقيقة يناسب المناسبات والهدايا الفاخرة.',
    ),
  ];

  void selectTab(String category) {
    selectedTab.value = category;
  }

  void selectProduct(String productId) {
    if (selectedProductId.value == productId) {
      selectedProductId.value = '';
    } else {
      selectedProductId.value = productId;
    }
  }

  double get totalPrice {
    if (selectedProductId.value.isEmpty) return products.first.price;
    final product = products.firstWhere((p) => p.id == selectedProductId.value);
    return product.price;
  }

  void buyNow() {
    Get.snackbar(
      'تأكيد الطلب',
      'تم إرسال طلب الشراء لسوق الذهب بنجاح! سيتم التواصل معك لإتمام الشراء والتحقق.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}