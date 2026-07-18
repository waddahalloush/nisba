import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/generated/assets.gen.dart'; // تأكد من استيراد الـ Assets الخاص بمشروعك
import '../../../../../data/models/service_model.dart';
import '../Base Service/base_service_controller.dart';

class MarketController extends BaseServiceController {
  
  // ── 1. تصنيفات الأسواق والتجارة في قطر ──
  @override
  final List<ServiceCategory> categories = const [
    ServiceCategory(name: 'الكل', icon: Iconsax.category),
    ServiceCategory(name: 'أسواق شعبية', icon: Iconsax.shop),
    ServiceCategory(name: 'أسواق متخصصة', icon: Iconsax.crown),
    ServiceCategory(name: 'أسواق الجملة', icon: Iconsax.box_1),
    ServiceCategory(name: 'شوارع تجارية', icon: Iconsax.routing),
  ];

  // ── 2. الأسواق المميزة (الظاهرة في السكرول الأفقي العلوي) ──
  @override
  final List<BaseServiceItem> featuredItems = [
    BaseServiceItem(
      name: 'سوق الذهب بالدوحة',
      imageUrl: Assets.images.sooq1.path,
      address: 'بجانب سوق واقف، الدوحة',
      rating: 4.9,
      distance: '1.1 كم',
      category: 'أسواق متخصصة',
      hours: '09:00 ص - 10:00 م',
      features: const [
        ServiceFeature(icon: Iconsax.crown, label: 'أحدث تصاميم الذهب والمجوهرات'),
        ServiceFeature(icon: Iconsax.verify, label: 'ورش فحص وصياغة معتمدة'),
      ],
    ),
    BaseServiceItem(
      name: 'سوق الوكرة القديم',
      imageUrl: Assets.images.sooq2.path,
      address: 'شاطئ الوكرة، الوكرة',
      rating: 4.8,
      distance: '15.0 كم',
      category: 'أسواق شعبية',
      hours: '08:00 ص - 11:00 م',
      features: const [
        ServiceFeature(icon: Iconsax.shop, label: 'محلات تجارية ومطاعم بحرية'),
        ServiceFeature(icon: Iconsax.sun_1, label: 'إطلالة مباشرة على البحر'),
      ],
    ),
    BaseServiceItem(
      name: 'سوق السيلية المركزي',
      imageUrl: Assets.images.sooq3.path,
      address: 'منطقة السيلية، الدوحة',
      rating: 4.7,
      distance: '18.5 كم',
      category: 'أسواق الجملة',
      hours: '05:00 ص - 10:00 م',
      features: const [
        ServiceFeature(icon: Iconsax.box_1, label: 'أكبر تجمع لبيع الخضار والفواكه بالجملة'),
        ServiceFeature(icon: Iconsax.discount_shape, label: 'أسعار تنافسية ومباشرة من المنتج'),
      ],
    ),
  ];

  // ── 3. قائمة جميع الأسواق والمناطق التجارية (الظاهرة في القائمة الرأسية) ──
  @override
  final List<BaseServiceItem> allItems = [
    // 1. سوق الذهب
    BaseServiceItem(
      name: 'سوق الذهب بالدوحة',
      imageUrl: Assets.images.sooq1.path,
      address: 'بجانب سوق واقف، الدوحة',
      rating: 4.9,
      distance: '1.1 كم',
      category: 'أسواق متخصصة',
      hours: '09:00 ص - 10:00 م',
      features: const [
        ServiceFeature(icon: Iconsax.crown, label: 'أفخم أطقم الذهب واللؤلؤ الطبيعي'),
        ServiceFeature(icon: Iconsax.status, label: 'بين التراث القطري والتصاميم الحديثة'),
      ],
    ),
    // 2. سوق الوكرة القديم
    BaseServiceItem(
      name: 'سوق الوكرة القديم',
      imageUrl: Assets.images.sooq2.path,
      address: 'شاطئ الوكرة، الوكرة',
      rating: 4.8,
      distance: '15.0 كم',
      category: 'أسواق شعبية',
      hours: '08:00 ص - 11:00 م',
      features: const [
        ServiceFeature(icon: Iconsax.map, label: 'سوق تراثي هادئ على الساحل الجنوبي'),
        ServiceFeature(icon: Iconsax.activity, label: 'ممشى بحري ومتاجر تراثية متنوعة'),
      ],
    ),
    // 3. سوق السيلية المركزي
    BaseServiceItem(
      name: 'سوق السيلية المركزي',
      imageUrl: Assets.images.sooq3.path,
      address: 'منطقة السيلية، الدوحة',
      rating: 4.7,
      distance: '18.5 كم',
      category: 'أسواق الجملة',
      hours: '05:00 ص - 10:00 م',
      features: const [
        ServiceFeature(icon: Iconsax.truck, label: 'ساحات بيع ومزاد يومي للمنتجات الطازجة'),
        ServiceFeature(icon: Iconsax.card_receive, label: 'مجهز بالكامل ومكيف لراحة المتسوقين'),
      ],
    ),
    // 4. سوق العلي
    BaseServiceItem(
      name: 'سوق العلي الشهير',
      imageUrl: Assets.images.sooq4.path,
      address: 'منطقة الغرافة، الدوحة',
      rating: 4.6,
      distance: '7.2 كم',
      category: 'أسواق متخصصة',
      hours: '08:30 ص - 10:30 م',
      features: const [
        ServiceFeature(icon: Iconsax.user_tag, label: 'أشهر أسواق خياطة وتفصيل الأثواب والمستلزمات الرجالية'),
        ServiceFeature(icon: Iconsax.shop, label: 'محلات صرافة وتجارة عامة عريقة'),
      ],
    ),
    // 5. سوق الحراج للسلع المستعملة والجديدة
    BaseServiceItem(
      name: 'سوق الحراج التراثي',
      imageUrl: Assets.images.sooq5.path,
      address: 'منطقة النجمة، الدوحة',
      rating: 4.5,
      distance: '3.0 كم',
      category: 'أسواق شعبية',
      hours: '08:00 ص - 10:00 م',
      features: const [
        ServiceFeature(icon: Iconsax.house, label: 'تجارة الأثاث، الأجهزة المنزلية والسجاد'),
        ServiceFeature(icon: Iconsax.discount_shape, label: 'فرص ممتازة لصفقات تجارية وشعبية سريعة'),
      ],
    ),
    // 6. سوق أم صلال المركزي
    BaseServiceItem(
      name: 'سوق أم صلال المركزي للأسماك',
      imageUrl: Assets.images.sooq6.path,
      address: 'منطقة أم صلال، قطر',
      rating: 4.7,
      distance: '22.0 كم',
      category: 'أسواق الجملة',
      hours: '06:00 ص - 09:00 م',
      features: const [
        ServiceFeature(icon: Iconsax.activity, label: 'مزاد الأسماك الطازجة المحلية والمستوردة'),
        ServiceFeature(icon: Iconsax.verify, label: 'مصنع ثلج ومحطات تنظيف وتقطيع حديثة'),
      ],
    ),
    // 7. شارع آل شافي التجاري
    BaseServiceItem(
      name: 'شارع آل شافي التجاري',
      imageUrl: Assets.images.sooq7.path,
      address: 'منطقة الريان، الدوحة',
      rating: 4.6,
      distance: '9.0 كم',
      category: 'شوارع تجارية',
      hours: 'مفتوح دائماً (المحلات تختلف)',
      features: const [
        ServiceFeature(icon: Iconsax.routing, label: 'شارع تجاري حيوي يضم مئات المحلات المتنوعة'),
        ServiceFeature(icon: Iconsax.mobile, label: 'مراكز صيانة هواتف ومستلزمات إلكترونية متعددة'),
      ],
    ),
  ];
}