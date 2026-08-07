import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'payment_webview_controller.dart';

class PaymentWebViewScreen extends GetView<PaymentWebViewController> {
  const PaymentWebViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) controller.closeWithoutFinish();
        },
        child: Scaffold(
          backgroundColor: cs.surface,
          appBar: AppBar(
            backgroundColor: cs.surface,
            elevation: 0,
            leading: IconButton(
              onPressed: controller.closeWithoutFinish,
              icon: Icon(Iconsax.arrow_right_1, color: cs.primary),
            ),
            title: Text(
              'إتمام الدفع',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.primary,
              ),
            ),
            actions: [
              Obx(
                () => TextButton(
                  onPressed: controller.isCheckingStatus.value
                      ? null
                      : controller.manualCheck,
                  child: Text(
                    controller.isCheckingStatus.value
                        ? 'جاري التحقق...'
                        : 'تحقق الآن',
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Obx(
                () => LinearProgressIndicator(
                  value: controller.isLoading.value ? null : 1,
                  minHeight: 2,
                  backgroundColor: cs.surfaceContainerHighest,
                  color: cs.primary,
                ),
              ),
              Obx(
                () => Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 8.h,
                  ),
                  color: cs.primary.withValues(alpha: 0.06),
                  child: Text(
                    controller.statusLabel.value,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: cs.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: WebViewWidget(controller: controller.webViewController),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
