import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nisba_app/src/data/repository.dart';
import 'package:nisba_app/src/utils/api_result.dart';
import 'package:nisba_app/src/utils/app_snackbar.dart';
import 'package:nisba_app/src/utils/dio_error_util.dart';

class OrderChatMessage {
  final String text;
  final bool isMine;
  final String time;
  final String? temporaryId;

  const OrderChatMessage({
    required this.text,
    required this.isMine,
    required this.time,
    this.temporaryId,
  });
}

class OrderChatController extends GetxController {
  final messageController = TextEditingController();
  final messages = <OrderChatMessage>[].obs;
  final isLoading = false.obs;
  final isSending = false.obs;

  late final int orderId;

  final Repository repository = Get.find();
  final InternetConnectionChecker connectionChecker = Get.find();

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    orderId = arg is int
        ? arg
        : int.tryParse(arg?.toString() ?? '') ?? 0;
    if (orderId > 0) {
      loadMessages();
    }
  }

  Future<void> loadMessages() async {
    if (!await connectionChecker.hasConnection) {
      AppSnackbar.showError(message: 'check_connection'.tr);
      return;
    }
    isLoading.value = true;
    try {
      final res = await repository.getOrderChat(orderId);
      final data = ApiResult.ensureSuccess(res);
      final list = data is Map ? (data['chats'] as List? ?? []) : [];

      final mapped = list.whereType<Map>().map((raw) {
        final content = raw['content']?.toString() ?? '';
        final created = raw['created_at']?.toString() ?? '';
        // Client messages have user; treat presence of user id matching as mine.
        final isMine = raw['user'] != null;
        return OrderChatMessage(
          text: content,
          isMine: isMine,
          time: created,
        );
      }).toList();

      // API returns desc order — reverse for chat UI
      messages.assignAll(mapped.reversed.toList());
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
    } on DioException catch (e) {
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    } catch (e) {
      log(e.toString());
      AppSnackbar.showError(message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty || isSending.value || orderId <= 0) return;

    if (!await connectionChecker.hasConnection) {
      AppSnackbar.showError(message: 'check_connection'.tr);
      return;
    }

    final temporaryId =
        'tmp_${DateTime.now().millisecondsSinceEpoch}_${messages.length}';
    final optimistic = OrderChatMessage(
      text: text,
      isMine: true,
      time: _formatTime(DateTime.now()),
      temporaryId: temporaryId,
    );
    messages.add(optimistic);
    messageController.clear();
    isSending.value = true;

    try {
      final res = await repository.sendChatMessage(data: {
        'order_id': orderId,
        'chat_id': orderId,
        'content': text,
        'temporary_id': temporaryId,
        'type': 'text',
      });
      ApiResult.ensureSuccess(res);
      // Optionally refresh to sync server timestamps
      await loadMessages();
    } on ApiException catch (e) {
      messages.removeWhere((m) => m.temporaryId == temporaryId);
      AppSnackbar.showError(message: e.message);
    } on DioException catch (e) {
      messages.removeWhere((m) => m.temporaryId == temporaryId);
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    } catch (e) {
      messages.removeWhere((m) => m.temporaryId == temporaryId);
      AppSnackbar.showError(message: e.toString());
    } finally {
      isSending.value = false;
    }
  }

  String _formatTime(DateTime now) {
    final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final period = now.hour >= 12 ? 'م' : 'ص';
    return '${hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} $period';
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}
