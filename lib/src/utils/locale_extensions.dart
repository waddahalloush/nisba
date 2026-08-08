import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../configs/locale_constants.dart';
import '../services/locale_service.dart';

extension LocaleContext on BuildContext {
  bool get isRtl {
    if (Get.isRegistered<LocaleService>()) {
      return Get.find<LocaleService>().isRtl;
    }
    return Directionality.of(this) == TextDirection.rtl;
  }

  TextDirection get appTextDirection =>
      isRtl ? TextDirection.rtl : TextDirection.ltr;
}

/// Global direction-aware back icon (no context required).
IconData get appBackIconData {
  return isAppRtl ? Iconsax.arrow_right_1 : Iconsax.arrow_left_2;
}

/// Direction-aware back icon for AppBar leading buttons.
IconData backIconData([BuildContext? context]) {
  return isAppRtl ? Iconsax.arrow_right_1 : Iconsax.arrow_left_2;
}

/// Direction-aware list trailing chevron.
IconData forwardChevronData([BuildContext? context]) {
  return isAppRtl ? Icons.chevron_left_rounded : Icons.chevron_right_rounded;
}

bool get isAppRtl {
  if (Get.isRegistered<LocaleService>()) {
    return Get.find<LocaleService>().isRtl;
  }
  return Get.locale?.languageCode == LocaleConstants.arabic;
}
