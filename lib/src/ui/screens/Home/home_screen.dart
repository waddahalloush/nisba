import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/ui/screens/Home/widgets/home_categories.dart';
import 'package:nisba_app/src/ui/screens/Home/widgets/home_daily_offers.dart';
import 'package:nisba_app/src/ui/screens/Home/widgets/home_header.dart';
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
          const HomeCategories(),

          // ─── 4. عروض اليوم القريبة منك ───
          const HomeDailyOffers(),

          // ─── 5. الخدمات ───
          const HomeServices(),

          // مسافة أمان سفليّة
          SliverToBoxAdapter(child: SizedBox(height: 200.h)),
        ],
      ),
    );
  }
}
