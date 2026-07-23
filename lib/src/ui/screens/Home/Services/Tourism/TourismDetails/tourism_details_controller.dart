import 'package:get/get.dart';

import '../../../../../../../generated/assets.gen.dart';

/// نموذج خطوات برنامج الرحلة
class ItineraryStep {
  final String time;
  final String title;
  final String description;
  final String iconName;

  const ItineraryStep({
    required this.time,
    required this.title,
    required this.description,
    required this.iconName,
  });
}

/// نموذج المرشد السياحي الخاص
class TourGuide {
  final String name;
  final String title;
  final double rating;
  final String languages;
  final double pricePerDay;
  final String imageUrl;

  const TourGuide({
    required this.name,
    required this.title,
    required this.rating,
    required this.languages,
    required this.pricePerDay,
    required this.imageUrl,
  });
}

/// نموذج الفعاليات والأنشطة السياحية
class TourismActivity {
  final String id;
  final String name;
  final String duration;
  final double price;
  final double rating;
  final String imageUrl;
  final String description;

  const TourismActivity({
    required this.id,
    required this.name,
    required this.duration,
    required this.price,
    required this.rating,
    required this.imageUrl,
    required this.description,
  });
}

class TourismDetailsController extends GetxController {
  // ── الحالة التفاعلية ──
  final selectedTab = 'نبذة عن المكان'.obs;
  final isLoading = false.obs;

  // ── معلومات المعلم السياحي (الحي الثقافي - كتارا) ──
  final destinationName = 'الحي الثقافي (كتارا)';
  final destinationSubTitle = 'ملتقى الثقافات والفنون أحدث أيقونة تراثية في الدوحة';
  final location = 'الخليج الغربي، الدوحة';
  final rating = 4.8;
  final reviewsCount = '1,280';
  final workingHours = 'مفتوح دائماً (24/7)';
  final entranceFee = 'دخول مجاني';

  // صور مباشرة عالية الجودة من Unsplash
  final coverImageUrl =
      Assets.images.tourism2.path;
  final logoImageUrl =
      'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?q=80&w=300';

  // ── التبويبات الرئيسية ──
  final categories = <String>[
    'نبذة عن المكان',
    'برنامج الرحلة',
    'مرشد سياحي',
    'الفعاليات والنشاطات',
  ];

  // ── كروت معلومات الكارد المتداخل ──
  final destinationStats = <Map<String, String>>[
    {'title': 'التذكرة', 'value': 'دخول مجاني', 'icon': 'ticket'},
    {'title': 'التقييم', 'value': '4.8 ★', 'icon': 'star'},
    {'title': 'الدوام', 'value': 'مفتوح دائماً', 'icon': 'clock'},
    {'title': 'الموقع', 'value': 'الخليج الغربي', 'icon': 'location'},
  ];

  // ── 1. نبذة عن المكان ──
  final aboutText =
      'يُعد الحي الثقافي "كتارا" مشروعاً استثنائياً يجمع بين التراث المعماري القطري الأصيل والفنون العالمية. يضم الحي مسارح مفتوحة ومغلقة، معارض فنية، شاطئاً ساحراً، ومجموعة من أشهر المطاعم العالمية والمحلية، مما يجعله وجهة سياحية رئيسية للزوار والعائلات.';

  final highlights = <String>[
    'المسرح الروماني المفتوح والمطل على البحر',
    'جامع كتارا الأزرق والمسرح الذهبي',
    'شاطئ كتارا للرياضات والألعاب المائية',
    'تلال كتارا ذات الإطلالة البانورامية',
  ];

  // ── 2. برنامج الرحلة الموصى به (Itinerary) ──
  final itinerarySteps = <ItineraryStep>[
    const ItineraryStep(
      time: '10:00 صباحاً',
      title: 'وصول وجولة بالمسرح الروماني',
      description: 'استكشاف الهندسة المعمارية لالتقاط أجمل الصور التذكارية',
      iconName: 'building',
    ),
    const ItineraryStep(
      time: '01:00 ظهراً',
      title: 'استراحة الغداء في تلال كتارا',
      description: 'تناول وجبة غداء مع إطلالة بانورامية على أبراج الخليج الغربي',
      iconName: 'coffee',
    ),
    const ItineraryStep(
      time: '04:00 عصراً',
      title: 'زيارة المعارض الفنية وجامع كتارا',
      description: 'جولة استكشافية للوحات الفنية والتصميم الإسلامي الفريد',
      iconName: 'gallery',
    ),
    const ItineraryStep(
      time: '06:30 مساءً',
      title: 'جولة القارب وتأمل الغروب',
      description: 'جولة بحرية ممتعة لشاطئ كتارا واحتساء القهوة التراثية',
      iconName: 'ship',
    ),
  ];

  // ── 3. المرشد السياحي الخاص ──
  final privateGuide = const TourGuide(
    name: 'سالم المري',
    title: 'مرشد سياحي معتمد ومؤرخ ثقافي',
    rating: 4.9,
    languages: 'العربية، الإنجليزية، الفرنسية',
    pricePerDay: 250.0,
    imageUrl:
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=400',
  );

  // ── 4. الفعاليات والنشاطات ──
  final activities = <TourismActivity>[
    const TourismActivity(
      id: 'act1',
      name: 'جولة القارب التراثي في كتارا',
      duration: '45 دقيقة',
      price: 120.0,
      rating: 4.8,
      imageUrl:
          'https://images.unsplash.com/photo-1544551763-46a013bb70d5?q=80&w=500',
      description: 'جولة بحرية ساحرة بداخل قارب تقليدي مع مشروبات ضيافة',
    ),
    const TourismActivity(
      id: 'act2',
      name: 'تجربة الرياضات المائية بالشاطئ',
      duration: '60 دقيقة',
      price: 180.0,
      rating: 4.7,
      imageUrl:
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=500',
      description: 'أنشطة ركوب الجيت سكي وقوارب الكاياك تحت إشراف مدربين',
    ),
    const TourismActivity(
      id: 'act3',
      name: 'ورشة عمل الفنون والخزف',
      duration: '120 دقيقة',
      price: 150.0,
      rating: 4.9,
      imageUrl:
          'https://images.unsplash.com/photo-1565193566173-7a0ee3dbe261?q=80&w=500',
      description: 'ورشة تعليمية حية لتشكيل الخزف والرسم بالخط العربي',
    ),
  ];

  void selectTab(String category) {
    selectedTab.value = category;
  }

  void bookNow() {
    Get.snackbar(
      'تأكيد الحجز',
      'تم إرسال طلب حجز جولة الحي الثقافي كتارا بنجاح!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}