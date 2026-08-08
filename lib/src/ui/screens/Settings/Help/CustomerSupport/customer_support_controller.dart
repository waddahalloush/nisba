import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nisba_app/src/data/repository.dart';
import 'package:nisba_app/src/utils/api_result.dart';
import 'package:nisba_app/src/utils/app_snackbar.dart';
import 'package:nisba_app/src/utils/dio_error_util.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final String time;

  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
  });
}

class CustomerSupportController extends GetxController {
  final messageController = TextEditingController();
  final messages = <ChatMessage>[].obs;
  final contactPhone = ''.obs;
  final contactEmail = ''.obs;
  final isLoading = false.obs;
  final isSending = false.obs;

  /// Backend [InquiryType]: contact | faq | complaint
  final inquiryType = 'contact'.obs;

  final Repository repository = Get.find();
  final InternetConnectionChecker connectionChecker = Get.find();

  @override
  void onInit() {
    super.onInit();
    loadSupportData();
  }

  Future<void> loadSupportData() async {
    if (!await connectionChecker.hasConnection) {
      AppSnackbar.showError(message: 'check_connection'.tr);
      return;
    }
    isLoading.value = true;
    try {
      await Future.wait([_fetchContactInfo(), _fetchInquiries()]);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchContactInfo() async {
    try {
      final res = await repository.getContactInfo();
      final data = ApiResult.ensureSuccess(res);
      if (data is Map) {
        contactPhone.value = data['phone']?.toString() ?? '';
        contactEmail.value = data['email']?.toString() ?? '';
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _fetchInquiries() async {
    try {
      final res = await repository.getInquiries();
      final data = ApiResult.ensureSuccess(res);
      final list = data is Map ? (data['inquiries'] as List? ?? []) : [];

      final mapped = <ChatMessage>[];
      if (contactPhone.value.isNotEmpty || contactEmail.value.isNotEmpty) {
        mapped.add(
          ChatMessage(
            text:
                '${contactPhone.value.isNotEmpty ? "${'phone_number_hint'.tr}: ${contactPhone.value}\n" : ""}${contactEmail.value.isNotEmpty ? "${'email'.tr}: ${contactEmail.value}" : ""}',
            isUser: false,
            time: '',
          ),
        );
      } else {
        mapped.add(
          ChatMessage(text: 'auto_key_620'.tr, isUser: false, time: ''),
        );
      }

      for (final raw in list.whereType<Map>().toList().reversed) {
        final msg = raw['msg']?.toString() ?? '';
        if (msg.isEmpty) continue;
        mapped.add(
          ChatMessage(
            text: msg,
            isUser: true,
            time: raw['created_at']?.toString() ?? '',
          ),
        );
      }
      messages.assignAll(mapped);
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
    } on DioException catch (e) {
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty || isSending.value) return;

    if (!await connectionChecker.hasConnection) {
      AppSnackbar.showError(message: 'check_connection'.tr);
      return;
    }

    final time = _formatTime(DateTime.now());
    messages.add(ChatMessage(text: text, isUser: true, time: time));
    messageController.clear();
    isSending.value = true;

    try {
      // Valid InquiryType values: contact, faq, complaint
      final type = inquiryType.value == 'complaint' ? 'complaint' : 'contact';
      final res = await repository.storeInquiry(
        data: {'type': type, 'msg': text},
      );
      ApiResult.ensureSuccess(res);
      messages.add(
        ChatMessage(
          text: 'auto_key_621'.tr,
          isUser: false,
          time: _formatTime(DateTime.now()),
        ),
      );
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
    } on DioException catch (e) {
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    } catch (e) {
      AppSnackbar.showError(message: e.toString());
    } finally {
      isSending.value = false;
    }
  }

  void endChat() => Get.back();

  String _formatTime(DateTime now) {
    final hour = now.hour > 12
        ? now.hour - 12
        : (now.hour == 0 ? 12 : now.hour);
    final period = now.hour >= 12 ? 'auto_key_415'.tr : 'auto_key_416'.tr;
    return '${hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} $period';
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}
