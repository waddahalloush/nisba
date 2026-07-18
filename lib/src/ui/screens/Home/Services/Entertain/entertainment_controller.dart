import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/generated/assets.gen.dart'; // تأكد من استيراد Assets بشكل صحيح
import '../../../../../data/models/service_model.dart';
import '../Base Service/base_service_controller.dart';


class EntertainmentController extends BaseServiceController {
  
  // ── 1. تصنيفات الترفيه المحددة لدولة قطر ──
  @override
  final List<ServiceCategory> categories = const [
    ServiceCategory(name: 'الكل', icon: Iconsax.category),
    ServiceCategory(name: 'ملاهي مغلقة', icon: Iconsax.game),
    ServiceCategory(name: 'ألعاب مائية', icon: Iconsax.activity),
    ServiceCategory(name: 'ألعاب حركية', icon: Iconsax.cloud_sunny),
    ServiceCategory(name: 'عائلي', icon: Iconsax.people),
  ];

  // ── 2. المراكز الترفيهية المميزة القريبة (الظاهرة في السكرول الأفقي العلوي) ──
  @override
  final List<BaseServiceItem> featuredItems = [
    BaseServiceItem(
      name: 'مدينة ألعاب دوحة كويست',
      imageUrl: Assets.images.entertain1.path, // للتجربة مؤقتاً، يمكنك استبدالها بصور مخصصة لاحقاً
      address: 'واحة الدوحة، مشيرب، الدوحة',
      rating: 4.9,
      distance: '1.2 كم',
      category: 'ملاهي مغلقة',
      hours: '02:00 م - 10:00 م',
      features: const [
        ServiceFeature(icon: Iconsax.game, label: '30 لعبة حماسية'),
        ServiceFeature(icon: Iconsax.radar, label: 'واقع افتراضي (VR)'),
      ],
    ),
    BaseServiceItem(
      name: 'لوسيل ونتر وندرلاند',
      imageUrl: Assets.images.entertain2.path,
      address: 'جزيرة المها، لوسيل',
      rating: 4.8,
      distance: '8.5 كم',
      category: 'عائلي',
      hours: '04:00 م - 12:00 ص',
      features: const [
        ServiceFeature(icon: Iconsax.mask, label: 'ألعاب عائلية وعروض ملونة'),
        ServiceFeature(icon: Iconsax.coffee, label: 'مطاعم عالمية وفخمة'),
      ],
    ),
    BaseServiceItem(
      name: 'حديقة مريال المائية',
      imageUrl: Assets.images.entertain3.path,
      address: 'جزيرة قطيفان الشمالية، لوسيل',
      rating: 4.7,
      distance: '11.0 كم',
      category: 'ألعاب مائية',
      hours: '10:00 ص - 06:00 م',
      features: const [
        ServiceFeature(icon: Iconsax.activity, label: 'أعلى برج منزلق مائي بالعالم'),
        ServiceFeature(icon: Iconsax.sun_1, label: 'شاطئ خاص بالحديقة المائية'),
      ],
    ),
  ];

  // ── 3. قائمة جميع المراكز الترفيهية (الظاهرة في القائمة الرأسية مع الفلترة) ──
  @override
  final List<BaseServiceItem> allItems = [
    // 1. دوحة كويست (مغلقة)
    BaseServiceItem(
      name: 'مدينة ألعاب دوحة كويست',
      imageUrl: Assets.images.entertain1.path,
      address: 'واحة الدوحة، مشيرب، الدوحة',
      rating: 4.9,
      distance: '1.2 كم',
      category: 'ملاهي مغلقة',
      hours: '02:00 م - 10:00 م',
      features: const [
        ServiceFeature(icon: Iconsax.game, label: 'أسرع أفعوانية مغلقة بالعالم'),
        ServiceFeature(icon: Iconsax.radar, label: 'أحدث تجارب VR'),
      ],
    ),
    // 2. لوسيل ونتر وندرلاند (عائلي)
    BaseServiceItem(
      name: 'لوسيل ونتر وندرلاند',
      imageUrl: Assets.images.entertain2.path,
      address: 'جزيرة المها، لوسيل',
      rating: 4.8,
      distance: '8.5 كم',
      category: 'عائلي',
      hours: '04:00 م - 12:00 ص',
      features: const [
        ServiceFeature(icon: Iconsax.mask, label: 'أجواء شتوية ساحرة وعروض'),
        ServiceFeature(icon: Iconsax.shop, label: 'أكشاك هدايا تذكارية'),
      ],
    ),
    // 3. حديقة مريال المائية (ألعاب مائية)
    BaseServiceItem(
      name: 'حديقة مريال المائية',
      imageUrl: Assets.images.entertain3.path,
      address: 'جزيرة قطيفان الشمالية، لوسيل',
      rating: 4.7,
      distance: '11.0 كم',
      category: 'ألعاب مائية',
      hours: '10:00 ص - 06:00 م',
      features: const [
        ServiceFeature(icon: Iconsax.activity, label: 'أعلى برج أيقوني للمنحدرات المائية'),
        ServiceFeature(icon: Iconsax.sun_1, label: 'منطقة ألعاب مائية للأطفال وآمنة'),
      ],
    ),
    // 4. أنجري بيردز ورلد (عائلي ومغلق)
    BaseServiceItem(
      name: 'أنجري بيردز ورلد',
      imageUrl: Assets.images.entertain4.path,
      address: 'دوحة فستيفال سيتي، الدوحة',
      rating: 4.6,
      distance: '12.4 كم',
      category: 'عائلي',
      hours: '10:00 ص - 10:00 م',
      features: const [
        ServiceFeature(icon: Iconsax.game, label: 'ألعاب داخلية وخارجية ممتعة'),
        ServiceFeature(icon: Iconsax.music, label: 'مسرح خاص لعروض الطيور الغاضبة'),
      ],
    ),
    // 5. باونس الدوحة (ألعاب حركية ومغلق)
    BaseServiceItem(
      name: 'باونس الدوحة',
      imageUrl: Assets.images.entertain5.path,
      address: 'طوار مول، الدوحة',
      rating: 4.7,
      distance: '5.2 كم',
      category: 'ألعاب حركية',
      hours: '10:00 ص - 10:00 م',
      features: const [
        ServiceFeature(icon: Iconsax.activity, label: 'أكبر صالة ترامبولين مغلقة للقفز'),
        ServiceFeature(icon: Iconsax.judge, label: 'ألعاب تحدي وتسلق جدران'),
      ],
    ),
    // 6. سنو ديونز (ملاهي ثلجية مغلقة)
    BaseServiceItem(
      name: 'كثبان الثلج',
      imageUrl: Assets.images.entertain6.path,
      address: 'دوحة فستيفال سيتي، الدوحة',
      rating: 4.5,
      distance: '12.4 كم',
      category: 'ملاهي مغلقة',
      hours: '10:00 ص - 10:00 م',
      features: const [
        ServiceFeature(icon: Iconsax.cloud_notif, label: 'درجة حرارة تحت الصفر 4-'),
        ServiceFeature(icon: Iconsax.activity, label: 'ألعاب تزلج ثلجية آمنة وممتعة'),
      ],
    ),
    // 7. كيدزانيا الدوحة (عائلي وتعليمي)
    BaseServiceItem(
      name: 'كيدزانيا الدوحة',
      imageUrl: Assets.images.entertain7.path,
      address: 'حديقة أسباير، الوعب، الدوحة',
      rating: 4.8,
      distance: '6.0 كم',
      category: 'عائلي',
      hours: '01:00 م - 09:00 م',
      features: const [
        ServiceFeature(icon: Iconsax.teacher, label: 'بيئة تعليمية وترفيهية للأطفال'),
        ServiceFeature(icon: Iconsax.briefcase, label: 'أكثر من 60 تجربة مهنية حقيقية'),
      ],
    ),
  ];
}