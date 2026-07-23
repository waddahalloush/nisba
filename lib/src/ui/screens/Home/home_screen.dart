import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/ui/screens/Home/widgets/home_categories.dart';
import 'package:nisba_app/src/ui/screens/Home/widgets/home_daily_offers.dart';
import 'package:nisba_app/src/ui/screens/Home/widgets/home_header.dart';
import 'package:nisba_app/src/ui/screens/Home/widgets/home_meals.dart';
import 'package:nisba_app/src/ui/screens/Home/widgets/home_services.dart';

import 'controller/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        controller: controller.scrollController,
        slivers: [
          // ─── 1 & 2. القسم العلوي المتداخل (الخلفية المتدرجة + العناصر) ───
          HomeHeader(controller: controller),

          // ─── 3. التصنيفات ───
          HomeCategories(categories: controller.homeCategoryList),
          HomeCategories(categories: controller.homeServiceList),

          // ─── 4. عروض اليوم القريبة منك ───
          HomeDailyOffers(
            title: 'عروض اليوم القريبة منك',
            productList: controller.dailyOfferList,
          ),

          HomeDailyOffers(
            title: 'مختارة لك ',
            productList: controller.selectedForYouList,
          ),

          // ─── 5. الخدمات ───
          const HomeBrands(),
          // ─── 5. وجبات ب 25 ريال  ───
          const HomeMeals(title: "وجبات بـ 25 ريال "),

          // مسافة أمان سفليّة
          SliverToBoxAdapter(child: SizedBox(height: 60.h)),
        ],
      ),
    );
  }
}
