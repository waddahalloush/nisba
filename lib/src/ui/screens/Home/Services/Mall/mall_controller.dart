import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/generated/assets.gen.dart';
import 'package:nisba_app/src/data/models/service_model.dart';
import 'package:nisba_app/src/ui/screens/Home/Services/Base Service/base_service_controller.dart';

class MallController extends BaseServiceController {
  
  @override
  Future<void> fetchData() async {
    isLoading.value = true;

    try {
      // محاكاة تأخير جلب البيانات من السيرفر (API)
      await Future.delayed(const Duration(milliseconds: 800));

      // ── 1. تعبئة تصنيفات المولات ──
      categories.assignAll(const [
        ServiceCategory(name: 'الكل', icon: Iconsax.category),
        ServiceCategory(name: 'ترفيه', icon: Iconsax.music),
        ServiceCategory(name: 'مطاعم', icon: Iconsax.coffee),
        ServiceCategory(name: 'أزياء', icon: Iconsax.shop),
        ServiceCategory(name: 'إلكترونيات', icon: Iconsax.mobile),
      ]);

      // ── 2. تعبئة قائمة جميع المولات (allItems) ──
      allItems.assignAll([
        // 1. قطر مول
        BaseServiceItem(
          id: 'm1',
          name: 'قطر مول',
          subTitle: 'وجهة التسوق والترفيه العملاقة في الريان',
          aboutText: 'يعد قطر مول وجهاً عالمياً للتسوق والترفيه، يضم مئات المتاجر العالمية، الخيارات الواسعة من المطاعم، وعروضاً ترفيهية حية فريدة.',
          imageUrl: Assets.images.mall11.path,
          address: 'طريق الدوحة السريع، الريان',
          rating: 4.8,
          reviewsCount: 3200,
          distance: '2.5 كم',
          category: 'ترفيه',
          serviceType: 'Mall',
          hours: '10:00 ص - 10:00 م',
          features: const [
            ServiceFeature(icon: Iconsax.shop, label: '350 متجر عالمي ومحلي'),
            ServiceFeature(icon: Iconsax.coffee, label: '50 مطعم ومقهى متنوع'),
            ServiceFeature(icon: Iconsax.video, label: 'سينما ضخمة وعروض ترفيهية'),
          ],
          productsOrServices: const [
            ServiceSubItem(
              id: 'ms1',
              name: 'تذكرة سينما VIP',
              description: 'تجربة مشاهدة سينمائية فاخرة مع خدمات ضيافة خاصة',
              price: 75.0,
              imageUrl: 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=500&q=80',
              extraInfo: 'شامل المشروبات الخفيفة',
            ),
          ],
        ),

        // 2. لاند مارك مول
        BaseServiceItem(
          id: 'm2',
          name: 'لاند مارك مول',
          subTitle: 'وجهة التسوق العائلية الكلاسيكية',
          aboutText: 'يتميز لاند مارك مول بطابعه المعماري المستوحى من القلاع القطرية القديمة، ويضم تشكيلة واسعة من الماركات العالمية والأزياء وأماكن ألعاب الأطفال.',
          imageUrl: Assets.images.mall22.path,
          address: 'طريق سلوى، أبو هامور',
          rating: 4.6,
          reviewsCount: 2150,
          distance: '5.0 كم',
          category: 'أزياء',
          serviceType: 'Mall',
          hours: '9:00 ص - 11:00 م',
          features: const [
            ServiceFeature(icon: Iconsax.shop, label: '280 متجر أزياء وعلامات تجارية'),
            ServiceFeature(icon: Iconsax.coffee, label: '35 مطعم ومقاهي متنوعة'),
          ],
          productsOrServices: const [
            ServiceSubItem(
              id: 'ms2',
              name: 'بطاقة هدايا المول المتكاملة',
              description: 'بطاقة تسوق صالحة لجميع متاجر ومطاعم المول',
              price: 200.0,
              imageUrl: 'https://images.unsplash.com/photo-1513201099705-a9746e1e201f?w=500&q=80',
              extraInfo: 'قابلة للشحن',
            ),
          ],
        ),

        // 3. جلف مول
        BaseServiceItem(
          id: 'm3',
          name: 'جلف مول',
          subTitle: 'مركز تسوق عصري في قلب الدوحة',
          aboutText: 'يقع جلف مول في منطقة حيوية ويوفر تجربة تسوق راقية تضم أشهر العلامات التجارية العالمية، محلات التجميل، والخدمات الترفيهية.',
          imageUrl: Assets.images.mall44.path,
          address: 'منطقة الخليج الغربي، الدوحة',
          rating: 4.5,
          reviewsCount: 1800,
          distance: '3.2 كم',
          category: 'ترفيه',
          serviceType: 'Mall',
          hours: '10:00 ص - 10:00 م',
          features: const [
            ServiceFeature(icon: Iconsax.shop, label: '200 متجر تسوق وعلامات بارزة'),
            ServiceFeature(icon: Iconsax.coffee, label: '30 مطعم ومقهى'),
          ],
        ),

        // 4. فيلاجيو مول
        BaseServiceItem(
          id: 'm4',
          name: 'فيلاجيو مول',
          subTitle: 'تجربة تسوق على الطراز البندقي الساحر',
          aboutText: 'مجمع تجاري فريد من نوعه بتصميم مستوحى من مدينة البندقية الإيطالية مع قناة مائية وجولات بالقارب، ويضم أرقى الماركات العالمية.',
          imageUrl: Assets.images.mall33.path,
          address: 'منطقة أسباير زون، الدوحة',
          rating: 4.7,
          reviewsCount: 2900,
          distance: '4.1 كم',
          category: 'ترفيه',
          serviceType: 'Mall',
          hours: '9:00 ص - 11:00 م',
          features: const [
            ServiceFeature(icon: Iconsax.shop, label: '220 متجر عالمي فاخر'),
            ServiceFeature(icon: Iconsax.coffee, label: '45 مطعم متنوع'),
            ServiceFeature(icon: Iconsax.ship, label: 'قناة مائية وجولات قوارب داخلية'),
          ],
        ),

        // 5. سيتي سنتر الدوحة
        BaseServiceItem(
          id: 'm5',
          name: 'سيتي سنتر الدوحة',
          subTitle: 'أحد أقدم وأشهر مراكز التسوق في قطر',
          aboutText: 'يقع في قلب الدوحة التجاري، ويحتوي على خيارات تسوق هائلة، ومجمع سينمات، ومنطقة ترفيه عائلية واسعة.',
          imageUrl: Assets.images.service6.path,
          address: 'الخليج الغربي، الدوحة',
          rating: 4.4,
          reviewsCount: 1650,
          distance: '6.3 كم',
          category: 'مطاعم',
          serviceType: 'Mall',
          hours: '10:00 ص - 10:00 م',
          features: const [
            ServiceFeature(icon: Iconsax.shop, label: '190 متجر تسوق'),
            ServiceFeature(icon: Iconsax.coffee, label: '28 مطعم وركن وجبات سريعة'),
          ],
        ),

        // 6. إزدان مول
        BaseServiceItem(
          id: 'm6',
          name: 'إزدان مول',
          subTitle: 'وجهة التسوق المريحة والعائلية في الوكرة',
          aboutText: 'يوفر إزدان مول أجواء تسوق هادئة ومريحة للعائلات مع مجموعة مختارة من المتاجر، الألعاب، ومحلات الأجهزة الإلكترونية.',
          imageUrl: Assets.images.service7.path,
          address: 'الوكرة، الدوحة',
          rating: 4.3,
          reviewsCount: 1100,
          distance: '8.0 كم',
          category: 'إلكترونيات',
          serviceType: 'Mall',
          hours: '10:00 ص - 10:00 م',
          features: const [
            ServiceFeature(icon: Iconsax.shop, label: '150 متجر منوعة'),
            ServiceFeature(icon: Iconsax.mobile, label: 'متاجر إلكترونيات واتصالات كبرى'),
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