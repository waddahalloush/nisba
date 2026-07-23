import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/generated/assets.gen.dart';
import '../../../../../data/models/service_model.dart';
import '../Base Service/base_service_controller.dart';

class MarketController extends BaseServiceController {
  
  @override
  Future<void> fetchData() async {
    isLoading.value = true;

    try {
      // محاكاة تأخير جلب البيانات من السيرفر (API)
      await Future.delayed(const Duration(milliseconds: 800));

      // ── 1. تصنيفات الأسواق والتجارة في قطر ──
      categories.assignAll(const [
        ServiceCategory(name: 'الكل', icon: Iconsax.category),
        ServiceCategory(name: 'أسواق شعبية', icon: Iconsax.shop),
        ServiceCategory(name: 'أسواق متخصصة', icon: Iconsax.crown),
        ServiceCategory(name: 'أسواق الجملة', icon: Iconsax.box_1),
        ServiceCategory(name: 'شوارع تجارية', icon: Iconsax.routing),
      ]);

      // ── 2. قائمة جميع الأسواق والمناطق التجارية (allItems) ──
      allItems.assignAll([
        // 1. سوق الذهب
        BaseServiceItem(
          id: 'market1',
          name: 'سوق الذهب بالدوحة',
          subTitle: 'أفخم أطقم الذهب واللؤلؤ الطبيعي في قلب الدوحة',
          aboutText: 'يعد سوق الذهب بالدوحة الوجهة الأولى لعشاق المجوهرات، حيث يجمع بين عراقة التصاميم التراثية القطرية وأحدث ابتكارات الذهب واللؤلؤ الطبيعي.',
          imageUrl: Assets.images.sooq1.path,
          address: 'بجانب سوق واقف، الدوحة',
          rating: 4.9,
          reviewsCount: 1450,
          distance: '1.1 كم',
          category: 'أسواق متخصصة',
          serviceType: 'Market',
          hours: '09:00 ص - 10:00 م',
          features: const [
            ServiceFeature(icon: Iconsax.crown, label: 'أحدث تصاميم الذهب والمجوهرات'),
            ServiceFeature(icon: Iconsax.verify, label: 'ورش فحص وصياغة معتمدة'),
            ServiceFeature(icon: Iconsax.status, label: 'بين التراث القطري والتصاميم الحديثة'),
          ],
          productsOrServices: const [
            ServiceSubItem(
              id: 'mks1',
              name: 'طقم ذهب عيار 21 تراثي',
              description: 'طقم متكامل بتصميم قطري أصيل مرصع بالأحجار الكريمة',
              price: 4500.0,
              imageUrl: 'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=500&q=80',
              extraInfo: 'شامل شهادة الفحص',
            ),
          ],
        ),

        // 2. سوق الوكرة القديم
        BaseServiceItem(
          id: 'market2',
          name: 'سوق الوكرة القديم',
          subTitle: 'سوق تراثي هادئ على شاطئ الوكرة',
          aboutText: 'يمتاز سوق الوكرة القديم بإطلالته الساحرة على البحر وممره البحري المميز، ويضم العديد من المتاجر التراثية والمقاهي والمطاعم البحرية.',
          imageUrl: Assets.images.sooq2.path,
          address: 'شاطئ الوكرة، الوكرة',
          rating: 4.8,
          reviewsCount: 1200,
          distance: '15.0 كم',
          category: 'أسواق شعبية',
          serviceType: 'Market',
          hours: '08:00 ص - 11:00 م',
          features: const [
            ServiceFeature(icon: Iconsax.shop, label: 'محلات تجارية ومطاعم بحرية'),
            ServiceFeature(icon: Iconsax.sun_1, label: 'إطلالة مباشرة على البحر'),
            ServiceFeature(icon: Iconsax.map, label: 'سوق تراثي هادئ على الساحل الجنوبي'),
          ],
        ),

        // 3. سوق السيلية المركزي
        BaseServiceItem(
          id: 'market3',
          name: 'سوق السيلية المركزي',
          subTitle: 'أكبر تجمع لبيع الخضار والفواكه بالجملة',
          aboutText: 'سوق السيلية المركزي مجهز بالكامل ومكيف لراحة المتسوقين، ويقدم ساحات بيع ومزاد يومي للمنتجات الطازجة بأسعار تنافسية مباشرة من المنتج.',
          imageUrl: Assets.images.sooq3.path,
          address: 'منطقة السيلية، الدوحة',
          rating: 4.7,
          reviewsCount: 980,
          distance: '18.5 كم',
          category: 'أسواق الجملة',
          serviceType: 'Market',
          hours: '05:00 ص - 10:00 م',
          features: const [
            ServiceFeature(icon: Iconsax.box_1, label: 'أكبر تجمع لبيع الخضار والفواكه بالجملة'),
            ServiceFeature(icon: Iconsax.discount_shape, label: 'أسعار تنافسية ومباشرة من المنتج'),
            ServiceFeature(icon: Iconsax.truck, label: 'ساحات بيع ومزاد يومي للمنتجات الطازجة'),
          ],
        ),

        // 4. سوق العلي
        BaseServiceItem(
          id: 'market4',
          name: 'سوق العلي الشهير',
          subTitle: 'أشهر أسواق خياطة وتفصيل الأثواب والمستلزمات الرجالية',
          aboutText: 'يُعد سوق العلي وجهة تقليدية عريقة في منطقة الغرافة، ويشتهر بمحلات تفصيل الأثواب والملابس التقليدية ومحلات الصرافة.',
          imageUrl: Assets.images.sooq4.path,
          address: 'منطقة الغرافة، الدوحة',
          rating: 4.6,
          reviewsCount: 810,
          distance: '7.2 كم',
          category: 'أسواق متخصصة',
          serviceType: 'Market',
          hours: '08:30 ص - 10:30 م',
          features: const [
            ServiceFeature(icon: Iconsax.user_tag, label: 'أشهر أسواق خياطة وتفصيل الأثواب والمستلزمات الرجالية'),
            ServiceFeature(icon: Iconsax.shop, label: 'محلات صرافة وتجارة عامة عريقة'),
          ],
        ),

        // 5. سوق الحراج
        BaseServiceItem(
          id: 'market5',
          name: 'سوق الحراج التراثي',
          subTitle: 'وجهة تجارة الأثاث المستعمل والجديد في النجمة',
          aboutText: 'سوق الحراج يقدم فرصاً ممتازة وصفقات تجارية واسعة للأثاث، الأجهزة المنزلية، والسجاد بأسعار شعبية ومميزة.',
          imageUrl: Assets.images.sooq5.path,
          address: 'منطقة النجمة، الدوحة',
          rating: 4.5,
          reviewsCount: 650,
          distance: '3.0 كم',
          category: 'أسواق شعبية',
          serviceType: 'Market',
          hours: '08:00 ص - 10:00 م',
          features: const [
            ServiceFeature(icon: Iconsax.house, label: 'تجارة الأثاث، الأجهزة المنزلية والسجاد'),
            ServiceFeature(icon: Iconsax.discount_shape, label: 'فرص ممتازة لصفقات تجارية وشعبية سريعة'),
          ],
        ),

        // 6. سوق أم صلال المركزي للأسماك
        BaseServiceItem(
          id: 'market6',
          name: 'سوق أم صلال المركزي للأسماك',
          subTitle: 'مزاد الأسماك الطازجة والمحلية يومياً',
          aboutText: 'يحتوي سوق أم صلال على مصنع ثلج ومحطات تنظيف وتقطيع حديثة، بالإضافة إلى مزاد الأسماك الطازجة المحلية والمستوردة.',
          imageUrl: Assets.images.sooq6.path,
          address: 'منطقة أم صلال، قطر',
          rating: 4.7,
          reviewsCount: 740,
          distance: '22.0 كم',
          category: 'أسواق الجملة',
          serviceType: 'Market',
          hours: '06:00 ص - 09:00 م',
          features: const [
            ServiceFeature(icon: Iconsax.activity, label: 'مزاد الأسماك الطازجة المحلية والمستوردة'),
            ServiceFeature(icon: Iconsax.verify, label: 'مصنع ثلج ومحطات تنظيف وتقطيع حديثة'),
          ],
        ),

        // 7. شارع آل شافي التجاري
        BaseServiceItem(
          id: 'market7',
          name: 'شارع آل شافي التجاري',
          subTitle: 'شارع تجاري حيوي يضم مئات المحلات في الريان',
          aboutText: 'يعتبر شارع آل شافي أحد أهم الشوارع التجارية في الريان، ويتميز بتنوع محلاته ومراكز صيانة الهواتف والمستلزمات الإلكترونية.',
          imageUrl: Assets.images.sooq7.path,
          address: 'منطقة الريان، الدوحة',
          rating: 4.6,
          reviewsCount: 920,
          distance: '9.0 كم',
          category: 'شوارع تجارية',
          serviceType: 'Market',
          hours: 'مفتوح دائماً',
          features: const [
            ServiceFeature(icon: Iconsax.routing, label: 'شارع تجاري حيوي يضم مئات المحلات المتنوعة'),
            ServiceFeature(icon: Iconsax.mobile, label: 'مراكز صيانة هواتف ومستلزمات إلكترونية متعددة'),
          ],
        ),
      ]);

      // ── 3. تحديد الأسواق المميزة (Featured Items) ──
      featuredItems.assignAll(allItems.take(3).toList());

    } catch (e) {
      errorMessage.value = 'حدث خطأ أثناء جلب البيانات: $e';
    } finally {
      isLoading.value = false;
    }
  }
}