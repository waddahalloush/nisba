import 'package:iconsax/iconsax.dart';
import '../../../../../../generated/assets.gen.dart';
import '../../../../../data/models/service_model.dart';
import '../Base Service/base_service_controller.dart';


class GiftController extends BaseServiceController {
  
  // ── 1. تصنيفات متاجر الهدايا والألعاب في قطر ──
  @override
  final List<ServiceCategory> categories = const [
    ServiceCategory(name: 'الكل', icon: Iconsax.category),
    ServiceCategory(name: 'هدايا وتذكارات', icon: Iconsax.gift),
    ServiceCategory(name: 'ألعاب أطفال', icon: Iconsax.game),
    ServiceCategory(name: 'إكسسوارات', icon: Iconsax.shop),
    ServiceCategory(name: 'تغليف وتنسيق', icon: Iconsax.box_1),
  ];

  // ── 2. المتاجر المميزة (الظاهرة في السكرول الأفقي العلوي) ──
  @override
  final List<BaseServiceItem> featuredItems = [
    BaseServiceItem(
      name: 'متجر هامليز الشهير',
      imageUrl: Assets.images.gifts1.path, // استخدم المسار المناسب للصور لديك
      address: 'قطر مول، الريان، الدوحة',
      rating: 4.9,
      distance: '2.5 كم',
      category: 'ألعاب أطفال',
      hours: '10:00 ص - 10:00 م',
      features: const [
        ServiceFeature(icon: Iconsax.game, label: 'أكبر متجر ألعاب بريطاني'),
        ServiceFeature(icon: Iconsax.box_1, label: 'تنسيق هدايا وتغليف فاخر'),
      ],
    ),
    BaseServiceItem(
      name: 'محلات الرونق',
      imageUrl: Assets.images.gifts2.path,
      address: 'فرع بن محمود، الدوحة',
      rating: 4.7,
      distance: '1.8 كم',
      category: 'هدايا وتذكارات',
      hours: '08:00 ص - 11:00 م',
      features: const [
        ServiceFeature(icon: Iconsax.gift, label: 'تشكيلة هدايا وتوزيعات ضخمة'),
        ServiceFeature(icon: Iconsax.card_receive, label: 'أسعار مناسبة وخيارات واسعة'),
      ],
    ),
    BaseServiceItem(
      name: 'متجر بيل أند بو',
      imageUrl: Assets.images.gifts3.path,
      address: 'بورتو أرابيا، اللؤلؤة، قطر',
      rating: 4.8,
      distance: '9.2 كم',
      category: 'إكسسوارات',
      hours: '10:00 ص - 11:00 م',
      features: const [
        ServiceFeature(icon: Iconsax.shop, label: 'إكسسوارات ومجوهرات راقية'),
        ServiceFeature(icon: Iconsax.glass, label: 'منتجات مخصصة وهدايا فريدة'),
      ],
    ),
  ];

  // ── 3. قائمة جميع متاجر الهدايا والألعاب (الظاهرة في القائمة الرأسية) ──
  @override
  final List<BaseServiceItem> allItems = [
    // 1. هامليز
    BaseServiceItem(
      name: 'متجر هامليز الشهير',
      imageUrl: Assets.images.gifts1.path,
      address: 'قطر مول، الريان، الدوحة',
      rating: 4.9,
      distance: '2.5 كم',
      category: 'ألعاب أطفال',
      hours: '10:00 ص - 10:00 م',
      features: const [
        ServiceFeature(icon: Iconsax.game, label: 'ألعاب وعروض تفاعلية حيّة للطفل'),
        ServiceFeature(icon: Iconsax.box_1, label: 'ركن تغليف هدايا احترافي'),
      ],
    ),
    // 2. الرونق
    BaseServiceItem(
      name: 'محلات الرونق',
      imageUrl: Assets.images.gifts2.path,
      address: 'فرع بن محمود، الدوحة',
      rating: 4.7,
      distance: '1.8 كم',
      category: 'هدايا وتذكارات',
      hours: '08:00 ص - 11:00 م',
      features: const [
        ServiceFeature(icon: Iconsax.discount_shape, label: 'مستلزمات الحفلات وأكياس الهدايا'),
        ServiceFeature(icon: Iconsax.paintbucket, label: 'ركن أشغال يدوية وقرطاسية متميزة'),
      ],
    ),
    // 3. بيل أند بو
    BaseServiceItem(
      name: 'متجر بيل أند بو',
      imageUrl: Assets.images.gifts3.path,
      address: 'بورتو أرابيا، اللؤلؤة، قطر',
      rating: 4.8,
      distance: '9.2 كم',
      category: 'إكسسوارات',
      hours: '10:00 ص - 11:00 م',
      features: const [
        ServiceFeature(icon: Iconsax.crown, label: 'إكسسوارات وهدايا للمناسبات الخاصة'),
        ServiceFeature(icon: Iconsax.star_1, label: 'قطع حصرية وتصميم مخصص'),
      ],
    ),
    // 4. فيرجن ميجاستور (Virgin Megastore)
    BaseServiceItem(
      name: 'فيرجن ميجاستور',
      imageUrl: Assets.images.gifts4.path,
      address: 'فيلاجيو مول، الدوحة، قطر',
      rating: 4.8,
      distance: '4.5 كم',
      category: 'إكسسوارات',
      hours: '10:00 ص - 12:00 ص',
      features: const [
        ServiceFeature(icon: Iconsax.headphone, label: 'إلكترونيات وإكسسوارات ذكية حديثة'),
        ServiceFeature(icon: Iconsax.game, label: 'أحدث ألعاب الفيديو والمجسمات'),
      ],
    ),
    // 5. محل كارتييه لتغليف وتنسيق الهدايا (Cartier Flowery)
    BaseServiceItem(
      name: 'قصر الهدايا',
      imageUrl: Assets.images.gifts5.path,
      address: 'شارع المرخية، الدوحة',
      rating: 4.6,
      distance: '6.0 كم',
      category: 'تغليف وتنسيق',
      hours: '09:00 ص - 10:00 م',
      features: const [
        ServiceFeature(icon: Iconsax.box_1, label: 'أرقى أنواع علب وأشرطة التغليف'),
        ServiceFeature(icon: Iconsax.cloud_notif, label: 'تنسيق بوكيهات ورد طبيعي ساحر'),
      ],
    ),
    // 6. تويز آر أص (Toys R Us)
    BaseServiceItem(
      name: 'تويز آر أص',
      imageUrl: Assets.images.gifts6.path,
      address: 'طريق سلوى، الدوحة',
      rating: 4.7,
      distance: '5.0 كم',
      category: 'ألعاب أطفال',
      hours: '09:00 ص - 10:30 م',
      features: const [
        ServiceFeature(icon: Iconsax.cup, label: 'تشكيلة واسعة من الألعاب التعليمية والذهنية'),
        ServiceFeature(icon: Iconsax.truck, label: 'دراجات هوائية وسكوترات للأطفال'),
      ],
    ),
    // 7. تذكار وسوق واقف (Souq Waqif Gifts)
    BaseServiceItem(
      name: 'محلات تذكار التراثية',
      imageUrl: Assets.images.gifts7.path,
      address: 'السوق الشعبي، سوق واقف، الدوحة',
      rating: 4.9,
      distance: '1.0 كم',
      category: 'هدايا وتذكارات',
      hours: '08:00 ص - 10:00 م',
      features: const [
        ServiceFeature(icon: Iconsax.gift, label: 'تحف وتذكارات قطرية مصنعة يدوياً'),
        ServiceFeature(icon: Iconsax.glass, label: 'عطور وبخور وصناديق خشبية تراثية'),
      ],
    ),
  ];
}