import 'package:flutter/material.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

/// الهيدر الثابت لشاشة البحث - خلفية برتقالية مع انحناء سفلي
class SearchHeader extends StatelessWidget {
  final Widget child;

  const SearchHeader({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 30.h,
        bottom: 18.h,
        left: 14.w,
        right: 14.w,
      ),
      decoration: BoxDecoration(
        color: cs.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(45),
          bottomRight: Radius.circular(45),
        ),
      ),
      child: child,
    );
  }
}
