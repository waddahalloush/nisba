import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

import 'customer_support_controller.dart';

class CustomerSupportScreen extends GetView<CustomerSupportController> {
  const CustomerSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: cs.surfaceContainerHighest,
        appBar: AppBar(
          backgroundColor: cs.primary,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Iconsax.arrow_right_1, color: cs.onPrimary),
          ),
          title: Row(
            children: [
              Container(
                width: 36.w,
                height: 36.h,
                decoration: BoxDecoration(
                  color: cs.onPrimary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Iconsax.headphone,
                  color: cs.onPrimary,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الدعم الفني',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: cs.onPrimary,
                      ),
                    ),
                    Text(
                      'متصل الآن',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: cs.onPrimary.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: controller.endChat,
              child: Text(
                'إنهاء المحادثة',
                style: TextStyle(
                  color: cs.onPrimary,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // ── Chat messages ──
            Expanded(child: _buildChatList(theme)),

            // ── Input bar ──
            _buildInputBar(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildChatList(ThemeData theme) {
    return Obx(
      () => ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        itemCount: controller.messages.length,
        itemBuilder: (context, index) {
          final msg = controller.messages[index];
          final isUser = msg.isUser;
          return Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: _ChatBubble(message: msg),
          );
        },
      ),
    );
  }

  Widget _buildInputBar(ThemeData theme) {
    final cs = theme.colorScheme;

    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 10.h),
      decoration: BoxDecoration(
        color: cs.surface,
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Emoji button
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.emoji_emotions_outlined,
              color: cs.onSurface.withValues(alpha: 0.45),
              size: 22.sp,
            ),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(minWidth: 36.w),
          ),

          // Text field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: TextFormField(
                controller: controller.messageController,
                textInputAction: TextInputAction.send,
                onFieldSubmitted: (_) => controller.sendMessage(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: 'اكتب رسالتك...',
                  hintStyle: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.35),
                    fontSize: 13.sp,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(width: 6.w),

          // Send button
          GestureDetector(
            onTap: controller.sendMessage,
            child: Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: cs.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(Iconsax.send_2, color: cs.onPrimary, size: 18.sp),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isUser = message.isUser;

    return Row(
      mainAxisAlignment: isUser
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (isUser) ...[
          // User avatar
          Container(
            width: 32.w,
            height: 32.h,
            margin: EdgeInsets.only(left: 8.w),
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(Iconsax.user, color: cs.primary, size: 16.sp),
          ),
        ],

        // Bubble
        Flexible(
          child: Container(
            constraints: BoxConstraints(maxWidth: Get.width * 0.72),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: isUser ? cs.primary.withValues(alpha: 0.06) : cs.primary,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(18.r),
                topLeft: Radius.circular(18.r),
                bottomRight: isUser
                    ? Radius.circular(18.r)
                    : Radius.circular(4.r),
                bottomLeft: isUser
                    ? Radius.circular(4.r)
                    : Radius.circular(18.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.text,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: isUser ? cs.onSurface : cs.onPrimary,
                    height: 1.5,
                  ),
                ),
                if (message.time.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Text(
                      message.time,
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: isUser
                            ? cs.onSurface.withValues(alpha: 0.35)
                            : cs.onPrimary.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        if (!isUser) ...[
          SizedBox(width: 8.w),
          // Bot avatar
          Container(
            width: 32.w,
            height: 32.h,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(Iconsax.headphone, color: cs.primary, size: 16.sp),
          ),
        ],
      ],
    );
  }
}
