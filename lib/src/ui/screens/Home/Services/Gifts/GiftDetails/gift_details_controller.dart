import 'package:get/get.dart';

/// نموذج بيانات المنتج
class GiftProduct {
  final String id;
  final String name;
  final double price;
  final double rating;
  final String imageUrl;
  final String description;

  const GiftProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.imageUrl,
    required this.description,
  });
}

/// نموذج بيانات الخدمة
class ShopService {
  final String title;
  final String iconName;
  final List<GiftProduct> products;

  const ShopService({
    required this.title,
    required this.iconName,
    required this.products,
  });
}

class GiftDetailsController extends GetxController {
  // ── الحالة التفاعلية ──
  final selectedTab = 'باقات الأزهار'.obs;
  final isLoading = false.obs;

  // ── معلومات المتجر ──
  final shopName = 'فلورا أوركيد للزهور والهدايا';
  final shopSubTitle = 'أرقى أزهار الطبيعة وتنسيقات الهدايا الفاخرة';
  final location = 'شارع اللؤلؤة، الدوحة';
  final rating = 4.9;
  final reviewsCount = '412';
  final workingHours = '8:00 ص - 11:00 م';
  final deliveryTime = 'توصيل خلال 60 دقيقة';

  // صورة الغلاف المباشرة من Unsplash
  final coverImageUrl =
      'https://images.unsplash.com/photo-1526047932273-341f2a7631f9?q=80&w=1000';
  final logoImageUrl =
      'https://images.unsplash.com/photo-1563241527-3004b7be0ffd?q=80&w=300';

  // ── التصنيفات الرئيسية (Tabs) ──
  final categories = <String>[
    'باقات الأزهار',
    'تنسيقات التخرج',
    'هدايا المناسبات',
    'تنسيقات أعياد الميلاد',
    'الكيكات',
  ];

  // ── كروت معلومات الكارد المتداخل ──
  final shopStats = <Map<String, String>>[
    {'title': 'التوصيل', 'value': '60 دقيقة', 'icon': 'truck'},
    {'title': 'التقييم', 'value': '4.9 ★', 'icon': 'star'},
    {'title': 'الدوام', 'value': 'مفتوح الآن', 'icon': 'clock'},
    {'title': 'الجودة', 'value': 'أزهار طازجة', 'icon': 'award'},
  ];

  // ── أقسام الخدمات والمنتجات التابعة لها ──
  final services = <ShopService>[
    // 1. خدمة تنسيقات الزهور
    const ShopService(
      title: 'تنسيقات الزهور',
      iconName: 'flower',
      products: [
        GiftProduct(
          id: 'p1',
          name: 'بوكيه الرقي الملكي',
          price: 280.0,
          rating: 4.9,
          imageUrl:
              'https://images.unsplash.com/photo-1561181286-d3fee7d55364?q=80&w=500',
          description: 'تنسيق فاخر من الجوري الوردي والهيدرانجيا',
        ),
        GiftProduct(
          id: 'p2',
          name: 'فازة الأوركيد البيضاء',
          price: 350.0,
          rating: 5.0,
          imageUrl:
              'https://images.unsplash.com/photo-1582794543139-8ac9cb0f7b11?q=80&w=500',
          description: 'أوركيد طبيعي أنيق في فازة سيراميك راقية',
        ),
      ],
    ),

    // 2. خدمة أزهار الصيف
    const ShopService(
      title: 'أزهار الصيف',
      iconName: 'sun',
      products: [
        GiftProduct(
          id: 'p3',
          name: 'باقة عباد الشمس المشرقة',
          price: 190.0,
          rating: 4.8,
          imageUrl:
              'https://images.unsplash.com/photo-1508610048659-a06b669e3321?q=80&w=500',
          description: 'عباد شمس طبيعي يعكس دفء وحيوية الصيف',
        ),
        GiftProduct(
          id: 'p4',
          name: 'مزيج الصيف الملون',
          price: 230.0,
          rating: 4.7,
          imageUrl:
              'https://images.unsplash.com/photo-1490750967868-88aa4486c946?q=80&w=500',
          description: 'تشكيلة منعشة من أزهار الصيف البرية',
        ),
      ],
    ),

    // 3. خدمة بوكسات الضيافة
    const ShopService(
      title: 'بوكسات الضيافة',
      iconName: 'gift',
      products: [
        GiftProduct(
          id: 'p5',
          name: 'بوكس الضيافة الفاخر',
          price: 420.0,
          rating: 5.0,
          imageUrl:
              'https://images.unsplash.com/photo-1549465220-1a8b9238cd48?q=80&w=500',
          description: 'تنسيق ورد طبيعي مع شوكولاتة بلجيكية فاخرة',
        ),
        GiftProduct(
          id: 'p6',
          name: 'صندوق الهدايا والأزهار',
          price: 380.0,
          rating: 4.9,
          imageUrl:
              'https://images.unsplash.com/photo-1513201099705-a9746e1e201f?q=80&w=500',
          description: 'علبة هدايا أنيقة محاطة بالزهور الطبيعية',
        ),
      ],
    ),

    // 4. خدمة كيك ديزاين
    const ShopService(
      title: 'كيك ديزاين',
      iconName: 'cake',
      products: [
        GiftProduct(
          id: 'p7',
          name: 'كيكة الأزهار المخملية',
          price: 310.0,
          rating: 4.9,
          imageUrl:
              'https://images.unsplash.com/photo-1578985545062-69928b1d9587?q=80&w=500',
          description: 'كيكة احترافية مغطاة بتفاصيل ورد طبيعي قابل للأكل',
        ),
        GiftProduct(
          id: 'p8',
          name: 'كيكة الاحتفالات الخاصة',
          price: 290.0,
          rating: 4.8,
          imageUrl:
              'https://images.unsplash.com/photo-1535141192574-5d4897c13136?q=80&w=500',
          description: 'تصميم مبتكر بنكهة الفانيليا والفواكه الطازجة',
        ),
      ],
    ),
  ];

  void selectTab(String category) {
    selectedTab.value = category;
  }
}
