import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  final messages = <ChatMessage>[
    const ChatMessage(
      text: 'مرحباً، أنا جون مساعدك الافتراضي. كيف يمكنني مساعدتك اليوم؟',
      isUser: false,
      time: '07:30 م',
    ),
    const ChatMessage(text: 'مرحباً جون', isUser: true, time: '07:31 م'),
    const ChatMessage(
      text:
          'يمكنك التواصل مع فريق الدعم الخاص بنا على مدار الساعة عبر تطبيق نسبة. نضمن لك الرد خلال 24 ساعة كحد أقصى.',
      isUser: false,
      time: '07:33 م',
    ),
  ].obs;

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : now.hour;
    final period = now.hour >= 12 ? 'م' : 'ص';
    final time =
        '${hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} $period';

    messages.add(ChatMessage(text: text, isUser: true, time: time));
    messageController.clear();

    // Simulate auto-reply
    Future.delayed(const Duration(seconds: 2), () {
      final replyHour = DateTime.now().hour > 12
          ? DateTime.now().hour - 12
          : DateTime.now().hour;
      final replyPeriod = DateTime.now().hour >= 12 ? 'م' : 'ص';
      final replyTime =
          '$replyHour:${DateTime.now().minute.toString().padLeft(2, '0')} $replyPeriod';

      messages.add(
        const ChatMessage(
          text: 'شكراً لتواصلك معنا. سنقوم بالرد عليك في أقرب وقت ممكن.',
          isUser: false,
          time: '',
        ),
      );
      // Update time of the auto-reply
      messages.last = ChatMessage(
        text: messages.last.text,
        isUser: false,
        time: replyTime,
      );
    });
  }

  void endChat() {
    Get.back();
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}
