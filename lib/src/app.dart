import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'configs/app_theme.dart';
import 'di/app_bindings.dart';
import 'routes/app_pages.dart';
import 'routes/routes_names.dart';
import 'services/locale_service.dart';
import 'services/theme_service.dart';
import 'translations/app_translations.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    final localeService = Get.find<LocaleService>();

    return Obx(() {
      final isDark = themeService.isDarkMode.value;
      final primaryColor = themeService.primaryColor.value;

      return GetMaterialApp(
        builder: (context, child) {
          return Theme(
            data: isDark
                ? ThemesData.darkTheme(primaryColor)
                : ThemesData.lightTheme(primaryColor),
            child: MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: const TextScaler.linear(1)),
              child: child!,
            ),
          );
        },
        title: 'app_title'.tr,
        debugShowCheckedModeBanner: false,
        theme: ThemesData.lightTheme(primaryColor),
        darkTheme: ThemesData.darkTheme(primaryColor),
        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
        translations: AppTranslations(),
        locale: localeService.locale.value,
        fallbackLocale: const Locale('en'),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ar'), Locale('en')],
        defaultTransition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 280),
        initialRoute: AppRoutesNames.splashScreen,
        getPages: AppPages.pages,
        initialBinding: AppBinding(),
      );
    });
  }
}
