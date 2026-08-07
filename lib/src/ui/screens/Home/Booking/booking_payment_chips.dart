import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/utils/booking_checkout_options.dart';

/// Compact payment method chips for booking screens.
class BookingPaymentChips extends StatelessWidget {
  final List<String> methods;
  final RxString selected;
  final ValueChanged<String> onSelect;

  const BookingPaymentChips({
    super.key,
    required this.methods,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final list = methods.isNotEmpty ? methods : const ['wallet'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('طريقة الدفع', style: theme.textTheme.titleMedium),
        SizedBox(height: 8.h),
        Obx(
          () => Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: list.map((m) {
              final sel = selected.value == m;
              return ChoiceChip(
                label: Text(BookingCheckoutOptions.labelForPayment(m)),
                selected: sel,
                onSelected: (_) => onSelect(m),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
