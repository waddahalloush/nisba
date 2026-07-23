import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/generated/assets.gen.dart';
import '../../../../../data/models/service_model.dart';
import '../Base Service/base_service_controller.dart';
import 'package:get/get.dart';

class KioskController extends BaseServiceController {
  
  @override
  Future<void> fetchData() async {
    isLoading.value = true;

    try {
      // محاكاة تأخير جلب البيانات من السيرفر (API)
      await Future.delayed(const Duration(milliseconds: 800));

      // ── 1. تعبئة تصنيفات الأكشاك في قطر ──
      categories.assignAll(const [
        ServiceCategory(name: 'الكل', icon: Iconsax.category),
        ServiceCategory(name: 'قهوة وعصائر', icon: Iconsax.coffee),
        ServiceCategory(name: 'وجبات خفيفة', icon: Iconsax.cake),
        ServiceCategory(name: 'أكشاك خدمية', icon: Iconsax.info_circle),
        ServiceCategory(name: 'هدايا سريعة', icon: Iconsax.gift),
      ]);

      // ── 2. تعبئة قائمة جميع الأكشاك (allItems) ──
      allItems.assignAll([
        // 1. كشك أوكتان
        BaseServiceItem(
          id: 'k1',
          name: 'كشك قهوة "أوكتان"',
          subTitle: 'محطة مميزة للقهوة المختصة والمشروبات المنعشة',
          aboutText: 'كشك أوكتان يقدم أروع تشكيلة من القهوة المختصة الباردة والساخنة مع جلسات خارجية رائعة مطلة على مارينا لوسيل لرياضيي الممشى والزوار.',
          imageUrl: Assets.images.kiosk1.path,
          address: 'ممشى مارينا لوسيل، قطر',
          rating: 4.8,
          reviewsCount: 420,
          distance: '2.0 كم',
          category: 'قهوة وعصائر',
          serviceType: 'Kioks',
          hours: '06:00 ص - 02:00 ص',
          features: const [
            ServiceFeature(icon: Iconsax.coffee, label: 'مختص بالقهوة المختصة الباردة والساخنة'),
            ServiceFeature(icon: Iconsax.sun_1, label: 'جلسات خارجية مطلة على اليخوت'),
            ServiceFeature(icon: Iconsax.flash_1, label: 'خدمة سريعة وممتازة لرياضيي الممشى'),
          ],
          productsOrServices: const [
            ServiceSubItem(
              id: 'ks1',
              name: 'سبانيش لاتيه بارد',
              description: 'إسبريسو مع حليب محلى ونكهة أوكتان الخاصة',
              price: 28.0,
              imageUrl: 'https://images.unsplash.com/photo-1517701604599-bb29b565090c?w=500&q=80',
              extraInfo: 'الحجم الكبير',
            ),
          ],
        ),

        // 2. كشك كريب أند جو
        BaseServiceItem(
          id: 'k2',
          name: 'كشك كريب أند جو',
          subTitle: 'ألذ وجبات الكريب والوافل الطازجة في حديقة أسباير',
          aboutText: 'وجهتك المثالية للحصول على وجبات خفيفة وحلويات طازجة ولذيذة، مع تغليف مميز مناسب للتناول أثناء التنزه في حديقة أسباير.',
          imageUrl: Assets.images.kiosk3.path,
          address: 'حديقة أسباير، الدوحة',
          rating: 4.6,
          reviewsCount: 310,
          distance: '5.1 كم',
          category: 'وجبات خفيفة',
          serviceType: 'Kioks',
          hours: '03:00 م - 12:00 ص',
          features: const [
            ServiceFeature(icon: Iconsax.cake, label: 'كريب ووافل طازج ولذيذ'),
            ServiceFeature(icon: Iconsax.people, label: 'مناسب جداً للأطفال والعائلات بالحديقة'),
            ServiceFeature(icon: Iconsax.box, label: 'تغليف مميز مناسب للتناول أثناء المشي'),
          ],
          productsOrServices: const [
            ServiceSubItem(
              id: 'ks2',
              name: 'كريب بالشوكولاتة الفاخرة',
              description: 'كريب طازج محشو بنكهة الشوكولاتة البلجيكية الغنية',
              price: 35.0,
              imageUrl: 'https://images.unsplash.com/photo-1519671482749-fd09be7ccebf?w=500&q=80',
              extraInfo: 'مضاف إليه قطع الفراولة',
            ),
          ],
        ),

        // 3. كشك معلومات
        BaseServiceItem(
          id: 'k3',
          name: 'كشك معلومات',
          subTitle: 'إرشاد سياحي وخدمات متكاملة في قلب سوق واقف',
          aboutText: 'يوفر الكشك إرشاداً سياحياً شاملاً، وخرائط تفاعلية، وخدمة حجز الجولات السياحية السريعة ورحلات السفاري لزوار سوق واقف.',
          imageUrl: Assets.images.kiosk2.path,
          address: 'سوق واقف، الدوحة (بالقرب من الحصان السلكي)',
          rating: 4.9,
          reviewsCount: 890,
          distance: '0.5 كم',
          category: 'أكشاك خدمية',
          serviceType: 'Kioks',
          hours: '09:00 ص - 09:00 م',
          features: const [
            ServiceFeature(icon: Iconsax.info_circle, label: 'إرشاد سياحي وتوفير خرائط تفاعلية'),
            ServiceFeature(icon: Iconsax.ticket, label: 'حجز جولات سياحية سريعة ورحلات سفاري'),
            ServiceFeature(icon: Iconsax.user_tag, label: 'مرشدون يتحدثون لغات متعددة لخدمة السياح'),
          ],
        ),

        // 4. شاي كرك النعيمي والسندويشات
        BaseServiceItem(
          id: 'k4',
          name: 'شاي كرك النعيمي والسندويشات',
          subTitle: 'أشهر شاي كرك هيل وزعفران أصيل على كورنيش الدوحة',
          aboutText: 'كشك شهير يقدم شاي الكرك الأصيل بمذاق الزعفران والهيل المميز، مع خدمة السيارات (Drive-thru) السريعة والسندويشات الخفيفة على الكورنيش.',
          imageUrl: Assets.images.kiosk4.path,
          address: 'فرع كورنيش الدوحة، قطر',
          rating: 4.7,
          reviewsCount: 1540,
          distance: '1.2 كم',
          category: 'قهوة وعصائر',
          serviceType: 'Kioks',
          hours: 'مفتوح 24 ساعة',
          features: const [
            ServiceFeature(icon: Iconsax.coffee, label: 'أشهر شاي كرك هيل وزعفران أصيل ومميز'),
            ServiceFeature(icon: Iconsax.routing, label: 'خدمة سيارات (Drive-thru) سريعة وممتازة'),
          ],
          productsOrServices: const [
            ServiceSubItem(
              id: 'ks3',
              name: 'دلة شاي كرك بالزعفران',
              description: 'دلة كرك أصيلة تكفي لعدة أشخاص بنكهة الهيل والزعفران',
              price: 25.0,
              imageUrl: 'https://images.unsplash.com/photo-1576092768241-dec231879fc3?w=500&q=80',
              extraInfo: 'تكفي 4 أشخاص',
            ),
          ],
        ),

        // 5. آيس كريم مادو التركي
        BaseServiceItem(
          id: 'k5',
          name: 'آيس كريم مادو التركي',
          subTitle: 'النكهة التركية الأصيلة والعروض الاستعراضية في اللؤلؤة',
          aboutText: 'استمتع بطعم الآيس كريم التركي الغني بالمستكة والطبيعي 100% مع العروض الاستعراضية الممتعة في بورتو أرابيا جزيرة اللؤلؤة.',
          imageUrl: Assets.images.kiosk5.path,
          address: 'جزيرة اللؤلؤة، بورتو أرابيا',
          rating: 4.8,
          reviewsCount: 620,
          distance: '8.0 كم',
          category: 'وجبات خفيفة',
          serviceType: 'Kioks',
          hours: '01:00 م - 01:00 ص',
          features: const [
            ServiceFeature(icon: Iconsax.magicpen, label: 'عروض تحضير الآيس كريم التركي الاستعراضية'),
            ServiceFeature(icon: Iconsax.cup, label: 'نكهات طبيعية متنوعة وممتازة'),
          ],
          productsOrServices: const [
            ServiceSubItem(
              id: 'ks4',
              name: 'مواضع آيس كريم مادو مشكل',
              description: 'ثلاث نكهات مختارة من الآيس كريم التركي الأصيل',
              price: 30.0,
              imageUrl: 'https://images.unsplash.com/photo-1497215728101-856f4ea42174?w=500&q=80',
              extraInfo: 'مع الفستق الحلبي',
            ),
          ],
        ),

        // 6. زهور الفصول الأربعة
        BaseServiceItem(
          id: 'k6',
          name: 'زهور الفصول الأربعة',
          subTitle: 'تنسيق سريع لباقات الورد والهدايا الطارئة',
          aboutText: 'كشك خدمات وتنسيق سريع للزهور والباقات جاهزة للاختيار، يقع بالقرب من مستشفى سبيتار لتلبية الهدايا الطارئة والزيارات.',
          imageUrl: Assets.images.kiosk6.path,
          address: 'بجوار مستشفى سبيتار، الوعب',
          rating: 4.5,
          reviewsCount: 210,
          distance: '5.5 كم',
          category: 'هدايا سريعة',
          serviceType: 'Kioks',
          hours: '08:00 ص - 10:00 م',
          features: const [
            ServiceFeature(icon: Iconsax.gift, label: 'تنسيق سريع وباقات ورد جاهزة وهدايا طارئة'),
            ServiceFeature(icon: Iconsax.box_1, label: 'خدمة التوصيل السريع للسيارة'),
          ],
        ),

        // 7. كشك الخدمة الذاتية (Ooredoo)
        BaseServiceItem(
          id: 'k7',
          name: 'كشك الخدمة الذاتية',
          subTitle: 'إصدار الشرائح ودفع الفواتير فوراً في كتارا',
          aboutText: 'أكشاك ذكية تتيح للعملاء إصدار وتفعيل شرائح الاتصال والإنترنت، ودفع الفواتير، وتعبئة الرصيد بالبطاقة الذكية على مدار الساعة.',
          imageUrl: Assets.images.kiosk7.path,
          address: 'كتارا، الممشى الرئيسي، الدوحة',
          rating: 4.7,
          reviewsCount: 430,
          distance: '6.0 كم',
          category: 'أكشاك خدمية',
          serviceType: 'Kioks',
          hours: 'مفتوح 24 ساعة',
          features: const [
            ServiceFeature(icon: Iconsax.simcard, label: 'إصدار وتفعيل شرائح الاتصال والإنترنت فورا'),
            ServiceFeature(icon: Iconsax.card, label: 'دفع الفواتير وتعبئة الرصيد بالبطاقة الذكية'),
          ],
        ),
      ]);

      // ── 3. تحديد العناصر المميزة (Featured Items) ──
      featuredItems.assignAll(allItems.take(3).toList());

    } catch (e) {
      errorMessage.value = 'حدث خطأ أثناء جلب البيانات: $e';
    } finally {
      isLoading.value = false;
    }
  }
}