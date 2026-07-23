import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../../generated/assets.gen.dart';
import '../../../../../data/models/service_model.dart';
import '../Base Service/base_service_controller.dart';

class GiftController extends BaseServiceController {
  
  @override
  Future<void> fetchData() async {
    isLoading.value = true;

    try {
      // محاكاة تأخير جلب البيانات من السيرفر (API)
      await Future.delayed(const Duration(milliseconds: 800));

      // ── 1. تعبئة تصنيفات متاجر الهدايا والألعاب في قطر ──
      categories.assignAll(const [
        ServiceCategory(name: 'الكل', icon: Iconsax.category),
        ServiceCategory(name: 'هدايا وتذكارات', icon: Iconsax.gift),
        ServiceCategory(name: 'ألعاب أطفال', icon: Iconsax.game),
        ServiceCategory(name: 'إكسسوارات', icon: Iconsax.shop),
        ServiceCategory(name: 'تغليف وتنسيق', icon: Iconsax.box_1),
      ]);

      // ── 2. تعبئة قائمة جميع المتاجر (allItems) ──
      allItems.assignAll([
        // 1. هامليز
        BaseServiceItem(
          id: 'g1',
          name: 'متجر هامليز الشهير',
          subTitle: 'أعرق وأكبر متجر ألعاب بريطاني في العالم',
          aboutText: 'يعتبر هامليز وجهة ترفيهية وتسوق مذهلة للأطفال والعائلات، حيث يقدم تجارب تفاعلية حية، وألعاباً تعليمية وترفيهية فريدة من نوعها مع ركن تغليف هدايا احترافي.',
          imageUrl: Assets.images.gifts1.path,
          address: 'قطر مول، الريان، الدوحة',
          rating: 4.9,
          reviewsCount: 1420,
          distance: '2.5 كم',
          category: 'ألعاب أطفال',
          serviceType: 'Gift',
          hours: '10:00 ص - 10:00 م',
          features: const [
            ServiceFeature(icon: Iconsax.game, label: 'ألعاب وعروض تفاعلية حيّة للطفل'),
            ServiceFeature(icon: Iconsax.box_1, label: 'ركن تغليف هدايا احترافي'),
          ],
          productsOrServices: const [
            ServiceSubItem(
              id: 'gs1',
              name: 'دمية دب هامليز الكلاسيكية',
              description: 'دمية فاخرة وناعمة بتصميم بريطاني أصلي',
              price: 180.0,
              imageUrl: 'https://images.unsplash.com/photo-1558060370-d97ed5979bb0?w=500&q=80',
              extraInfo: 'متوفر بأحجام مختلفة',
            ),
          ],
        ),

        // 2. محلات الرونق
        BaseServiceItem(
          id: 'g2',
          name: 'محلات الرونق',
          subTitle: 'الوجهة الشاملة للقرطاسية وتوزيعات الهدايا',
          aboutText: 'تشكيلة ضخمة وغير مسبوقة من مستلزمات الحفلات، وأكياس وهدايا المناسبات، وأدوات القرطاسية بأسعار مناسبة وخيارات واسعة تلبي جميع الاحتياجات.',
          imageUrl: Assets.images.gifts2.path,
          address: 'فرع بن محمود، الدوحة',
          rating: 4.7,
          reviewsCount: 2300,
          distance: '1.8 كم',
          category: 'هدايا وتذكارات',
          serviceType: 'Gift',
          hours: '08:00 ص - 11:00 م',
          features: const [
            ServiceFeature(icon: Iconsax.discount_shape, label: 'مستلزمات الحفلات وأكياس الهدايا'),
            ServiceFeature(icon: Iconsax.paintbucket, label: 'ركن أشغال يدوية وقرطاسية متميزة'),
          ],
          productsOrServices: const [
            ServiceSubItem(
              id: 'gs2',
              name: 'بوكس هدايا فارغ ومنسق',
              description: 'صندوق هدايا أنيق مزود بشرائط وأكياس مطابقة',
              price: 45.0,
              imageUrl: 'https://images.unsplash.com/photo-1513201099705-a9746e1e201f?w=500&q=80',
              extraInfo: 'متعدد الألوان والأحجام',
            ),
          ],
        ),

        // 3. بيل أند بو
        BaseServiceItem(
          id: 'g3',
          name: 'متجر بيل أند بو',
          subTitle: 'إكسسوارات ومجوهرات راقية للمناسبات',
          aboutText: 'متجر متخصص في توفير أحدث صيحات الإكسسوارات والهدايا الفريدة المصممة خصيصاً لتناسب أصحاب الذوق الرفيع والمناسبات الخاصة.',
          imageUrl: Assets.images.gifts3.path,
          address: 'بورتو أرابيا، اللؤلؤة، قطر',
          rating: 4.8,
          reviewsCount: 510,
          distance: '9.2 كم',
          category: 'إكسسوارات',
          serviceType: 'Gift',
          hours: '10:00 ص - 11:00 م',
          features: const [
            ServiceFeature(icon: Iconsax.crown, label: 'إكسسوارات وهدايا للمناسبات الخاصة'),
            ServiceFeature(icon: Iconsax.star_1, label: 'قطع حصرية وتصميم مخصص'),
          ],
          productsOrServices: const [
            ServiceSubItem(
              id: 'gs3',
              name: 'طقم إكسسوارات نسائي فاخر',
              description: 'مجموعة متناسقة من السلاسل والأقراط المطلية بالذهب',
              price: 350.0,
              imageUrl: 'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?w=500&q=80',
              extraInfo: 'ضمان سنة ضد التغير',
            ),
          ],
        ),

        // 4. فيرجن ميجاستور
        BaseServiceItem(
          id: 'g4',
          name: 'فيرجن ميجاستور',
          subTitle: 'الوجهة الترفيهية العصرية للإلكترونيات والألعاب',
          aboutText: 'يقدم فيرجن ميجاستور مجموعة واسعة من أحدث الأجهزة الذكية، وسماعات الرأس، وألعاب الفيديو، والكتب، والمجسمات التذكارية الأصلية لشخصياتك المفضلة.',
          imageUrl: Assets.images.gifts4.path,
          address: 'فيلاجيو مول، الدوحة، قطر',
          rating: 4.8,
          reviewsCount: 1890,
          distance: '4.5 كم',
          category: 'إكسسوارات',
          serviceType: 'Gift',
          hours: '10:00 ص - 12:00 ص',
          features: const [
            ServiceFeature(icon: Iconsax.headphone, label: 'إلكترونيات وإكسسوارات ذكية حديثة'),
            ServiceFeature(icon: Iconsax.game, label: 'أحدث ألعاب الفيديو والمجسمات'),
          ],
          productsOrServices: const [
            ServiceSubItem(
              id: 'gs4',
              name: 'سماعات رأس لاسلكية',
              description: 'سماعات عالية الأداء بخاصية إلغاء الضوضاء',
              price: 599.0,
              imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500&q=80',
              extraInfo: 'ماركات عالمية أصلية',
            ),
          ],
        ),

        // 5. قصر الهدايا
        BaseServiceItem(
          id: 'g5',
          name: 'قصر الهدايا',
          subTitle: 'أرقى خدمات تنسيق وتغليف الهدايا والورود',
          aboutText: 'متخصصون في ابتكار أفكار هدايا متميزة وتغليفها بأرقى الخامات، مع خدمات تنسيق بوكيهات الورد الطبيعي وإيصالها لمن تحب.',
          imageUrl: Assets.images.gifts5.path,
          address: 'شارع المرخية، الدوحة',
          rating: 4.6,
          reviewsCount: 380,
          distance: '6.0 كم',
          category: 'تغليف وتنسيق',
          serviceType: 'Gift',
          hours: '09:00 ص - 10:00 م',
          features: const [
            ServiceFeature(icon: Iconsax.box_1, label: 'أرقى أنواع علب وأشرطة التغليف'),
            ServiceFeature(icon: Iconsax.cloud_notif, label: 'تنسيق بوكيهات ورد طبيعي ساحر'),
          ],
        ),

        // 6. تويز آر أص
        BaseServiceItem(
          id: 'g6',
          name: 'تويز آر أص',
          subTitle: 'العالم السحري لألعاب الأطفال والدراجات',
          aboutText: 'المتجر العالمي المفضل للأطفال، يضم تشكيلة واسعة من الألعاب التعليمية والذهنية، والدراجات الهوائية، والألعاب الحركية المناسبة لجميع الأعمار.',
          imageUrl: Assets.images.gifts6.path,
          address: 'طريق سلوى، الدوحة',
          rating: 4.7,
          reviewsCount: 1120,
          distance: '5.0 كم',
          category: 'ألعاب أطفال',
          serviceType: 'Gift',
          hours: '09:00 ص - 10:30 م',
          features: const [
            ServiceFeature(icon: Iconsax.cup, label: 'تشكيلة واسعة من الألعاب التعليمية والذهنية'),
            ServiceFeature(icon: Iconsax.truck, label: 'دراجات هوائية وسكوترات للأطفال'),
          ],
        ),

        // 7. محلات تذكار التراثية
        BaseServiceItem(
          id: 'g7',
          name: 'محلات تذكار التراثية',
          subTitle: 'أصالة الهدايا التراثية القطرية في سوق واقف',
          aboutText: 'وجهتك المثالية للحصول على التحف والهدايا التذكارية المصنوعة يدوياً، والصناديق الخشبية المزخرفة، والعطور الشرقية والبخور الأصيل في قلب سوق واقف.',
          imageUrl: Assets.images.gifts7.path,
          address: 'السوق الشعبي، سوق واقف، الدوحة',
          rating: 4.9,
          reviewsCount: 940,
          distance: '1.0 كم',
          category: 'هدايا وتذكارات',
          serviceType: 'Gift',
          hours: '08:00 ص - 10:00 م',
          features: const [
            ServiceFeature(icon: Iconsax.gift, label: 'تحف وتذكارات قطرية مصنعة يدوياً'),
            ServiceFeature(icon: Iconsax.glass, label: 'عطور وبخور وصناديق خشبية تراثية'),
          ],
        ),
      ]);

      // ── 3. تحديد العناصر المميزة (Featured Items) ──
      // تعيين أول 3 عناصر لتكون مميزة في القسم العلوي الأفقي
      featuredItems.assignAll(allItems.take(3).toList());

    } catch (e) {
      errorMessage.value = 'حدث خطأ أثناء جلب البيانات: $e';
    } finally {
      isLoading.value = false;
    }
  }
}