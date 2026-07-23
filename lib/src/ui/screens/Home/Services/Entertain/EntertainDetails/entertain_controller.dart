import 'package:get/get.dart';

/// نموذج بيانات اللعبة / التجربة الترفيهية
class EntertainItem {
  final String id;
  final String name;
  final double price;
  final double rating;
  final String imageUrl;
  final String description;

  const EntertainItem({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.imageUrl,
    required this.description,
  });
}

/// نموذج بيانات خدمة الترفيه
class EntertainService {
  final String title;
  final String iconName;
  final List<EntertainItem> items;

  const EntertainService({
    required this.title,
    required this.iconName,
    required this.items,
  });
}

class EntertainDetailsController extends GetxController {
  // ── الحالة التفاعلية ──
  final selectedTab = 'الكل'.obs;
  final isLoading = false.obs;

  // ── معلومات مركز الترفيه ──
  final centerName = 'مدينة ألعاب دوحة كويست';
  final centerSubTitle = 'أحدث مدينة ألعاب مغلقة تجريدية في قطر';
  final location = 'واحة الدوحة، مشيرب، الدوحة';
  final rating = 4.9;
  final reviewsCount = '523';
  final workingHours = '02:00 م - 10:00 م';

  // صور مباشرة من Unsplash
  final coverImageUrl =
      'https://images.unsplash.com/photo-1513889961551-628c1e5e2ee9?q=80&w=1000';
  final logoImageUrl =
      'https://images.unsplash.com/photo-1511512578047-dfb367046420?q=80&w=300';

  // ── التصنيفات الرئيسية (Tabs) ──
  final categories = <String>[
    'الكل',
    'ألعاب حماسية',
    'تجارب VR',
    'ألعاب مائية',
    'عروض عائلية',
    'ألعاب أطفال',
  ];

  // ── كروت معلومات الكارد المتداخل ──
  final centerStats = <Map<String, String>>[
    {'title': 'الألعاب', 'value': '+30 لعبة', 'icon': 'game'},
    {'title': 'التقييم', 'value': '4.9 ★', 'icon': 'star'},
    {'title': 'الدوام', 'value': '2 م - 10 م', 'icon': 'clock'},
    {'title': 'العمر', 'value': 'لكل الأعمار', 'icon': 'user'},
  ];

  // ── أقسام الخدمات والفعاليات التابعة لمركز الترفيه ──
  final services = <EntertainService>[
    // 1. خدمة الألعاب الأفعوانية والتحدي
    const EntertainService(
      title: 'الألعاب الأفعوانية والتحدي',
      iconName: 'flash',
      items: [
        EntertainItem(
          id: 'e1',
          name: 'أفعوانية العاصفة المغلقة',
          price: 150.0,
          rating: 4.9,
          imageUrl:
              'https://images.unsplash.com/photo-1541256942802-7b29531f0df8?q=80&w=500',
          description: 'أسرع أفعوانية مغلقة مع تحليق رأسي حماسي',
        ),
        EntertainItem(
          id: 'e2',
          name: 'برج السقوط الحر',
          price: 120.0,
          rating: 4.8,
          imageUrl:
              'https://images.unsplash.com/photo-1502136969935-8d8eef54d77b?q=80&w=500',
          description: 'تجربة إطلاق صاروخي لارتفاعات قياسية ثم سقوط حر',
        ),
      ],
    ),

    // 2. خدمة صالة ألعاب الواقع الافتراضي (VR)
    const EntertainService(
      title: 'صالة الواقع الافتراضي (VR)',
      iconName: 'radar',
      items: [
        EntertainItem(
          id: 'e3',
          name: 'محاكاة سباق السيارات VR',
          price: 85.0,
          rating: 4.9,
          imageUrl:
              'https://images.unsplash.com/photo-1666350773137-cbc310aaf909?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fGNhciUyMHJhY2V8ZW58MHx8MHx8fDA%3D',
          description: 'سباق احترافي فائق الواقعية مع اهتزازات حركة كاملة',
        ),
        EntertainItem(
          id: 'e4',
          name: 'مغامرة الفضاء الأبعاد الثلاثية',
          price: 95.0,
          rating: 4.7,
          imageUrl:
              'https://images.unsplash.com/photo-1592478411213-6153e4ebc07d?q=80&w=500',
          description: 'معركة فضائية تفاعلية مع نظارات VR متطورة',
        ),
      ],
    ),

    // 3. خدمة منطقة ألعاب الأطفال
    const EntertainService(
      title: 'منطقة ألعاب الأطفال',
      iconName: 'smileys',
      items: [
        EntertainItem(
          id: 'e5',
          name: 'سيارات التصادم الكلاسيكية',
          price: 60.0,
          rating: 4.8,
          imageUrl:
              'https://images.unsplash.com/photo-1576671081837-49000212a370?q=80&w=500',
          description: 'حلبة آمنة وممتعة للتصادم العائلي والأطفال',
        ),
        EntertainItem(
          id: 'e6',
          name: 'قطار المغامرات الصغير',
          price: 50.0,
          rating: 4.6,
          imageUrl:
              'https://images.unsplash.com/photo-1527295110-5145f6b148d0?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8dHJhaW58ZW58MHx8MHx8fDA%3D',
          description: 'جولة استكشافية ممتعة ومصممة بألوان مبهجة للأطفال',
        ),
      ],
    ),

    // 4. خدمة العروض المسرحية والتفاعلية
    const EntertainService(
      title: 'العروض المسرحية والفعاليات',
      iconName: 'ticket',
      items: [
        EntertainItem(
          id: 'e7',
          name: 'عرض الأضواء والليزر',
          price: 70.0,
          rating: 4.9,
          imageUrl:
              'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?q=80&w=500',
          description: 'عرض موسيقي استعراضي ثلاثي الأبعاد بالأضواء',
        ),
        EntertainItem(
          id: 'e8',
          name: 'سينما D-Box التفاعلية',
          price: 75.0,
          rating: 4.8,
          imageUrl:
              'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?q=80&w=500',
          description: 'مقاعد متحركة مع مؤشرات بيئية كالهواء والمطر',
        ),
      ],
    ),
  ];

  void selectTab(String category) {
    selectedTab.value = category;
  }
}
