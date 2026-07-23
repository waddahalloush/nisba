import 'package:get/get.dart';

/// نموذج الخدمات والمنتجات المتاحة في الكشك
class KioskProduct {
  final String id;
  final String name;
  final String size;
  final double price; // السعر بالريال القطري
  final String category;
  final String imageUrl;
  final String description;

  const KioskProduct({
    required this.id,
    required this.name,
    required this.size,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.description,
  });
}

class KioksDetailsController extends GetxController {
  // ── الحالة التفاعلية ──
  final selectedTab = 'نبذة عن الكشك'.obs;
  final isLoading = false.obs;
  final selectedProductId = ''.obs;

  // ── معلومات الكشك (كشك قهوة "أوكتان") ──
  final kioskName = 'كشك قهوة "أوكتان"';
  final kioskSubTitle = 'مختص بالقهوة المختصة الباردة والساخنة والوجبات السريعة';
  final location = 'ممشى مارينا لوسيل، قطر';
  final double rating = 4.8; // التقييم من 5
  final int reviewsCount = 530; // عدد التقييمات
  final workingHours = '06:00 ص - 02:00 ص';

  // صور مباشرة من موقع Unsplash
  final coverImageUrl =
      'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?q=80&w=1000';
  final logoImageUrl =
      'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?q=80&w=300';

  // ── التبويبات الرئيسية ──
  final categories = <String>[
    'نبذة عن الكشك',
    'المنيو والتسعير',
    'المميزات',
    'ساعات العمل والتقييم',
  ];

  // ── البيانات الإحصائية للكارد المتداخل ──
  final kioskStats = <Map<String, String>>[
    {'title': 'التقييم', 'value': '4.8 ★', 'icon': 'star'},
    {'title': 'التقييمات', 'value': '530 تقييم', 'icon': 'like'},
    {'title': 'ساعات العمل', 'value': '06:00ص - 02:00ص', 'icon': 'clock'},
    {'title': 'الموقع', 'value': 'مارينا لوسيل', 'icon': 'location'},
  ];

  // ── 1. نبذة عن الكشك ──
  final aboutText =
      'يقع كشك قهوة "أوكتان" في موقع مميز للغاية على ممشى مارينا لوسيل الساحر. يقدم الكشك تجربة سريعة وفاخرة لعشاق القهوة المختصة، المشروبات المبتكرة، والوجبات الخفيفة الطازجة المجهزة خصيصاً لرياضيي ومُرتادي الممشى طوال اليوم.';

  final kioskHighlights = <String>[
    'تحضير بن حبوب القهوة المختصة العضوية 100%',
    'إطلالة مباشرة ورائعة على مرسى اليخات في لوسيل',
    'خدمة استلام سريعة مخصصة للمشاة ومرتادي الممشى',
    'خيارات حليب نباتي وحلويات خالية من الجلوتين',
  ];

  // ── 2. قائمة المنتجات والخدمات مع التسعير بالريال القطري (ر.ق) ──
  final products = <KioskProduct>[
    const KioskProduct(
      id: 'k1',
      name: 'سبانيش لاتيه بارد (Cold Spanish Latte)',
      size: 'وسط (Medium)',
      price: 26.0,
      category: 'قهوة باردة',
      imageUrl:
          'https://images.unsplash.com/photo-1517701604599-bb29b565090c?q=80&w=500',
      description: 'إسبريسو غني مع حليب مكثف محلى وثلج ناعم بالطريقة الخاصة.',
    ),
    const KioskProduct(
      id: 'k2',
      name: 'قهوة مقطرة V60 إثيوبية',
      size: 'كبير (Large)',
      price: 28.0,
      category: 'قهوة مختصة',
      imageUrl:
          'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?q=80&w=500',
      description: 'بن إثيوبي فاخر بإيحاءات الفواكه الاستوائية والشوكولاتة.',
    ),
    const KioskProduct(
      id: 'k3',
      name: 'وافل بلجيكي بصلصة الكراميل والبوظة',
      size: 'قطعة واحدة',
      price: 32.0,
      category: 'وجبات خفيفة',
      imageUrl:
          'https://images.unsplash.com/photo-1562376552-0d160a2f238d?q=80&w=500',
      description: 'وافل مقرمش ساخن يقدم مع الآيس كريم والصوص حسب الاختيار.',
    ),
    const KioskProduct(
      id: 'k4',
      name: 'عصير مايتشي ماتشا مثلج (Iced Matcha)',
      size: 'وسط (Medium)',
      price: 30.0,
      category: 'مشروبات باردة',
      imageUrl:
          'https://images.unsplash.com/photo-1536256263959-770b48d82b0a?q=80&w=500',
      description: 'شاي الماتشا الياباني الدرجة الأولى مع حليب الشوفان والثلج.',
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
    if (selectedProductId.value.isEmpty) return 26.0; // السعر الافتراضي للمنتج الأول
    final product = products.firstWhere((p) => p.id == selectedProductId.value);
    return product.price;
  }

  void buyNow() {
    Get.snackbar(
      'تأكيد الطلب',
      'تم إرسال طلب الشراء فوراً لكشك أوكتان! سيتم تحضير طلبك للاستلام مباشرة.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}