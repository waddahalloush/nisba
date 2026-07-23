import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/generated/assets.gen.dart';

import '../../../../../data/models/service_model.dart';
import '../Base Service/base_service_controller.dart'; 

// تأكد من استيراد مسارات الموديلات والكونترولر الأساسي بشكل صحيح
// import '../../../../../data/models/base_service_model.dart';
// import '../Base Service/base_service_controller.dart';

class BeautyController extends BaseServiceController {
  
  @override
  Future<void> fetchData() async {
    isLoading.value = true;
    
    try {
      // محاكاة تأخير جلب البيانات من السيرفر (API)
      await Future.delayed(const Duration(milliseconds: 800));

      // ── 1. تعبئة تصنيفات التجميل والعناية ──
      categories.assignAll(const [
        ServiceCategory(name: 'الكل', icon: Iconsax.category),
        ServiceCategory(name: 'صالونات نسائية', icon: Iconsax.woman),
        ServiceCategory(name: 'صالونات رجالية', icon: Iconsax.man),
        ServiceCategory(name: 'سبا واسترخاء', icon: Iconsax.cloud_sunny),
        ServiceCategory(name: 'مستحضرات تجميل', icon: Iconsax.award),
      ]);

      // ── 2. تعبئة جميع المراكز (allItems) ──
      allItems.assignAll([
        // 1. سبا جورلان
        BaseServiceItem(
          id: 'b1',
          name: 'سبا جورلان الفاخر',
          subTitle: 'تجربة استرخاء وعناية بالبشرة على الطراز الفرنسي',
          aboutText: 'يعد سبا جورلان وجهة فاخرة للاسترخاء في قلب الدوحة، ويقدم علاجات حصرية للبشرة والجسم باستخدام أحدث تقنيات ومنتجات جورلان العالمية لضمان تجربة لا تُنسى.',
          imageUrl: Assets.images.beauty1.path,
          address: 'أبراج الفردان، الخليج الغربي، الدوحة',
          rating: 4.9,
          reviewsCount: 342,
          distance: '3.2 كم',
          category: 'سبا واسترخاء',
          serviceType: 'Beauty',
          hours: '09:00 ص - 10:00 م',
          features: const [
            ServiceFeature(icon: Iconsax.magicpen, label: 'أرقى علاجات العناية بالبشرة والوجه'),
            ServiceFeature(icon: Iconsax.shield_security, label: 'أجنحة خاصة وهدوء تام'),
            ServiceFeature(icon: Iconsax.star_1, label: 'منتجات حصرية فرنسية الصنع 100%'),
          ],
          productsOrServices: const [
            ServiceSubItem(
              id: 's1',
              name: 'مساج الأحجار الساخنة',
              description: 'جلسة استرخاء عميقة للتخلص من التوتر العضلي',
              price: 450.0,
              imageUrl: 'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?w=500&q=80', //
              extraInfo: '60 دقيقة',
            ),
            ServiceSubItem(
              id: 's2',
              name: 'عناية الوجه الملكية',
              description: 'تنظيف عميق وتغذية للبشرة بمنتجات جورلان',
              price: 600.0,
              imageUrl: 'https://images.unsplash.com/photo-1522337660859-02fbefca4702?w=500&q=80', //[cite: 13]
              extraInfo: '45 دقيقة',
            ),
          ],
        ),

        // 2. صالون روتس
        BaseServiceItem(
          id: 'b2',
          name: 'صالون روتس للتجميل',
          subTitle: 'الوجهة الأولى لأحدث قصات وصبغات الشعر',
          aboutText: 'صالون حائز على عدة جوائز يوفر خدمات متكاملة للعناية بالشعر والبشرة والأظافر تحت إشراف خبيرات تجميل عالميات.',
          imageUrl: Assets.images.beauty2.path,
          address: 'منطقة الدحيل، الدوحة',
          rating: 4.8,
          reviewsCount: 850,
          distance: '6.5 كم',
          category: 'صالونات نسائية',
          serviceType: 'Beauty',
          hours: '09:00 ص - 08:00 م',
          features: const [
            ServiceFeature(icon: Iconsax.scissor, label: 'خبيرات تصفيف شعر وصبغات عالميات'),
            ServiceFeature(icon: Iconsax.verify, label: 'منتجات عضوية وآمنة بالكامل للجمال'),
            ServiceFeature(icon: Iconsax.ranking, label: 'حائز على جوائز أفضل صالون في قطر'),
          ],
          productsOrServices: const [
             ServiceSubItem(
              id: 's3',
              name: 'قص وتصفيف الشعر',
              description: 'أحدث القصات المناسبة لشكل الوجه مع سيشوار',
              price: 250.0,
              imageUrl: 'https://images.unsplash.com/photo-1560066984-138dadb4c035?w=500&q=80', //[cite: 13]
              extraInfo: 'شعر متوسط الطول',
            ),
          ],
        ),

        // 3. صالون جنتلمانز ترست
        BaseServiceItem(
          id: 'b3',
          name: 'صالون جنتلمانز ترست',
          subTitle: 'عناية كلاسيكية فاخرة للرجل العصري',
          aboutText: 'أكثر من مجرد صالون حلاقة، هو نادٍ اجتماعي فاخر للرجال يقدم خدمات الحلاقة الكلاسيكية والعناية بالبشرة مع توفير أجواء استرخاء استثنائية.',
          imageUrl: Assets.images.beauty3.path,
          address: 'بورتو أرابيا، اللؤلؤة، قطر',
          rating: 4.8,
          reviewsCount: 412,
          distance: '8.5 كم',
          category: 'صالونات رجالية',
          serviceType: 'Beauty',
          hours: '10:00 ص - 10:00 م',
          features: const [
            ServiceFeature(icon: Iconsax.man, label: 'حلاقة ذقن وعناية كلاسيكية فاخرة للرجال'),
            ServiceFeature(icon: Iconsax.coffee, label: 'استراحة خاصة تقدم القهوة المختصة والسيجار'),
            ServiceFeature(icon: Iconsax.crown, label: 'اشتراكات وعروض سنوية حصرية للأعضاء'),
          ],
          productsOrServices: const [
            ServiceSubItem(
              id: 's4',
              name: 'حلاقة ملكية للذقن',
              description: 'حلاقة بالمنشفة الساخنة وعناية متكاملة للبشرة',
              price: 120.0,
              imageUrl: 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=500&q=80', //[cite: 13]
              extraInfo: '30 دقيقة',
            ),
          ],
        ),

        // 4. سيفورا
        BaseServiceItem(
          id: 'b4',
          name: 'سيفورا',
          subTitle: 'عالم متكامل من مستحضرات التجميل والعطور',
          aboutText: 'وجهة التسوق الأبرز لأشهر العلامات التجارية في عالم الجمال، توفر كل ما تحتاجينه من مكياج، وعطور، وعناية بالبشرة.',
          imageUrl: Assets.images.beauty4.path,
          address: 'بلاس فاندوم مول، لوسيل',
          rating: 4.9,
          reviewsCount: 1500,
          distance: '9.5 كم',
          category: 'مستحضرات تجميل',
          serviceType: 'Beauty',
          hours: '10:00 ص - 11:00 م',
          features: const [
            ServiceFeature(icon: Iconsax.award, label: 'أحدث عطور ومستحضرات تجميل الماركات العالمية'),
            ServiceFeature(icon: Iconsax.magicpen, label: 'خبراء تجميل متواجدون للمساعدة وتجربة المكياج'),
          ],
          productsOrServices: const [
            ServiceSubItem(
              id: 's5',
              name: 'جلسة استشارة مكياج',
              description: 'جلسة مع خبير تجميل لاختيار المنتجات الأنسب لبشرتك',
              price: 150.0,
              imageUrl: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=500&q=80', //[cite: 13]
              extraInfo: 'يمكن استرداد المبلغ كمنتجات',
            ),
          ],
        ),

        // 5. ألدو كوبولا
        BaseServiceItem(
          id: 'b5',
          name: 'صالون ألدو كوبولا الفاخر',
          subTitle: 'فن التجميل الإيطالي في الدوحة',
          aboutText: 'صالون إيطالي رائد يقدم تقنيات مبتكرة في العناية بالشعر والبشرة، مع التركيز على الجمال الطبيعي والصحي.',
          imageUrl: Assets.images.beauty5.path,
          address: 'الحزم مول، الدوحة',
          rating: 4.7,
          reviewsCount: 220,
          distance: '4.2 كم',
          category: 'صالونات نسائية',
          serviceType: 'Beauty',
          hours: '10:00 ص - 09:00 م',
          features: const [
            ServiceFeature(icon: Iconsax.crown, label: 'صالون إيطالي عالمي يدمج الفن بالتجميل'),
            ServiceFeature(icon: Iconsax.magicpen, label: 'علاجات وتقنيات متطورة للشعر والبشرة'),
          ],
        ),

        // 6. سبا ريتز كارلتون
        BaseServiceItem(
          id: 'b6',
          name: 'سبا ريتز كارلتون',
          subTitle: 'ملاذ فاخر للاستجمام والرفاهية',
          aboutText: 'منتجع صحي متكامل يجمع بين التقاليد العربية الأصيلة وأحدث علاجات السبا العالمية لتقديم تجربة استرخاء لا تضاهى.',
          imageUrl: Assets.images.beauty6.path,
          address: 'منطقة رأس أبو عبود، الدوحة',
          rating: 4.9,
          reviewsCount: 630,
          distance: '2.2 كم',
          category: 'سبا واسترخاء',
          serviceType: 'Beauty',
          hours: '09:00 ص - 11:00 م',
          features: const [
            ServiceFeature(icon: Iconsax.house, label: 'تصميم مستوحى من القرى العربية التقليدية'),
            ServiceFeature(icon: Iconsax.sun_1, label: 'مسبح سبا مخصص وغرف طمي وحمام تركي'),
          ],
        ),

        // 7. صالون شوغار
        BaseServiceItem(
          id: 'b7',
          name: 'صالون شوغار',
          subTitle: 'اللمسة العصرية لجمال أظافرك',
          aboutText: 'متخصصون في فن تزيين الأظافر والعناية باليدين والقدمين، باستخدام أحدث التقنيات وأفضل المنتجات في أجواء مفعمة بالحيوية.',
          imageUrl: Assets.images.beauty7.path,
          address: 'حديقة أسباير، الدوحة',
          rating: 4.6,
          reviewsCount: 315,
          distance: '5.5 كم',
          category: 'صالونات نسائية',
          serviceType: 'Beauty',
          hours: '10:00 ص - 09:00 م',
          features: const [
            ServiceFeature(icon: Iconsax.box_1, label: 'مختص بتركيب وتزيين الأظافر والرموش'),
            ServiceFeature(icon: Iconsax.routing, label: 'إمكانية الحجز المسبق الفوري'),
          ],
        ),
      ]);

      // ── 3. تحديد العناصر المميزة (Featured Items) ──
      // هنا نقوم بفلترة أول 3 عناصر ليكونوا في القسم المميز العلوي
      featuredItems.assignAll(allItems.take(3).toList());

    } catch (e) {
      errorMessage.value = 'حدث خطأ أثناء جلب البيانات: $e';
    } finally {
      isLoading.value = false;
    }
  }
}