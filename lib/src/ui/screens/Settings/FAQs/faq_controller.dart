import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class FaqItem {
  final IconData icon;
  final String question;
  final String subtitle;
  final String? answerTitle;
  final String? answerDesc;

  const FaqItem({
    required this.icon,
    required this.question,
    required this.subtitle,
    this.answerTitle,
    this.answerDesc,
  });
}

class FaqController extends GetxController {
  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  final expandedIndex = (-1).obs;

  final faqs = <FaqItem>[
    const FaqItem(
      icon: Iconsax.mobile,
      question: 'كيف تستخدم التطبيق',
      subtitle: 'تعرف على كيفية استخدام تطبيقنا بخطوات بسيطة',
      answerTitle: 'كيف تستخدم التطبيق',
      answerDesc: 'دليل شامل لفهم واستخدام جميع ميزات التطبيق خطوة بخطوة.',
    ),
    const FaqItem(
      icon: Iconsax.wallet_2,
      question: 'كيف تشحن محفظتك',
      subtitle: 'طرق شحن المحفظة بسهولة وأمان',
      answerTitle: 'كيف تشحن محفظتك',
      answerDesc: 'يمكنك شحن محفظتك عبر البطاقات البنكية أو التحويل المباشر.',
    ),
    const FaqItem(
      icon: Iconsax.truck_fast,
      question: 'متى يصلك طلبك',
      subtitle: 'تعرف على أوقات التوصيل المتوقعة',
      answerTitle: 'متى يصلك طلبك',
      answerDesc: 'يتم توصيل الطلبات خلال 30-60 دقيقة حسب موقعك.',
    ),
    const FaqItem(
      icon: Iconsax.card,
      question: 'طرق الدفع المتاحة',
      subtitle: 'تعرف على طرق الدفع المدعومة',
    ),
    const FaqItem(
      icon: Iconsax.refresh,
      question: 'كيف تسترجع طلبك',
      subtitle: 'سياسة الاسترجاع والاستبدال',
    ),
  ];

  List<FaqItem> get filteredFaqs {
    if (searchQuery.value.isEmpty) return faqs;
    return faqs
        .where(
          (f) =>
              f.question.contains(searchQuery.value) ||
              f.subtitle.contains(searchQuery.value),
        )
        .toList();
  }

  void toggleExpand(int index) {
    expandedIndex.value = expandedIndex.value == index ? -1 : index;
  }

  void onSearch(String value) => searchQuery.value = value;

  void contactSupport() {
    // TODO: Open support chat
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
