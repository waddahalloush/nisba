import 'package:get/get.dart';

/// نموذج الخدمات المتاحة في مركز التجميل
class BeautyService {
  final String id;
  final String name;
  final String duration;
  final double price; // السعر بالريال القطري
  final String category;
  final String imageUrl;
  final String description;

  const BeautyService({
    required this.id,
    required this.name,
    required this.duration,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.description,
  });
}

/// نموذج أقسام مركز التجميل
class CenterDepartment {
  final String name;
  final String description;
  final String iconName;
  final int servicesCount;

  const CenterDepartment({
    required this.name,
    required this.description,
    required this.iconName,
    required this.servicesCount,
  });
}

class BeautyDetailsController extends GetxController {
  // ── الحالة التفاعلية ──
  final selectedTab = 'نبذة عن المكان'.obs;
  final isLoading = false.obs;
  final selectedServiceId = ''.obs;

  // ── معلومات مركز التجميل (سبا جورلان الفاخر) ──
  final centerName = 'سبا جورلان الفاخر';
  final centerSubTitle = 'تجربة استرخاء وعناية ملكية بمنتجات فرنسية حصرية 100%';
  final location = 'أبراج الفردان، الخليج الغربي، الدوحة';
  final double rating = 4.9; // التقييم من 5
  final int reviewsCount = 840; // عدد التقييمات
  final workingHours = '09:00 ص - 10:00 م';

  // صور مباشرة من موقع Unsplash
  final coverImageUrl =
      'https://images.unsplash.com/photo-1540555700478-4be289fbecef?q=80&w=1000';
  final logoImageUrl =
      'https://images.unsplash.com/photo-1519824145371-296894a0daa9?q=80&w=300';

  // ── التبويبات الرئيسية ──
  final categories = <String>[
    'نبذة عن المكان',
    'الخدمات والتسعير',
    'أقسام المركز',
    'ساعات العمل والتقييم',
  ];

  // ── البيانات الإحصائية في الكارد المتداخل ──
  final centerStats = <Map<String, String>>[
    {'title': 'التقييم', 'value': '4.9 ★', 'icon': 'star'},
    {'title': 'عدد التقييمات', 'value': '840 تقييم', 'icon': 'like'},
    {'title': 'ساعات العمل', 'value': '09:00 ص - 10:00 م', 'icon': 'clock'},
    {'title': 'الموقع', 'value': 'الخليج الغربي', 'icon': 'location'},
  ];

  // ── 1. نبذة عن المكان ──
  final aboutText =
      'يُعتبر سبا جورلان الفاخر في أبراج الفردان واحة استثنائية للاسترخاء والعناية بالجمال في قلب الدوحة. يقدم السبا برامج علاجية مخصصة للوجه والجسم باستخدام مستحضرات بيت الأزياء الفرنسي جورلان، على أيدي نخبة من أخصائيات التجميل والعلاج الطبيعي في أجنحة فاخرة تضمن لك الخصوصية التامة والهدوء.';

  final centerHighlights = <String>[
    'أجنحة مساج واستجمام خاصة بالكامل مع حوض استحمام ملكي',
    'استخدام منتجات Guerlain الفرنسية الأصيلة الحصرية',
    'تشخيص آلي مجاني لنوع البشرة قبل بدء العلاج',
    'جلسات حمام مغربي وتركي ملكي بالزيوت العطرية',
  ];

  // ── 2. أقسام المركز ──
  final departments = <CenterDepartment>[
    const CenterDepartment(
      name: 'أجنحة المساج والاسترخاء',
      description: 'جلسات دلك عطرية وعلاجية لتخفيف التوتر وإعادة النشاط',
      iconName: 'magicpen',
      servicesCount: 6,
    ),
    const CenterDepartment(
      name: 'قسم العناية بالبشرة والوجه',
      description: 'علاجات النضارة ومكافحة الشيخوخة وهيدرافيدرشن فرنسي',
      iconName: 'award',
      servicesCount: 8,
    ),
    const CenterDepartment(
      name: 'جناح الحمام المغربي والتركي',
      description: 'حمام تقشير ملكي بالأعشاب الطبيعية والطين المغربي',
      iconName: 'sun',
      servicesCount: 4,
    ),
    const CenterDepartment(
      name: 'ركن العناية بالأظافر واليدين',
      description: 'جلسات باديكير ومانيكير متكاملة مع العناية بالبشرة',
      iconName: 'scissor',
      servicesCount: 5,
    ),
  ];

  // ── 3. قائمة الخدمات المتاحة مع التسعير بالريال القطري (ر.ق) ──
  final services = <BeautyService>[
    const BeautyService(
      id: 'srv1',
      name: 'جلسة المساج العطري الفاخر (Guerlain Massage)',
      duration: '60 دقيقة',
      price: 650.0,
      category: 'المساج والاسترخاء',
      imageUrl:
          'https://images.unsplash.com/photo-1600334089648-b0d9d3028eb2?q=80&w=500',
      description: 'جلسة مساج شاملة للجسم باستخدام الزيوت العطرية الفرنسية لتهدئة الأعصاب.',
    ),
    const BeautyService(
      id: 'srv2',
      name: 'علاج الوجه الملكي بالكولاجين والنضارة',
      duration: '75 دقيقة',
      price: 850.0,
      category: 'العناية بالبشرة',
      imageUrl:
          'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=500',
      description: 'تنظيف عميق للبشرة مع قناع الكولاجين لإعادة الإشراقة والشباب للوجه.',
    ),
    const BeautyService(
      id: 'srv3',
      name: 'جلسة الحمام المغربي الملكي بالأعشاب',
      duration: '90 دقيقة',
      price: 700.0,
      category: 'الحمام المغربي',
      imageUrl:
          'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=500',
      description: 'جلسة تقشير بالصابون البلدي والطين المغربي مع ماسك مرطب للجسم.',
    ),
    const BeautyService(
      id: 'srv4',
      name: 'باديكير ومانيكير سبا السكر مع البارافين',
      duration: '60 دقيقة',
      price: 350.0,
      category: 'الأظافر واليدين',
      imageUrl:
          'https://images.unsplash.com/photo-1604654894610-df63bc536371?q=80&w=500',
      description: 'عناية كاملة باليدين والقدمين مع التقشير بالشمع المرطب والمغذي.',
    ),
  ];

  void selectTab(String category) {
    selectedTab.value = category;
  }

  void selectService(String serviceId) {
    if (selectedServiceId.value == serviceId) {
      selectedServiceId.value = '';
    } else {
      selectedServiceId.value = serviceId;
    }
  }

  double get totalPrice {
    if (selectedServiceId.value.isEmpty) return 650.0; // السعر المبدئي
    final service = services.firstWhere((s) => s.id == selectedServiceId.value);
    return service.price;
  }

  void bookNow() {
    Get.snackbar(
      'تأكيد الحجز',
      'تم استلام طلب حجزك في سبا جورلان الفاخر بنجاح! سيتم التواصل معك للتأكيد.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}