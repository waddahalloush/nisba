import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/generated/assets.gen.dart'; // تأكد من استيراد الـ Assets الخاص بمشروعك
import '../../../../../data/models/service_model.dart';
import '../Base Service/base_service_controller.dart';

class HotelController extends BaseServiceController {
  
  // ── 1. تصنيفات الفنادق والإقامة في قطر ──
  @override
  final List<ServiceCategory> categories = const [
    ServiceCategory(name: 'الكل', icon: Iconsax.category),
    ServiceCategory(name: 'منتجعات شاطئية', icon: Iconsax.sun_1),
    ServiceCategory(name: 'فنادق 5 نجوم', icon: Iconsax.crown),
    ServiceCategory(name: 'فنادق 4 نجوم', icon: Iconsax.award),
    ServiceCategory(name: 'شقق فندقية', icon: Iconsax.house),
  ];

  // ── 2. الفنادق المميزة (الظاهرة في السكرول الأفقي العلوي) ──
  @override
  final List<BaseServiceItem> featuredItems = [
    BaseServiceItem(
      name: 'جزيرة الموز',
      imageUrl: Assets.images.hotel1.path,
      address: 'جزيرة الموز، قبالة كورنيش الدوحة',
      rating: 4.9,
      distance: '11.0 كم (بالقارب)',
      category: 'منتجعات شاطئية',
      hours: 'استقبال 24 ساعة',
      features: const [
        ServiceFeature(icon: Iconsax.sun_1, label: 'شاطئ خاص ممتد'),
        ServiceFeature(icon: Iconsax.activity, label: 'فيلات فوق الماء ومسبح أمواج'),
      ],
    ),
    BaseServiceItem(
      name: 'مرسى ملاذ كمبينسكي',
      imageUrl: Assets.images.hotel2.path,
      address: 'جزيرة اللؤلؤة، الدوحة',
      rating: 4.8,
      distance: '8.2 كم',
      category: 'منتجعات شاطئية',
      hours: 'استقبال 24 ساعة',
      features: const [
        ServiceFeature(icon: Iconsax.crown, label: 'تصميم قصر أوروبي فاخر'),
        ServiceFeature(icon: Iconsax.cup, label: 'مطاعم حائزة على جوائز'),
      ],
    ),
    BaseServiceItem(
      name: ' موندريان الدوحة',
      imageUrl: Assets.images.hotel3.path,
      address: 'منطقة غرب خليج لوسيل، الدوحة',
      rating: 4.8,
      distance: '9.0 كم',
      category: 'فنادق 5 نجوم',
      hours: 'استقبال 24 ساعة',
      features: const [
        ServiceFeature(icon: Iconsax.paintbucket, label: 'تصميم داخلي عصري مذهل'),
        ServiceFeature(icon: Iconsax.music, label: 'حمام سباحة بانورامي في السطح'),
      ],
    ),
  ];

  // ── 3. قائمة جميع الفنادق والمنتجعات (الظاهرة في القائمة الرأسية) ──
  @override
  final List<BaseServiceItem> allItems = [
    // 1. جزيرة الموز
    BaseServiceItem(
      name: 'جزيرة الموز',
      imageUrl: Assets.images.hotel1.path,
      address: 'جزيرة الموز، قبالة كورنيش الدوحة',
      rating: 4.9,
      distance: '11.0 كم (بالقارب)',
      category: 'منتجعات شاطئية',
      hours: 'استقبال 24 ساعة',
      features: const [
        ServiceFeature(icon: Iconsax.activity, label: 'أنشطة غوص ورياضات مائية'),
        ServiceFeature(icon: Iconsax.shield_security, label: 'خصوصية تامة وهدوء مثالي'),
      ],
    ),
    // 2. مرسى ملاذ كمبينسكي
    BaseServiceItem(
      name: 'مرسى ملاذ كمبينسكي',
      imageUrl: Assets.images.hotel2.path,
      address: 'جزيرة اللؤلؤة، الدوحة',
      rating: 4.8,
      distance: '8.2 كم',
      category: 'منتجعات شاطئية',
      hours: 'استقبال 24 ساعة',
      features: const [
        ServiceFeature(icon: Iconsax.coffee, label: 'سبا هادئ ونادٍ صحي متكامل'),
        ServiceFeature(icon: Iconsax.building_3, label: 'إطلالات ساحرة على الخليج العربي'),
      ],
    ),
    // 3. موندريان الدوحة
    BaseServiceItem(
      name: ' موندريان الدوحة',
      imageUrl: Assets.images.hotel3.path,
      address: 'منطقة غرب خليج لوسيل، الدوحة',
      rating: 4.8,
      distance: '9.0 كم',
      category: 'فنادق 5 نجوم',
      hours: 'استقبال 24 ساعة',
      features: const [
        ServiceFeature(icon: Iconsax.cup, label: 'تجربة طعام يابانية من شيف عالمي'),
        ServiceFeature(icon: Iconsax.flash_1, label: 'قاعة احتفالات ضخمة وراقية'),
      ],
    ),
    // 4. شيراتون جراند الدوحة
    BaseServiceItem(
      name: ' شيراتون جراند',
      imageUrl: Assets.images.hotel4.path,
      address: 'كورنيش الدوحة، الخليج الغربي',
      rating: 4.9,
      distance: '3.0 كم',
      category: 'منتجعات شاطئية',
      hours: 'استقبال 24 ساعة',
      features: const [
        ServiceFeature(icon: Iconsax.map, label: 'أيقونة الدوحة التراثية على الكورنيش'),
        ServiceFeature(icon: Iconsax.tree, label: 'حدائق واسعة ممتدة وملاعب تنس'),
      ],
    ),
    // 5. فندق راديسون بلو (Radisson Blu)
    BaseServiceItem(
      name: 'راديسون بلو',
      imageUrl: Assets.images.hotel5.path,
      address: 'تقاطع طريق سلوى مع الدائري الثالث',
      rating: 4.5,
      distance: '2.5 كم',
      category: 'فنادق 4 نجوم',
      hours: 'استقبال 24 ساعة',
      features: const [
        ServiceFeature(icon: Iconsax.routing, label: 'موقع حيوي ممتاز وسط العاصمة'),
        ServiceFeature(icon: Iconsax.coffee, label: 'أكثر من 10 مطاعم تقدم أطباق متنوعة'),
      ],
    ),
    // 6. شقق فندقية فريزر سويتس (Fraser Suites)
    BaseServiceItem(
      name: 'فريزر سويتس',
      imageUrl: Assets.images.hotel6.path,
      address: 'طريق الكورنيش، الدوحة',
      rating: 4.6,
      distance: '1.2 كم',
      category: 'شقق فندقية',
      hours: 'استقبال 24 ساعة',
      features: const [
        ServiceFeature(icon: Iconsax.house, label: 'شقق واسعة ومجهزة بالكامل للعائلات'),
        ServiceFeature(icon: Iconsax.teacher, label: 'منطقة لعب مخصصة وآمنة للأطفال'),
      ],
    ),
    // 7. فندق روتانا سيتي سنتر (City Centre Rotana)
    BaseServiceItem(
      name: 'سيتي سنتر روتانا',
      imageUrl: Assets.images.hotel7.path,
      address: 'الخليج الغربي، الدوحة',
      rating: 4.7,
      distance: '4.0 كم',
      category: 'فنادق 5 نجوم',
      hours: 'استقبال 24 ساعة',
      features: const [
        ServiceFeature(icon: Iconsax.shop, label: 'اتصال مباشر بمجمع سيتي سنتر مول'),
        ServiceFeature(icon: Iconsax.activity, label: 'قريب جداً من محطة مترو الخليج الغربي'),
      ],
    ),
  ];
}