import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nisba_app/src/data/repository.dart';
import 'package:nisba_app/src/routes/routes_names.dart';
import 'package:nisba_app/src/utils/api_result.dart';
import 'package:nisba_app/src/utils/app_snackbar.dart';
import 'package:nisba_app/src/utils/dio_error_util.dart';

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

  factory FaqItem.fromApiMap(Map raw) {
    final map = Map<String, dynamic>.from(raw);
    final question = map['question']?.toString() ?? '';
    final answer = map['answer']?.toString() ?? '';
    return FaqItem(
      icon: Iconsax.message_question,
      question: question,
      subtitle: answer.length > 60 ? '${answer.substring(0, 60)}...' : answer,
      answerTitle: question,
      answerDesc: answer,
    );
  }
}

class FaqController extends GetxController {
  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  final expandedIndex = (-1).obs;
  final faqs = <FaqItem>[].obs;
  final isLoading = false.obs;

  final Repository repository = Get.find();
  final InternetConnectionChecker connectionChecker = Get.find();

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

  @override
  void onInit() {
    super.onInit();
    fetchFaqs();
  }

  Future<void> fetchFaqs() async {
    if (!await connectionChecker.hasConnection) {
      AppSnackbar.showError(message: 'check_connection'.tr);
      return;
    }
    isLoading.value = true;
    try {
      final res = await repository.getFaqs();
      final data = ApiResult.ensureSuccess(res);
      final list = data is Map
          ? (data['faqs'] as List? ?? [])
          : (data is List ? data : []);
      faqs.assignAll(
        list.whereType<Map>().map(FaqItem.fromApiMap).toList(),
      );
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
    } on DioException catch (e) {
      log(e.toString());
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    } catch (e) {
      AppSnackbar.showError(message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void toggleExpand(int index) {
    expandedIndex.value = expandedIndex.value == index ? -1 : index;
  }

  void onSearch(String value) => searchQuery.value = value;

  void contactSupport() {
    Get.toNamed(AppRoutesNames.support);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
