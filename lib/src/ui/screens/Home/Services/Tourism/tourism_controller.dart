import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/generated/assets.gen.dart'; // تأكد من استيراد الـ Assets الخاص بمشروعك

import '../../../../../data/models/service_model.dart';
import '../Base Service/base_service_controller.dart';

class TourismController extends BaseServiceController {
  // ── 1. تصنيفات الوجهات السياحية في قطر ──
  @override
  final List<ServiceCategory> categories = const [
    ServiceCategory(name: 'الكل', icon: Iconsax.category),
    ServiceCategory(name: 'معالم أثرية', icon: Icons.fort),
    ServiceCategory(name: 'متاحف وفنون', icon: Iconsax.gallery),
    ServiceCategory(name: 'شواطئ وجزر', icon: Iconsax.sun_1),
    ServiceCategory(name: 'حدائق ومنتزهات', icon: Iconsax.tree),
  ];

  // ── 2. الوجهات السياحية المميزة (الظاهرة في السكرول الأفقي العلوي) ──
  @override
  final List<BaseServiceItem> featuredItems = [
    BaseServiceItem(
      name: 'سوق واقف الأثري',
      imageUrl:
          Assets.images.tourism1.path, // استبدلها بصور المعالم السياحية لاحقاً
      address: 'وسط البلد، الدوحة',
      rating: 4.9,
      distance: '0.8 كم',
      category: 'معالم أثرية',
      hours: 'مفتوح 24 ساعة',
      features: const [
        ServiceFeature(icon: Iconsax.status, label: 'تراث شعبي وتسوق'),
        ServiceFeature(icon: Iconsax.coffee, label: 'مطاعم ومقاهي شعبية'),
      ],
    ),
    BaseServiceItem(
      name: 'الحي الثقافي (كتارا)',
      imageUrl: Assets.images.tourism2.path,
      address: 'الخليج الغربي، الدوحة',
      rating: 4.8,
      distance: '5.5 كم',
      category: 'معالم أثرية',
      hours: 'مفتوح دائماً',
      features: const [
        ServiceFeature(icon: Iconsax.mask, label: 'مسارح ومعارض فنية'),
        ServiceFeature(icon: Iconsax.sun_1, label: 'شاطئ وأنشطة مائية'),
      ],
    ),
    BaseServiceItem(
      name: 'متحف الفن الإسلامي',
      imageUrl: Assets.images.tourism3.path,
      address: 'كورنيش الدوحة، الدوحة',
      rating: 4.9,
      distance: '1.5 كم',
      category: 'متاحف وفنون',
      hours: '09:00 ص - 07:00 م',
      features: const [
        ServiceFeature(icon: Iconsax.gallery, label: 'تحف ومخطوطات تاريخية'),
        ServiceFeature(
          icon: Iconsax.radar,
          label: 'إطلالة بانورامية على الكورنيش',
        ),
      ],
    ),
  ];

  // ── 3. قائمة جميع المعالم والوجهات السياحية (الظاهرة في القائمة الرأسية) ──
  @override
  final List<BaseServiceItem> allItems = [
    // 1. سوق واقف
    BaseServiceItem(
      name: 'سوق واقف الأثري',
      imageUrl: Assets.images.tourism1.path,
      address: 'وسط البلد، الدوحة',
      rating: 4.9,
      distance: '0.8 كم',
      category: 'معالم أثرية',
      hours: 'مفتوح 24 ساعة (المحلات تختلف)',
      features: const [
        ServiceFeature(icon: Iconsax.map, label: 'سوق تراثي يعود لمئات السنين'),
        ServiceFeature(icon: Iconsax.flash_1, label: 'عرض حي للحرف اليدوية'),
      ],
    ),
    // 2. كتارا
    BaseServiceItem(
      name: 'الحي الثقافي (كتارا)',
      imageUrl: Assets.images.tourism2.path,
      address: 'الخليج الغربي، الدوحة',
      rating: 4.8,
      distance: '5.5 كم',
      category: 'معالم أثرية',
      hours: 'مفتوح دائماً',
      features: const [
        ServiceFeature(icon: Iconsax.teacher, label: 'ملتقى الثقافات والفنون'),
        ServiceFeature(
          icon: Iconsax.favorite_chart,
          label: 'المسرح الروماني المفتوح',
        ),
      ],
    ),
    // 3. متحف الفن الإسلامي
    BaseServiceItem(
      name: 'متحف الفن الإسلامي',
      imageUrl: Assets.images.tourism3.path,
      address: 'كورنيش الدوحة، الدوحة',
      rating: 4.9,
      distance: '1.5 كم',
      category: 'متاحف وفنون',
      hours: '09:00 ص - 07:00 م',
      features: const [
        ServiceFeature(
          icon: Iconsax.crown,
          label: 'أيقونة معمارية من تصميم آي إم بي',
        ),
        ServiceFeature(
          icon: Iconsax.card_receive,
          label: 'دخول مجاني للمقيمين',
        ),
      ],
    ),
    // 4. متحف قطر الوطني
    BaseServiceItem(
      name: 'متحف قطر الوطني (وردة الصحراء)',
      imageUrl: Assets.images.tourism4.path,
      address: 'شارع رأس أبو عبود، الدوحة',
      rating: 4.9,
      distance: '2.0 كم',
      category: 'متاحف وفنون',
      hours: '09:00 ص - 07:00 م',
      features: const [
        ServiceFeature(
          icon: Iconsax.building_3,
          label: 'تصميم مستوحى من وردة الصحراء',
        ),
        ServiceFeature(
          icon: Iconsax.video_play,
          label: 'صالات عرض تفاعلية مميزة',
        ),
      ],
    ),
    // 5. جزيرة اللؤلؤة (The Pearl-Qatar)
    BaseServiceItem(
      name: 'جزيرة اللؤلؤة',
      imageUrl: Assets.images.tourism5.path,
      address: 'الخليج الغربي، الدوحة',
      rating: 4.8,
      distance: '8.0 كم',
      category: 'شواطئ وجزر',
      hours: 'مفتوح دائماً',
      features: const [
        ServiceFeature(
          icon: Iconsax.ship,
          label: 'مرسى يخوت فاخر وقنوات مائية',
        ),
        ServiceFeature(
          icon: Iconsax.shop,
          label: 'أفخم الماركات والمطاعم العالمية',
        ),
      ],
    ),
    // 6. حديقة أسباير
    BaseServiceItem(
      name: 'حديقة أسباير',
      imageUrl: Assets.images.tourism6.path,
      address: 'منطقة أسباير زون، الوعب',
      rating: 4.7,
      distance: '6.5 كم',
      category: 'حدائق ومنتزهات',
      hours: 'مفتوح دائماً',
      features: const [
        ServiceFeature(
          icon: Iconsax.activity,
          label: 'مضامير للمشي والركض وركوب الدراجات',
        ),
        ServiceFeature(
          icon: Iconsax.sun_1,
          label: 'بحيرة كبيرة مع قوارب صغيرة للتجديف',
        ),
      ],
    ),
    // 7. شاطئ سيلين والكثبان الرملية
    BaseServiceItem(
      name: 'شاطئ وكثبان سيلين الرملية',
      imageUrl: Assets.images.tourism7.path,
      address: 'منطقة مسيعيد، جنوب قطر',
      rating: 4.6,
      distance: '45.0 كم',
      category: 'شواطئ وجزر',
      hours: 'مفتوح دائماً',
      features: const [
        ServiceFeature(
          icon: Iconsax.routing,
          label: 'ركوب الجمال وقيادة سيارات الدفع الرباعي',
        ),
        ServiceFeature(
          icon: Iconsax.cloud_sunny,
          label: 'موقع تخييم شتوي مثالي',
        ),
      ],
    ),
  ];
}
