import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/generated/assets.gen.dart'; // تأكد من استيراد الـ Assets الخاص بمشروعك

import '../../../../../data/models/service_model.dart';
import '../Base Service/base_service_controller.dart';

class BeautyController extends BaseServiceController {
  // ── 1. تصنيفات التجميل والعناية في قطر ──
  @override
  final List<ServiceCategory> categories = const [
    ServiceCategory(name: 'الكل', icon: Iconsax.category),
    ServiceCategory(name: 'صالونات نسائية', icon: Iconsax.woman),
    ServiceCategory(name: 'صالونات رجالية', icon: Iconsax.man),
    ServiceCategory(name: 'سبا واسترخاء', icon: Iconsax.cloud_sunny),
    ServiceCategory(name: 'مستحضرات تجميل', icon: Iconsax.award),
  ];

  // ── 2. المراكز المميزة (الظاهرة في السكرول الأفقي العلوي) ──
  @override
  final List<BaseServiceItem> featuredItems = [
    BaseServiceItem(
      name: 'سبا جورلان الفاخر',
      imageUrl: Assets.images.beauty1.path, // استخدم المسار المناسب للصور لديك
      address: 'أبراج الفردان، الخليج الغربي، الدوحة',
      rating: 4.9,
      distance: '3.2 كم',
      category: 'سبا واسترخاء',
      hours: '09:00 ص - 10:00 م',
      features: const [
        ServiceFeature(
          icon: Iconsax.magicpen,
          label: 'أرقى علاجات العناية بالبشرة والوجه',
        ),
        ServiceFeature(
          icon: Iconsax.shield_security,
          label: 'أجنحة خاصة وهدوء تام',
        ),
      ],
    ),
    BaseServiceItem(
      name: 'صالون روتس للتجميل',
      imageUrl: Assets.images.beauty2.path,
      address: 'منطقة الدحيل، الدوحة',
      rating: 4.8,
      distance: '6.5 كم',
      category: 'صالونات نسائية',
      hours: '09:00 ص - 08:00 م',
      features: const [
        ServiceFeature(
          icon: Iconsax.scissor,
          label: 'خبيرات تصفيف شعر وصبغات عالميات',
        ),
        ServiceFeature(
          icon: Iconsax.verify,
          label: 'منتجات عضوية وآمنة بالكامل للجمال',
        ),
      ],
    ),
    BaseServiceItem(
      name: 'صالون جنتلمانز ترست',
      imageUrl: Assets.images.beauty3.path,
      address: 'بورتو أرابيا، اللؤلؤة، قطر',
      rating: 4.8,
      distance: '8.5 كم',
      category: 'صالونات رجالية',
      hours: '10:00 ص - 10:00 م',
      features: const [
        ServiceFeature(
          icon: Iconsax.man,
          label: 'حلاقة ذقن وعناية كلاسيكية فاخرة للرجال',
        ),
        ServiceFeature(
          icon: Iconsax.coffee,
          label: 'استراحة خاصة تقدم القهوة المختصة والسيجار',
        ),
      ],
    ),
  ];

  // ── 3. قائمة جميع مراكز التجميل والعناية (الظاهرة في القائمة الرأسية) ──
  @override
  final List<BaseServiceItem> allItems = [
    // 1. سبا جورلان
    BaseServiceItem(
      name: 'سبا جورلان الفاخر',
      imageUrl: Assets.images.beauty1.path,
      address: 'أبراج الفردان، الخليج الغربي، الدوحة',
      rating: 4.9,
      distance: '3.2 كم',
      category: 'سبا واسترخاء',
      hours: '09:00 ص - 10:00 م',
      features: const [
        ServiceFeature(
          icon: Iconsax.star_1,
          label: 'منتجات حصرية فرنسية الصنع 100%',
        ),
        ServiceFeature(
          icon: Iconsax.activity,
          label: 'جلسات مساج واسترخاء على أيدي خبراء',
        ),
      ],
    ),
    // 2. صالون روتس
    BaseServiceItem(
      name: 'صالون روتس للتجميل',
      imageUrl: Assets.images.beauty2.path,
      address: 'منطقة الدحيل، الدوحة',
      rating: 4.8,
      distance: '6.5 كم',
      category: 'صالونات نسائية',
      hours: '09:00 ص - 08:00 م',
      features: const [
        ServiceFeature(
          icon: Iconsax.ranking,
          label: 'حائز على جوائز أفضل صالون في قطر',
        ),
        ServiceFeature(
          icon: Iconsax.box_1,
          label: 'ركن خاص لخدمات المانيكير والباديكير',
        ),
      ],
    ),
    // 3. صالون وجنتلمانز ترست
    BaseServiceItem(
      name: 'صالون جنتلمانز ترست',
      imageUrl: Assets.images.beauty3.path,
      address: 'بورتو أرابيا، اللؤلؤة، قطر',
      rating: 4.8,
      distance: '8.5 كم',
      category: 'صالونات رجالية',
      hours: '10:00 ص - 10:00 م',
      features: const [
        ServiceFeature(
          icon: Iconsax.profile_circle,
          label: 'خدمات متكاملة للعناية بالوجه واليدين',
        ),
        ServiceFeature(
          icon: Iconsax.crown,
          label: 'اشتراكات وعروض سنوية حصرية للأعضاء',
        ),
      ],
    ),
    // 4. متجر سيفورا (Sephora)
    BaseServiceItem(
      name: 'سيفورا',
      imageUrl: Assets.images.beauty4.path,
      address: 'بلاس فاندوم مول، لوسيل',
      rating: 4.9,
      distance: '9.5 كم',
      category: 'مستحضرات تجميل',
      hours: '10:00 ص - 11:00 م',
      features: const [
        ServiceFeature(
          icon: Iconsax.award,
          label: 'أحدث عطور ومستحضرات تجميل الماركات العالمية',
        ),
        ServiceFeature(
          icon: Iconsax.magicpen,
          label: 'خبراء تجميل متواجدون للمساعدة وتجربة المكياج',
        ),
      ],
    ),
    // 5. صالون ألدو كوبولا (Aldo Coppola)
    BaseServiceItem(
      name: 'صالون ألدو كوبولا الفاخر',
      imageUrl: Assets.images.beauty5.path,
      address: 'الحزم مول، الدوحة',
      rating: 4.7,
      distance: '4.2 كم',
      category: 'صالونات نسائية',
      hours: '10:00 ص - 09:00 م',
      features: const [
        ServiceFeature(
          icon: Iconsax.crown,
          label: 'صالون إيطالي عالمي يدمج الفن بالتجميل',
        ),
        ServiceFeature(
          icon: Iconsax.magicpen,
          label: 'علاجات وتقنيات متطورة للشعر والبشرة',
        ),
      ],
    ),
    // 6. سبا ومنتجع الشرق (Sharq Village Spa)
    BaseServiceItem(
      name: 'سبا ريتز كارلتون',
      imageUrl: Assets.images.beauty6.path,
      address: 'منطقة رأس أبو عبود، الدوحة',
      rating: 4.9,
      distance: '2.2 كم',
      category: 'سبا واسترخاء',
      hours: '09:00 ص - 11:00 م',
      features: const [
        ServiceFeature(
          icon: Iconsax.house,
          label: 'تصميم مستوحى من القرى العربية التقليدية',
        ),
        ServiceFeature(
          icon: Iconsax.sun_1,
          label: 'مسبح سبا مخصص وغرف طمي وحمام تركي ونادٍ صحي',
        ),
      ],
    ),
    // 7. صالون وسبا شوغار (Sugar Beauty Lounge)
    BaseServiceItem(
      name: 'صالون شوغار ',
      imageUrl: Assets.images.beauty7.path,
      address: 'حديقة أسباير، الدوحة',
      rating: 4.6,
      distance: '5.5 كم',
      category: 'صالونات نسائية',
      hours: '10:00 ص - 09:00 م',
      features: const [
        ServiceFeature(
          icon: Iconsax.box_1,
          label: 'مختص بتركيب وتزيين الأظافر والرموش',
        ),
        ServiceFeature(
          icon: Iconsax.routing,
          label: 'إمكانية الحجز المسبق الفوري',
        ),
      ],
    ),
  ];
}
