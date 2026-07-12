import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Semantic colors that are not covered by [ColorScheme] (success, link, etc.).
/// Access via `Theme.of(context).extension<ZatheExtras>()!`.
@immutable
class ZatheExtras extends ThemeExtension<ZatheExtras> {
  const ZatheExtras({
    required this.success,
    required this.link,
    required this.star,
  });

  final Color success;
  final Color link;
  final Color star;

  static const ZatheExtras light = ZatheExtras(
    success: AppColors.successColor,
    link: Color(0xFF2CA4F5),
    star: AppColors.star,
  );

  static const ZatheExtras dark = ZatheExtras(
    success: AppColors.successColor,
    link: Color(0xFF5EB8FF),
    star: AppColors.star,
  );

  @override
  ZatheExtras copyWith({
    Color? success,
    Color? link,
    Color? star,
  }) {
    return ZatheExtras(
      success: success ?? this.success,
      link: link ?? this.link,
      star: star ?? this.star,
    );
  }

  @override
  ZatheExtras lerp(ThemeExtension<ZatheExtras>? other, double t) {
    if (other is! ZatheExtras) return this;
    return ZatheExtras(
      success: Color.lerp(success, other.success, t)!,
      link: Color.lerp(link, other.link, t)!,
      star: Color.lerp(star, other.star, t)!,
    );
  }
}

extension ZatheExtrasContext on BuildContext {
  ZatheExtras get zatheExtras =>
      Theme.of(this).extension<ZatheExtras>() ?? ZatheExtras.light;
}
