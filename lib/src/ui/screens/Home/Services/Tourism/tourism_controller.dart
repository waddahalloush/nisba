import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/generated/assets.gen.dart';

import '../../../../../data/models/service_model.dart';
import '../Base Service/base_service_controller.dart';

class TourismController extends BaseServiceController {
  
  @override
  Future<void> fetchData() async {
    isLoading.value = true;

    try {
      // محاكاة تأخير جلب البيانات من السيرفر (API)
      await Future.delayed(const Duration(milliseconds: 800));

      // ── 1. تعبئة تصنيفات الوجهات السياحية في قطر ──
      categories.assignAll(const [
        ServiceCategory(name: 'الكل', icon: Iconsax.category),
        ServiceCategory(name: 'معالم أثرية', icon: Icons.fort),
        ServiceCategory(name: 'متاحف وفنون', icon: Iconsax.gallery),
        ServiceCategory(name: 'شواطئ وجزر', icon: Iconsax.sun_1),
        ServiceCategory(name: 'حدائق ومنتزهات', icon: Iconsax.tree),
      ]);

      // ── 2. تعبئة قائمة جميع الوجهات السياحية (allItems) ──
      allItems.assignAll([
        // 1. سوق واقف
        BaseServiceItem(
          id: 't1',
          name: 'سوق واقف الأثري',
          subTitle: 'سوق تراثي عريق يعود لمئات السنين في قلب الدوحة',
          aboutText: 'يعتبر سوق واقف الوجهة السياحية الأولى في قطر، يجمع بين عبق التراث الشعبي، العروض الحية للحرف اليدوية، وأزقة التسوق المليئة بالتوابل والعطور والمقاهي التقليدية.',
          imageUrl: Assets.images.tourism1.path,
          address: 'وسط البلد، الدوحة',
          rating: 4.9,
          reviewsCount: 3800,
          distance: '0.8 كم',
          category: 'معالم أثرية',
          serviceType: 'Tourism',
          hours: 'مفتوح 24 ساعة (المحلات تختلف)',
          features: const [
            ServiceFeature(icon: Iconsax.map, label: 'سوق تراثي يعود لمئات السنين'),
            ServiceFeature(icon: Iconsax.flash_1, label: 'عرض حي للحرف اليدوية'),
            ServiceFeature(icon: Iconsax.status, label: 'تراث شعبي وتسوق'),
          ],
          productsOrServices: const [
            ServiceSubItem(
              id: 'ts1',
              name: 'جولة سياحية مرشدة في السوق',
              description: 'استكشف أسرار وأروقة سوق واقف التاريخية مع مرشد سياحي مختص',
              price: 120.0,
              imageUrl: 'https://images.unsplash.com/photo-1578683010236-d716f9a3f461?w=500&q=80',
              extraInfo: 'تتضمن ضيافة القهوة العربية',
            ),
          ],
        ),

        // 2. كتارا
        BaseServiceItem(
          id: 't2',
          name: 'الحي الثقافي (كتارا)',
          subTitle: 'ملتقى الثقافات والفنون العالمي في الدوحة',
          aboutText: 'منطقة ثقافية ساحرة تضم مسارح عالمية، معارض فنية، مسجداً بتصميم هندسي مذهل، وشاطئاً رملياً يوفر أنشطة مائية متنوعة.',
          imageUrl: Assets.images.tourism2.path,
          address: 'الخليج الغربي، الدوحة',
          rating: 4.8,
          reviewsCount: 2900,
          distance: '5.5 كم',
          category: 'معالم أثرية',
          serviceType: 'Tourism',
          hours: 'مفتوح دائماً',
          features: const [
            ServiceFeature(icon: Iconsax.teacher, label: 'ملتقى الثقافات والفنون'),
            ServiceFeature(icon: Iconsax.favorite_chart, label: 'المسرح الروماني المفتوح'),
            ServiceFeature(icon: Iconsax.sun_1, label: 'شاطئ وأنشطة مائية'),
          ],
          productsOrServices: const [
            ServiceSubItem(
              id: 'ts2',
              name: 'تذكرة دخول المعارض الفنية',
              description: 'صلاحية لحضور أحدث المعارض والفعاليات الثقافية المقامة في الحي',
              price: 50.0,
              imageUrl: 'https://images.unsplash.com/photo-1561214115-f2f134cc4912?w=500&q=80',
              extraInfo: 'دخول مخصص',
            ),
          ],
        ),

        // 3. متحف الفن الإسلامي
        BaseServiceItem(
          id: 't3',
          name: 'متحف الفن الإسلامي',
          subTitle: 'تحفة معماريّة تحتضن كنوز الفن الإسلامي على الكورنيش',
          aboutText: 'تحفة معمارية صممها المهندس العالمي آي إم بي، يضم مجموعات فريدة من القطع الأثرية والمخطوطات الإسلامية الممتدة عبر 14 قرناً.',
          imageUrl: Assets.images.tourism3.path,
          address: 'كورنيش الدوحة، الدوحة',
          rating: 4.9,
          reviewsCount: 3100,
          distance: '1.5 كم',
          category: 'متاحف وفنون',
          serviceType: 'Tourism',
          hours: '09:00 ص - 07:00 م',
          features: const [
            ServiceFeature(icon: Iconsax.crown, label: 'أيقونة معمارية من تصميم آي إم بي'),
            ServiceFeature(icon: Iconsax.card_receive, label: 'دخول مجاني للمقيمين'),
            ServiceFeature(icon: Iconsax.radar, label: 'إطلالة بانورامية على الكورنيش'),
          ],
        ),

        // 4. متحف قطر الوطني
        BaseServiceItem(
          id: 't4',
          name: 'متحف قطر الوطني (وردة الصحراء)',
          subTitle: 'قصة قطر ترويها العمارة والتاريخ التفاعلي',
          aboutText: 'مبنى استثنائي مستوحى من شكل بلورات وردة الصحراء، يعرض تاريخ دولة قطر وتطورها بطريقة بصرية وتفاعلية مذهلة.',
          imageUrl: Assets.images.tourism4.path,
          address: 'شارع رأس أبو عبود، الدوحة',
          rating: 4.9,
          reviewsCount: 2450,
          distance: '2.0 كم',
          category: 'متاحف وفنون',
          serviceType: 'Tourism',
          hours: '09:00 ص - 07:00 م',
          features: const [
            ServiceFeature(icon: Iconsax.building_3, label: 'تصميم مستوحى من وردة الصحراء'),
            ServiceFeature(icon: Iconsax.video_play, label: 'صالات عرض تفاعلية مميزة'),
          ],
        ),

        // 5. جزيرة اللؤلؤة
        BaseServiceItem(
          id: 't5',
          name: 'جزيرة اللؤلؤة',
          subTitle: 'أيقونة الفخامة والواجهات البحرية واليخوت',
          aboutText: 'جزيرة اصطناعية فاخرة تضم مراسي يخوت عالمية، قنوات مائية على طراز البندقية، أرقى المطاعم والمقاهي، وأفضل الماركات العالمية.',
          imageUrl: Assets.images.tourism5.path,
          address: 'الخليج الغربي، الدوحة',
          rating: 4.8,
          reviewsCount: 3400,
          distance: '8.0 كم',
          category: 'شواطئ وجزر',
          serviceType: 'Tourism',
          hours: 'مفتوح دائماً',
          features: const [
            ServiceFeature(icon: Iconsax.ship, label: 'مرسى يخوت فاخر وقنوات مائية'),
            ServiceFeature(icon: Iconsax.shop, label: 'أفخم الماركات والمطاعم العالمية'),
          ],
        ),

        // 6. حديقة أسباير
        BaseServiceItem(
          id: 't6',
          name: 'حديقة أسباير',
          subTitle: 'الرئة الخضراء النابضة بالحياة وسط أسباير زون',
          aboutText: 'أكبر حديقة في الدوحة، تضم مساحات خضراء شاسعة، مضامير مخصصة للمشي والركض وركوب الدراجات، وبحيرة صناعية واسعة تضفي أجواء هادئة.',
          imageUrl: Assets.images.tourism6.path,
          address: 'منطقة أسباير زون، الوعب',
          rating: 4.7,
          reviewsCount: 2100,
          distance: '6.5 كم',
          category: 'حدائق ومنتزهات',
          serviceType: 'Tourism',
          hours: 'مفتوح دائماً',
          features: const [
            ServiceFeature(icon: Iconsax.activity, label: 'مضامير للمشي والركض وركوب الدراجات'),
            ServiceFeature(icon: Iconsax.sun_1, label: 'بحيرة كبيرة مع قوارب صغيرة للتجديف'),
          ],
        ),

        // 7. شاطئ سيلين والكثبان الرملية
        BaseServiceItem(
          id: 't7',
          name: 'شاطئ وكثبان سيلين الرملية',
          subTitle: 'مغامرة الصحراء الساحرة ولقاء الكثبان بالبحر',
          aboutText: 'حيث تلامس الكثبان الرملية الذهبية مياه البحر الأزرق، تعتبر منطقة سيلين الوجهة الأولى لمحبّي التخييم، رحلات السفاري، وقيادة الدفع الرباعي.',
          imageUrl: Assets.images.tourism7.path,
          address: 'منطقة مسيعيد، جنوب قطر',
          rating: 4.6,
          reviewsCount: 1950,
          distance: '45.0 كم',
          category: 'شواطئ وجزر',
          serviceType: 'Tourism',
          hours: 'مفتوح دائماً',
          features: const [
            ServiceFeature(icon: Iconsax.routing, label: 'ركوب الجمال وقيادة سيارات الدفع الرباعي'),
            ServiceFeature(icon: Iconsax.cloud_sunny, label: 'موقع تخييم شتوي مثالي'),
          ],
        ),
      ]);

      // ── 3. تحديد الوجهات المميزة (Featured Items) ──
      featuredItems.assignAll(allItems.take(3).toList());

    } catch (e) {
      errorMessage.value = 'حدث خطأ أثناء جلب البيانات: $e';
    } finally {
      isLoading.value = false;
    }
  }
}