import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/generated/assets.gen.dart'; // تأكد من استيراد الـ Assets الخاص بمشروعك[cite: 21]
import '../../../../../data/models/service_model.dart';
import '../Base Service/base_service_controller.dart';

class HotelController extends BaseServiceController {
  
  @override
  Future<void> fetchData() async {
    isLoading.value = true;

    try {
      // محاكاة تأخير جلب البيانات من السيرفر (API)
      await Future.delayed(const Duration(milliseconds: 800));

      // ── 1. تعبئة تصنيفات الفنادق والإقامة في قطر ──[cite: 21]
      categories.assignAll(const [
        ServiceCategory(name: 'الكل', icon: Iconsax.category),
        ServiceCategory(name: 'منتجعات شاطئية', icon: Iconsax.sun_1),
        ServiceCategory(name: 'فنادق 5 نجوم', icon: Iconsax.crown),
        ServiceCategory(name: 'فنادق 4 نجوم', icon: Iconsax.award),
        ServiceCategory(name: 'شقق فندقية', icon: Iconsax.house),
      ]);

      // ── 2. تعبئة قائمة جميع الفنادق (allItems) ──[cite: 21]
      allItems.assignAll([
        // 1. جزيرة الموز
        BaseServiceItem(
          id: 'h1',
          name: 'جزيرة الموز',
          subTitle: 'منتجع استوائي فاخر على جزيرة خاصة قبالة الدوحة',
          aboutText: 'ملاذ هادئ وراقي يبعد دقائق بالمركب عن وسط الدوحة، يقدم فيلات فاخرة فوق الماء، شاطئاً رملياً خاصاً، وأنشطة ترفيهية متكاملة للعائلات والأزواج.',
          imageUrl: Assets.images.hotel1.path, //[cite: 21]
          address: 'جزيرة الموز، قبالة كورنيش الدوحة',
          rating: 4.9,
          reviewsCount: 1850,
          distance: '11.0 كم (بالقارب)',
          category: 'منتجعات شاطئية',
          serviceType: 'Hotel',
          hours: 'استقبال 24 ساعة',
          features: const [
            ServiceFeature(icon: Iconsax.sun_1, label: 'شاطئ خاص ممتد'),
            ServiceFeature(icon: Iconsax.activity, label: 'فيلات فوق الماء ومسبح أمواج'),
            ServiceFeature(icon: Iconsax.shield_security, label: 'خصوصية تامة وهدوء مثالي'),
          ],
          productsOrServices: const [
            ServiceSubItem(
              id: 'hs1',
              name: 'فيلا غرفة نوم واحدة مع مسبح',
              description: 'فيلا فاخرة مطلة على البحر مع مسبح خاص وتراس استرخاء',
              price: 2200.0,
              imageUrl: 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=500&q=80',
              extraInfo: 'يشمل الإفطار لشخصين',
            ),
          ],
        ),

        // 2. مرسى ملاذ كمبينسكي
        BaseServiceItem(
          id: 'h2',
          name: 'مرسى ملاذ كمبينسكي',
          subTitle: 'قصر أوروبي فاخر في جزيرة اللؤلؤة',
          aboutText: 'يجمع هذا الفندق الفخم بين الهندسة المعمارية الأوروبية التقليدية والضيافة العربية الأصيلة، ويضم شاطئاً خاصاً، ومطاعم عالمية حائزة على جوائز.',
          imageUrl: Assets.images.hotel2.path, //[cite: 21]
          address: 'جزيرة اللؤلؤة، الدوحة',
          rating: 4.8,
          reviewsCount: 1420,
          distance: '8.2 كم',
          category: 'منتجعات شاطئية',
          serviceType: 'Hotel',
          hours: 'استقبال 24 ساعة',
          features: const [
            ServiceFeature(icon: Iconsax.crown, label: 'تصميم قصر أوروبي فاخر'),
            ServiceFeature(icon: Iconsax.cup, label: 'مطاعم حائزة على جوائز'),
            ServiceFeature(icon: Iconsax.coffee, label: 'سبا هادئ ونادٍ صحي متكامل'),
          ],
          productsOrServices: const [
            ServiceSubItem(
              id: 'hs2',
              name: 'غرفة ديلوكس إطلالة على البحر',
              description: 'غرفة واسعة بتصميم كلاسيكي فاخر وإطلالة خلابة على الخليج',
              price: 1350.0,
              imageUrl: 'https://images.unsplash.com/photo-1591088398332-8a7791972843?w=500&q=80',
              extraInfo: 'سرير كينغ مزدوج',
            ),
          ],
        ),

        // 3. موندريان الدوحة
        BaseServiceItem(
          id: 'h3',
          name: 'موندريان الدوحة',
          subTitle: 'تحفة فنية بتصميم عصري مذهل في لوسيل',
          aboutText: 'فندق يجسد الخيال والفن الحديث في كل زاوية، يتميز بديكوراته الاستثنائية، ومسبح بانورامي على السطح، ومطاعم عالمية فريدة.',
          imageUrl: Assets.images.hotel3.path, //[cite: 21]
          address: 'منطقة غرب خليج لوسيل، الدوحة',
          rating: 4.8,
          reviewsCount: 1100,
          distance: '9.0 كم',
          category: 'فنادق 5 نجوم',
          serviceType: 'Hotel',
          hours: 'استقبال 24 ساعة',
          features: const [
            ServiceFeature(icon: Iconsax.paintbucket, label: 'تصميم داخلي عصري مذهل'),
            ServiceFeature(icon: Iconsax.music, label: 'حمام سباحة بانورامي في السطح'),
            ServiceFeature(icon: Iconsax.flash_1, label: 'قاعة احتفالات ضخمة وراقية'),
          ],
          productsOrServices: const [
            ServiceSubItem(
              id: 'hs3',
              name: 'غرفة سوبيريور عصرية',
              description: 'تصميم فني فريد مع أثاث مصمم خصيصاً ووسائل راحة ذكية',
              price: 1100.0,
              imageUrl: 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?w=500&q=80',
              extraInfo: 'شامل الفطور',
            ),
          ],
        ),

        // 4. شيراتون جراند الدوحة
        BaseServiceItem(
          id: 'h4',
          name: 'شيراتون جراند',
          subTitle: 'أيقونة الدوحة التراثية على الكورنيش',
          aboutText: 'الفندق الهرمي الشهير الذي يعد جزءاً من تاريخ قطر الحديث، يتميز بموقعه الاستراتيجي على الكورنيش وحدائقه الواسعة ومرافق المؤتمرات الضخمة.',
          imageUrl: Assets.images.hotel4.path, //[cite: 21]
          address: 'كورنيش الدوحة، الخليج الغربي',
          rating: 4.9,
          reviewsCount: 2100,
          distance: '3.0 كم',
          category: 'منتجعات شاطئية',
          serviceType: 'Hotel',
          hours: 'استقبال 24 ساعة',
          features: const [
            ServiceFeature(icon: Iconsax.map, label: 'أيقونة الدوحة التراثية على الكورنيش'),
            ServiceFeature(icon: Iconsax.tree, label: 'حدائق واسعة ممتدة وملاعب تنس'),
          ],
          productsOrServices: const [
            ServiceSubItem(
              id: 'hs4',
              name: 'غرفة مطلة على الخليج العربي',
              description: 'استمتع بإطلالة بانورامية ساحرة على أفق الدوحة البحري',
              price: 1200.0,
              imageUrl: 'https://images.unsplash.com/photo-1578683010236-d716f9a3f461?w=500&q=80',
              extraInfo: 'إطلالة بحرية مباشرة',
            ),
          ],
        ),

        // 5. راديسون بلو
        BaseServiceItem(
          id: 'h5',
          name: 'راديسون بلو',
          subTitle: 'موقع حيوي وخيارات ضيافة واسعة وسط الدوحة',
          aboutText: 'فندق عريق يوفر راحة متكاملة وموقعاً مركزياً قريباً من أهم معالم المدينة، مع أكثر من 10 مطاعم وبارات تقدم أطباقاً عالمية متنوعة.',
          imageUrl: Assets.images.hotel5.path, //[cite: 21]
          address: 'تقاطع طريق سلوى مع الدائري الثالث',
          rating: 4.5,
          reviewsCount: 950,
          distance: '2.5 كم',
          category: 'فنادق 4 نجوم',
          serviceType: 'Hotel',
          hours: 'استقبال 24 ساعة',
          features: const [
            ServiceFeature(icon: Iconsax.routing, label: 'موقع حيوي ممتاز وسط العاصمة'),
            ServiceFeature(icon: Iconsax.coffee, label: 'أكثر من 10 مطاعم تقدم أطباق متنوعة'),
          ],
        ),

        // 6. فريزر سويتس
        BaseServiceItem(
          id: 'h6',
          name: 'فريزر سويتس',
          subTitle: 'شقق فندقية واسعة ومجهزة للعائلات على الكورنيش',
          aboutText: 'الخيار الأمثل للعائلات التي تبحث عن الفخامة والمساحات الواسعة، مع إطلالات رائعة على كورنيش الدوحة ومرافق ترفيهية للأطفال.',
          imageUrl: Assets.images.hotel6.path, //[cite: 21]
          address: 'طريق الكورنيش، الدوحة',
          rating: 4.6,
          reviewsCount: 780,
          distance: '1.2 كم',
          category: 'شقق فندقية',
          serviceType: 'Hotel',
          hours: 'استقبال 24 ساعة',
          features: const [
            ServiceFeature(icon: Iconsax.house, label: 'شقق واسعة ومجهزة بالكامل للعائلات'),
            ServiceFeature(icon: Iconsax.teacher, label: 'منطقة لعب مخصصة وآمنة للأطفال'),
          ],
        ),

        // 7. سيتي سنتر روتانا
        BaseServiceItem(
          id: 'h7',
          name: 'سيتي سنتر روتانا',
          subTitle: 'فندق أعمال وتسوق نابض بالحياة في الخليج الغربي',
          aboutText: 'يتميز باتصال مباشر بمجمع سيتي سنتر التجاري وقربه من محطة المترو، مما يجعله الخيار الأول للمسافرين بقصد العمل أو التسوق.',
          imageUrl: Assets.images.hotel7.path, //[cite: 21]
          address: 'الخليج الغربي، الدوحة',
          rating: 4.7,
          reviewsCount: 920,
          distance: '4.0 كم',
          category: 'فنادق 5 نجوم',
          serviceType: 'Hotel',
          hours: 'استقبال 24 ساعة',
          features: const [
            ServiceFeature(icon: Iconsax.shop, label: 'اتصال مباشر بمجمع سيتي سنتر مول'),
            ServiceFeature(icon: Iconsax.activity, label: 'قريب جداً من محطة مترو الخليج الغربي'),
          ],
        ),
      ]);

      // ── 3. تحديد العناصر المميزة (Featured Items) ──
      // تعيين أول 3 فنادق لتظهر في القسم الأفقي العلوي المميز
      featuredItems.assignAll(allItems.take(3).toList());

    } catch (e) {
      errorMessage.value = 'حدث خطأ أثناء جلب البيانات: $e';
    } finally {
      isLoading.value = false;
    }
  }
}