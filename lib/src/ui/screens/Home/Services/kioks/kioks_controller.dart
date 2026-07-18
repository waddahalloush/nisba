import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/generated/assets.gen.dart'; // تأكد من استيراد الـ Assets الخاص بمشروعك
import '../../../../../data/models/service_model.dart';
import '../Base Service/base_service_controller.dart';


class KioskController extends BaseServiceController {
  
  // ── 1. تصنيفات الأكشاك في قطر ──
  @override
  final List<ServiceCategory> categories = const [
    ServiceCategory(name: 'الكل', icon: Iconsax.category),
    ServiceCategory(name: 'قهوة وعصائر', icon: Iconsax.coffee),
    ServiceCategory(name: 'وجبات خفيفة', icon: Iconsax.cake),
    ServiceCategory(name: 'أكشاك خدمية', icon: Iconsax.info_circle),
    ServiceCategory(name: 'هدايا سريعة', icon: Iconsax.gift),
  ];

  // ── 2. الأكشاك المميزة (الظاهرة في السكرول الأفقي العلوي) ──
  @override
  final List<BaseServiceItem> featuredItems = [
    BaseServiceItem(
      name: 'كشك قهوة "أوكتان"',
      imageUrl: Assets.images.kiosk1.path, // استخدم المسار المناسب للصور لديك
      address: 'ممشى مارينا لوسيل، قطر',
      rating: 4.8,
      distance: '2.0 كم',
      category: 'قهوة وعصائر',
      hours: '06:00 ص - 02:00 ص',
      features: const [
        ServiceFeature(icon: Iconsax.coffee, label: 'مختص بالقهوة المختصة الباردة والساخنة'),
        ServiceFeature(icon: Iconsax.sun_1, label: 'جلسات خارجية مطلة على اليخوت'),
      ],
    ),
    BaseServiceItem(
      name: 'كشك كريب أند جو',
      imageUrl: Assets.images.kiosk3.path,
      address: 'حديقة أسباير، الدوحة',
      rating: 4.6,
      distance: '5.1 كم',
      category: 'وجبات خفيفة',
      hours: '03:00 م - 12:00 ص',
      features: const [
        ServiceFeature(icon: Iconsax.cake, label: 'كريب ووافل طازج ولذيذ'),
        ServiceFeature(icon: Iconsax.people, label: 'مناسب جداً للأطفال والعائلات بالحديقة'),
      ],
    ),
    BaseServiceItem(
      name: 'كشك معلومات',
      imageUrl: Assets.images.kiosk2.path,
      address: 'سوق واقف، الدوحة (بالقرب من الحصان السلكي)',
      rating: 4.9,
      distance: '0.5 كم',
      category: 'أكشاك خدمية',
      hours: '09:00 ص - 09:00 م',
      features: const [
        ServiceFeature(icon: Iconsax.info_circle, label: 'إرشاد سياحي وتوفير خرائط تفاعلية'),
        ServiceFeature(icon: Iconsax.ticket, label: 'حجز جولات سياحية سريعة ورحلات سفاري'),
      ],
    ),
  ];

  // ── 3. قائمة جميع الأكشاك (الظاهرة في القائمة الرأسية) ──
  @override
  final List<BaseServiceItem> allItems = [
    // 1. كشك أوكتان
    BaseServiceItem(
      name: 'كشك قهوةأوكتان',
      imageUrl: Assets.images.kiosk1.path,
      address: 'ممشى مارينا لوسيل، قطر',
      rating: 4.8,
      distance: '2.0 كم',
      category: 'قهوة وعصائر',
      hours: '06:00 ص - 02:00 ص',
      features: const [
        ServiceFeature(icon: Iconsax.flash_1, label: 'خدمة سريعة وممتازة لرياضيي الممشى'),
        ServiceFeature(icon: Iconsax.sun_1, label: 'إطلالة بحرية رائعة على مارينا لوسيل'),
      ],
    ),
    // 2. كريب أند جو
    BaseServiceItem(
      name: 'كشك كريب أند جو',
      imageUrl: Assets.images.kiosk3.path,
      address: 'حديقة أسباير، الدوحة',
      rating: 4.6,
      distance: '5.1 كم',
      category: 'وجبات خفيفة',
      hours: '03:00 م - 12:00 ص',
      features: const [
        ServiceFeature(icon: Iconsax.box, label: 'تغليف مميز مناسب للتناول أثناء المشي'),
        ServiceFeature(icon: Iconsax.coffee, label: 'يتوفر مشروبات باردة ومثلجة مرافقة للوجبات'),
      ],
    ),
    // 3. كشك معلومات اكتشف قطر
    BaseServiceItem(
      name: 'كشك معلومات',
      imageUrl: Assets.images.kiosk2.path,
      address: 'سوق واقف، الدوحة',
      rating: 4.9,
      distance: '0.5 كم',
      category: 'أكشاك خدمية',
      hours: '09:00 ص - 09:00 م',
      features: const [
        ServiceFeature(icon: Iconsax.user_tag, label: 'مرشدون يتحدثون لغات متعددة لخدمة السياح'),
        ServiceFeature(icon: Iconsax.receipt_21, label: 'توفير الكتيبات والخرائط الإرشادية مجاناً'),
      ],
    ),
    // 4. كشك كرك الكورنيش (Karak Kiosk)
    BaseServiceItem(
      name: 'شاي كرك النعيمي والسندويشات',
      imageUrl: Assets.images.kiosk4.path,
      address: 'فرع كورنيش الدوحة، قطر',
      rating: 4.7,
      distance: '1.2 كم',
      category: 'قهوة وعصائر',
      hours: 'مفتوح 24 ساعة',
      features: const [
        ServiceFeature(icon: Iconsax.coffee, label: 'أشهر شاي كرك هيل وزعفران أصيل ومميز'),
        ServiceFeature(icon: Iconsax.routing, label: 'خدمة سيارات (Drive-thru) سريعة وممتازة'),
      ],
    ),
    // 5. كشك آيس كريم "مادو" (Mado Ice Cream)
    BaseServiceItem(
      name: 'آيس كريم مادو التركي',
      imageUrl: Assets.images.kiosk5.path,
      address: 'جزيرة اللؤلؤة، بورتو أرابيا',
      rating: 4.8,
      distance: '8.0 كم',
      category: 'وجبات خفيفة',
      hours: '01:00 م - 01:00 ص',
      features: const [
        ServiceFeature(icon: Iconsax.magicpen, label: 'عروض تحضير الآيس كريم التركي الاستعراضية'),
        ServiceFeature(icon: Iconsax.cup, label: 'نكهات طبيعية متنوعة وممتازة'),
      ],
    ),
    // 6. كشك بيع الورود والهدايا السريعة
    BaseServiceItem(
      name: 'زهور الفصول الأربعة',
      imageUrl: Assets.images.kiosk6.path,
      address: 'بجوار مستشفى سبيتار، الوعب',
      rating: 4.5,
      distance: '5.5 كم',
      category: 'هدايا سريعة',
      hours: '08:00 ص - 10:00 م',
      features: const [
        ServiceFeature(icon: Iconsax.gift, label: 'تنسيق سريع وباقات ورد جاهزة وهدايا طارئة'),
        ServiceFeature(icon: Iconsax.box_1, label: 'خدمة التوصيل السريع للسيارة'),
      ],
    ),
    // 7. كشك شحن الأجهزة والاتصالات (Ooredoo Kiosk)
    BaseServiceItem(
      name: 'كشك الخدمة الذاتية',
      imageUrl: Assets.images.kiosk7.path,
      address: 'كتارا، الممشى الرئيسي، الدوحة',
      rating: 4.7,
      distance: '6.0 كم',
      category: 'أكشاك خدمية',
      hours: 'مفتوح 24 ساعة',
      features: const [
        ServiceFeature(icon: Iconsax.simcard, label: 'إصدار وتفعيل شرائح الاتصال والإنترنت فورا'),
        ServiceFeature(icon: Iconsax.card, label: 'دفع الفواتير وتعبئة الرصيد بالبطاقة الذكية'),
      ],
    ),
  ];
}