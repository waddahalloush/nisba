import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/generated/assets.gen.dart';

import '../../../../../data/models/service_model.dart';
import '../Base Service/base_service_controller.dart'; // تأكد من استيراد Assets بشكل صحيح

// تأكد من استيراد مسارات الموديلات والكونترولر الأساسي بشكل صحيح
// import '../../../../../data/models/base_service_model.dart';
// import '../Base Service/base_service_controller.dart';

class EntertainmentController extends BaseServiceController {
  
  @override
  Future<void> fetchData() async {
    isLoading.value = true;

    try {
      // محاكاة تأخير جلب البيانات من السيرفر (API)
      await Future.delayed(const Duration(milliseconds: 800));

      // ── 1. تعبئة تصنيفات الترفيه المحددة لدولة قطر ──[cite: 13]
      categories.assignAll(const [
        ServiceCategory(name: 'الكل', icon: Iconsax.category),
        ServiceCategory(name: 'ملاهي مغلقة', icon: Iconsax.game),
        ServiceCategory(name: 'ألعاب مائية', icon: Iconsax.activity),
        ServiceCategory(name: 'ألعاب حركية', icon: Iconsax.cloud_sunny),
        ServiceCategory(name: 'عائلي', icon: Iconsax.people),
      ]);

      // ── 2. تعبئة جميع المراكز الترفيهية (allItems) ──[cite: 13]
      allItems.assignAll([
        // 1. دوحة كويست
        BaseServiceItem(
          id: 'e1',
          name: 'مدينة ألعاب دوحة كويست',
          subTitle: 'أول مدينة ترفيهية مغلقة بالكامل في قطر',
          aboutText: 'واحة الدوحة كويست هي وجهة ترفيهية مغلقة تمتد على مساحة ضخمة، تضم أكثر من 30 لعبة ومرفقاً ترفيهياً، بما في ذلك أسرع أفعوانية مغلقة وأطول برج إسقاط داخلي في العالم.',
          imageUrl: Assets.images.entertain1.path,
          address: 'واحة الدوحة، مشيرب، الدوحة',
          rating: 4.9,
          reviewsCount: 1250,
          distance: '1.2 كم',
          category: 'ملاهي مغلقة',
          serviceType: 'Entertain',
          hours: '02:00 م - 10:00 م',
          features: const [
            ServiceFeature(icon: Iconsax.game, label: 'أسرع أفعوانية مغلقة بالعالم'),
            ServiceFeature(icon: Iconsax.radar, label: 'أحدث تجارب VR والواقع المعزز'),
          ],
          productsOrServices: const [
            ServiceSubItem(
              id: 't1',
              name: 'تذكرة الدخول الشاملة',
              description: 'دخول غير محدود لجميع الألعاب طوال اليوم',
              price: 225.0,
              imageUrl: 'https://images.unsplash.com/photo-1593508512255-86ab42a8e620?w=500&q=80',
              extraInfo: 'للبالغين فوق 12 سنة',
            ),
            ServiceSubItem(
              id: 't2',
              name: 'تذكرة الصغار',
              description: 'دخول مخصص للأطفال لألعاب محددة وآمنة',
              price: 150.0,
              imageUrl: 'https://images.unsplash.com/photo-1566579090262-51cde5ebe92e?w=500&q=80',
              extraInfo: 'للأطفال تحت 12 سنة',
            ),
          ],
        ),

        // 2. لوسيل ونتر وندرلاند
        BaseServiceItem(
          id: 'e2',
          name: 'لوسيل ونتر وندرلاند',
          subTitle: 'وجهة ترفيهية شتوية استثنائية على جزيرة المها',
          aboutText: 'تقدم لوسيل ونتر وندرلاند تجربة ترفيهية شتوية مذهلة مع أكثر من 50 لعبة مشوقة، وحلبة تزلج على الجليد، وعروض حية تناسب جميع أفراد العائلة في أجواء ساحرة.',
          imageUrl: Assets.images.entertain2.path,
          address: 'جزيرة المها، لوسيل',
          rating: 4.8,
          reviewsCount: 3420,
          distance: '8.5 كم',
          category: 'عائلي',
          serviceType: 'Entertain',
          hours: '04:00 م - 12:00 ص',
          features: const [
            ServiceFeature(icon: Iconsax.mask, label: 'أجواء شتوية ساحرة وعروض مسرحية'),
            ServiceFeature(icon: Iconsax.shop, label: 'أكشاك هدايا تذكارية ومأكولات عالمية'),
          ],
          productsOrServices: const [
            ServiceSubItem(
              id: 't3',
              name: 'سوار الألعاب اللامحدود',
              description: 'يتيح لك ركوب جميع الألعاب والمرافق بدون حد أقصى',
              price: 280.0,
              imageUrl: 'https://images.unsplash.com/photo-1513151233558-d860c5398176?w=500&q=80',
              extraInfo: 'لا يشمل ألعاب المهارات',
            ),
          ],
        ),

        // 3. حديقة مريال المائية
        BaseServiceItem(
          id: 'e3',
          name: 'حديقة مريال المائية',
          subTitle: 'أضخم حديقة مائية مع أعلى برج منزلقات في العالم',
          aboutText: 'حديقة مريال المائية في جزيرة قطيفان الشمالية تعتبر الوجهة الأولى لعشاق الألعاب المائية، وتضم برج "الأيقونة" الذي يكسر الأرقام القياسية بتصميمه المستوحى من التراث القطري.',
          imageUrl: Assets.images.entertain3.path,
          address: 'جزيرة قطيفان الشمالية، لوسيل',
          rating: 4.7,
          reviewsCount: 890,
          distance: '11.0 كم',
          category: 'ألعاب مائية',
          serviceType: 'Entertain',
          hours: '10:00 ص - 06:00 م',
          features: const [
            ServiceFeature(icon: Iconsax.activity, label: 'أعلى برج أيقوني للمنحدرات المائية'),
            ServiceFeature(icon: Iconsax.sun_1, label: 'منطقة ألعاب مائية للأطفال وشاطئ خاص'),
          ],
          productsOrServices: const [
            ServiceSubItem(
              id: 't4',
              name: 'تذكرة الدخول اليومية',
              description: 'تذكرة دخول تتيح الوصول لجميع المسابح والمنزلقات',
              price: 260.0,
              imageUrl: 'https://images.unsplash.com/photo-1582262529094-142279185a42?w=500&q=80',
              extraInfo: 'دخول يوم كامل',
            ),
          ],
        ),

        // 4. أنجري بيردز ورلد
        BaseServiceItem(
          id: 'e4',
          name: 'أنجري بيردز ورلد',
          subTitle: 'مغامرات الطيور الغاضبة لجميع أفراد العائلة',
          aboutText: 'حديقة ترفيهية فريدة من نوعها تمزج بين المناطق الداخلية والخارجية، مستوحاة من سلسلة الألعاب الشهيرة "الطيور الغاضبة"، لتقدم مغامرة لا تُنسى للأطفال والكبار.',
          imageUrl: Assets.images.entertain4.path,
          address: 'دوحة فستيفال سيتي، الدوحة',
          rating: 4.6,
          reviewsCount: 2100,
          distance: '12.4 كم',
          category: 'عائلي',
          serviceType: 'Entertain',
          hours: '10:00 ص - 10:00 م',
          features: const [
            ServiceFeature(icon: Iconsax.game, label: 'ألعاب داخلية وخارجية ممتعة'),
            ServiceFeature(icon: Iconsax.music, label: 'مسرح خاص لعروض الطيور الغاضبة'),
          ],
        ),

        // 5. باونس الدوحة
        BaseServiceItem(
          id: 'e5',
          name: 'باونس الدوحة',
          subTitle: 'عالم الترامبولين والقفز الحر',
          aboutText: 'باونس هو صالة ضخمة مليئة بالترامبولين المترابطة، توفر أنشطة رياضية وترفيهية مثل القفز الحر، وكرة المناورة، ومسارات النينجا للتحدي.',
          imageUrl: Assets.images.entertain5.path,
          address: 'طوار مول، الدوحة',
          rating: 4.7,
          reviewsCount: 950,
          distance: '5.2 كم',
          category: 'ألعاب حركية',
          serviceType: 'Entertain',
          hours: '10:00 ص - 10:00 م',
          features: const [
            ServiceFeature(icon: Iconsax.activity, label: 'أكبر صالة ترامبولين مغلقة للقفز'),
            ServiceFeature(icon: Iconsax.judge, label: 'ألعاب تحدي وتسلق جدران (مسار النينجا)'),
          ],
          productsOrServices: const [
            ServiceSubItem(
              id: 't5',
              name: 'تذكرة القفز المفتوح',
              description: 'جلسة قفز حرة على جميع المنصات المتاحة',
              price: 100.0,
              imageUrl: 'https://images.unsplash.com/photo-1550026593-f369f98df0af?w=500&q=80',
              extraInfo: 'لمدة ساعة واحدة',
            ),
          ],
        ),

        // 6. سنو ديونز (كثبان الثلج)
        BaseServiceItem(
          id: 'e6',
          name: 'كثبان الثلج',
          subTitle: 'تجربة ثلجية ساحرة في قلب الدوحة',
          aboutText: 'أول حديقة ثلجية داخلية في قطر، تقدم بيئة شتوية مذهلة بدرجة حرارة تحت الصفر مع منزلقات جليدية وألعاب تزلج مثيرة تناسب جميع الأعمار.',
          imageUrl: Assets.images.entertain6.path,
          address: 'دوحة فستيفال سيتي، الدوحة',
          rating: 4.5,
          reviewsCount: 780,
          distance: '12.4 كم',
          category: 'ملاهي مغلقة',
          serviceType: 'Entertain',
          hours: '10:00 ص - 10:00 م',
          features: const [
            ServiceFeature(icon: Iconsax.cloud_notif, label: 'درجة حرارة تحت الصفر 4-'),
            ServiceFeature(icon: Iconsax.activity, label: 'ألعاب تزلج ثلجية آمنة وممتعة'),
          ],
        ),

        // 7. كيدزانيا الدوحة
        BaseServiceItem(
          id: 'e7',
          name: 'كيدزانيا الدوحة',
          subTitle: 'مدينة تفاعلية لتعليم وترفيه الأطفال',
          aboutText: 'كيدزانيا هي مدينة مصغرة صُممت خصيصاً للأطفال، تتيح لهم فرصة تجربة لعب الأدوار في أكثر من 60 مهنة واقعية مثل الطب، والهندسة، والطيران في بيئة تفاعلية آمنة.',
          imageUrl: Assets.images.entertain7.path,
          address: 'حديقة أسباير، الوعب، الدوحة',
          rating: 4.8,
          reviewsCount: 1650,
          distance: '6.0 كم',
          category: 'عائلي',
          serviceType: 'Entertain',
          hours: '01:00 م - 09:00 م',
          features: const [
            ServiceFeature(icon: Iconsax.teacher, label: 'بيئة تعليمية وترفيهية للأطفال'),
            ServiceFeature(icon: Iconsax.briefcase, label: 'أكثر من 60 تجربة مهنية حقيقية'),
          ],
          productsOrServices: const [
            ServiceSubItem(
              id: 't6',
              name: 'تذكرة دخول الأطفال',
              description: 'تسمح للطفل بالاستمتاع بجميع الأنشطة المهنية',
              price: 160.0,
              imageUrl: 'https://images.unsplash.com/photo-1511895426328-dc8714191300?w=500&q=80',
              extraInfo: 'الأعمار من 4 إلى 14 سنة',
            ),
          ],
        ),
      ]);

      // ── 3. تحديد العناصر المميزة (Featured Items) ──
      // أخذ أول 3 عناصر ووضعها في قسم العناصر المميزة العلوية
      featuredItems.assignAll(allItems.take(3).toList());

    } catch (e) {
      errorMessage.value = 'حدث خطأ أثناء جلب البيانات: $e';
    } finally {
      isLoading.value = false;
    }
  }
}