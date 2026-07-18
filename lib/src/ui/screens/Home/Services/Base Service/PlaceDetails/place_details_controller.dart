import 'package:get/get.dart';

import '../../../../../../data/models/service_model.dart';

class PlaceDetailsController extends GetxController {
  late final BaseServiceItem item;
  final isFavorite = false.obs;

  @override
  void onInit() {
    // استقبال الكائن الممرر من الشاشة السابقة
    if (Get.arguments is BaseServiceItem) {
      item = Get.arguments as BaseServiceItem;
    } else {
      // حماية في حال تم الدخول للشاشة بشكل خاطئ
      Get.back();
    }

    super.onInit();
  }

  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
    // هنا يمكنك إضافة منطق حفظ العنصر في قاعدة البيانات المحلية أو السيرفر لاحقاً
  }
}
