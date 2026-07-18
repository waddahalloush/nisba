import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/generated/assets.gen.dart';
import 'package:nisba_app/src/data/models/service_model.dart';
import 'package:nisba_app/src/ui/screens/Home/Services/Base Service/base_service_controller.dart';

class MallController extends BaseServiceController {
  // ── 1. تصنيفات المولات ──
  @override
  final List<ServiceCategory> categories = const [
    ServiceCategory(name: 'الكل', icon: Iconsax.category),
    ServiceCategory(name: 'ترفيه', icon: Iconsax.music),
    ServiceCategory(name: 'مطاعم', icon: Iconsax.coffee),
    ServiceCategory(name: 'أزياء', icon: Iconsax.shop),
    ServiceCategory(name: 'إلكترونيات', icon: Iconsax.mobile),
  ];

  // ── 2. المولات المميزة (الظاهرة في السكرول الأفقي العلوي) ──
  @override
  final List<BaseServiceItem> featuredItems = [
    BaseServiceItem(
      name: 'قطر مول',
      imageUrl: Assets.images.mall11.path,
      address: 'طريق الدوحة السريع',
      rating: 4.8,
      distance: '2.5 كم',
      category: 'الكل',
      hours: '10:00 ص - 12:00 م',
      features: const [
        ServiceFeature(icon: Iconsax.shop, label: '350 متجر'),
        ServiceFeature(icon: Iconsax.coffee, label: '50 مطعم'),
        ServiceFeature(icon: Iconsax.video, label: 'سينما'),
      ],
    ),
    BaseServiceItem(
      name: 'لاند مارك مول',
      imageUrl: Assets.images.mall22.path,
      address: 'طريق سلوى',
      rating: 4.6,
      distance: '5.0 كم',
      category: 'الكل',
      hours: '9:00 ص - 11:00 م',
      features: const [
        ServiceFeature(icon: Iconsax.shop, label: '280 متجر'),
        ServiceFeature(icon: Iconsax.coffee, label: '35 مطعم'),
        ServiceFeature(icon: Iconsax.video, label: 'سينما'),
      ],
    ),
    BaseServiceItem(
      name: 'جلف مول',
      imageUrl: Assets.images.mall44.path,
      address: 'منطقة الخليج الغربي',
      rating: 4.5,
      distance: '3.2 كم',
      category: 'الكل',
      hours: '10:00 ص - 10:00 م',
      features: const [
        ServiceFeature(icon: Iconsax.shop, label: '200 متجر'),
        ServiceFeature(icon: Iconsax.coffee, label: '30 مطعم'),
      ],
    ),
  ];

  // ── 3. قائمة جميع المولات (الظاهرة في القائمة الرأسية) ──
  @override
  final List<BaseServiceItem> allItems = [
    BaseServiceItem(
      name: 'قطر مول',
      imageUrl: Assets.images.mall11.path,
      address: 'طريق الدوحة السريع، الريان',
      rating: 4.8,
      distance: '2.5 كم',
      category: 'ترفيه',
      hours: '10:00 ص - 10:00 م',
      features: const [
        ServiceFeature(icon: Iconsax.shop, label: '350 متجر'),
        ServiceFeature(icon: Iconsax.coffee, label: '50 مطعم'),
      ],
    ),
    BaseServiceItem(
      name: 'لاند مارك مول',
      imageUrl: Assets.images.mall22.path,
      address: 'طريق سلوى، أبو هامور',
      rating: 4.6,
      distance: '5.0 كم',
      category: 'أزياء',
      hours: '9:00 ص - 11:00 م',
      features: const [
        ServiceFeature(icon: Iconsax.shop, label: '280 متجر'),
        ServiceFeature(icon: Iconsax.coffee, label: '35 مطعم'),
      ],
    ),
    BaseServiceItem(
      name: 'جلف مول',
      imageUrl: Assets.images.mall44.path,
      address: 'منطقة الخليج الغربي، الدوحة',
      rating: 4.5,
      distance: '3.2 كم',
      category: 'ترفيه',
      hours: '10:00 ص - 10:00 م',
      features: const [
        ServiceFeature(icon: Iconsax.shop, label: '200 متجر'),
        ServiceFeature(icon: Iconsax.coffee, label: '30 مطعم'),
      ],
    ),
    BaseServiceItem(
      name: 'فيلاجيو مول',
      imageUrl: Assets.images.mall33.path,
      address: 'منطقة أسباير زون، الدوحة',
      rating: 4.7,
      distance: '4.1 كم',
      category: 'ترفيه',
      hours: '9:00 ص - 11:00 م',
      features: const [
        ServiceFeature(icon: Iconsax.shop, label: '220 متجر'),
        ServiceFeature(icon: Iconsax.coffee, label: '45 مطعم'),
      ],
    ),
    BaseServiceItem(
      name: 'مول قطر',
      imageUrl: Assets.images.service6.path,
      address: 'طريق سلوى، الريان',
      rating: 4.4,
      distance: '6.3 كم',
      category: 'مطاعم',
      hours: '10:00 ص - 10:00 م',
      features: const [
        ServiceFeature(icon: Iconsax.shop, label: '190 متجر'),
        ServiceFeature(icon: Iconsax.coffee, label: '28 مطعم'),
      ],
    ),
    BaseServiceItem(
      name: 'إزدان مول',
      imageUrl: Assets.images.service7.path,
      address: 'الوكرة، الدوحة',
      rating: 4.3,
      distance: '8.0 كم',
      category: 'إلكترونيات',
      hours: '10:00 ص - 10:00 م',
      features: const [
        ServiceFeature(icon: Iconsax.shop, label: '150 متجر'),
        ServiceFeature(icon: Iconsax.coffee, label: '22 مطعم'),
      ],
    ),
  ];
}
