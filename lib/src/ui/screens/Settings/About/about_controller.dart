import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutController extends GetxController {
  final appName = 'Nisba'.obs;
  final email = 'support@yourapp.com'.obs;
  final phone = '+974 41 123 456'.obs;
  final whatsapp = '+974 41 123 456'.obs;
  final address = 'الدوحة، قطر'.obs;
  final workingHours = 'يومياً من 9 صباحاً حتى 11 مساءً'.obs;

  void openEmail() async {
    final uri = Uri.parse('mailto:${email.value}');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  void callPhone() async {
    final uri = Uri.parse('tel:${phone.value}');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  void openWhatsApp() async {
    final uri = Uri.parse(
      'https://wa.me/${whatsapp.value.replaceAll(' ', '')}',
    );
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }
}
