// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/app-icon.jpg
  AssetGenImage get appIcon =>
      const AssetGenImage('assets/images/app-icon.jpg');

  /// File path: assets/images/banner-img.jpg
  AssetGenImage get bannerImg =>
      const AssetGenImage('assets/images/banner-img.jpg');

  /// File path: assets/images/box.png
  AssetGenImage get box => const AssetGenImage('assets/images/box.png');

  /// File path: assets/images/cat-cafee.jpg
  AssetGenImage get catCafee =>
      const AssetGenImage('assets/images/cat-cafee.jpg');

  /// File path: assets/images/cat-food.jpg
  AssetGenImage get catFood =>
      const AssetGenImage('assets/images/cat-food.jpg');

  /// File path: assets/images/cat-offer.jpg
  AssetGenImage get catOffer =>
      const AssetGenImage('assets/images/cat-offer.jpg');

  /// File path: assets/images/cat-vigi.jpg
  AssetGenImage get catVigi =>
      const AssetGenImage('assets/images/cat-vigi.jpg');

  /// File path: assets/images/credit-offer.png
  AssetGenImage get creditOffer =>
      const AssetGenImage('assets/images/credit-offer.png');

  /// File path: assets/images/delivery-man.png
  AssetGenImage get deliveryMan =>
      const AssetGenImage('assets/images/delivery-man.png');

  /// File path: assets/images/gift-money.png
  AssetGenImage get giftMoney =>
      const AssetGenImage('assets/images/gift-money.png');

  /// File path: assets/images/gift.png
  AssetGenImage get gift => const AssetGenImage('assets/images/gift.png');

  /// File path: assets/images/google-logo.png
  AssetGenImage get googleLogo =>
      const AssetGenImage('assets/images/google-logo.png');

  /// File path: assets/images/logo+.png
  AssetGenImage get logo => const AssetGenImage('assets/images/logo+.png');

  /// File path: assets/images/logo2d.png
  AssetGenImage get logo2d => const AssetGenImage('assets/images/logo2d.png');

  /// File path: assets/images/logo3d.png
  AssetGenImage get logo3d => const AssetGenImage('assets/images/logo3d.png');

  /// File path: assets/images/money.png
  AssetGenImage get money => const AssetGenImage('assets/images/money.png');

  /// File path: assets/images/offer1.jpg
  AssetGenImage get offer1 => const AssetGenImage('assets/images/offer1.jpg');

  /// File path: assets/images/offer2.jpg
  AssetGenImage get offer2 => const AssetGenImage('assets/images/offer2.jpg');

  /// File path: assets/images/offer3.jpg
  AssetGenImage get offer3 => const AssetGenImage('assets/images/offer3.jpg');

  /// File path: assets/images/order-noti.png
  AssetGenImage get orderNoti =>
      const AssetGenImage('assets/images/order-noti.png');

  /// File path: assets/images/privacy.png
  AssetGenImage get privacy => const AssetGenImage('assets/images/privacy.png');

  /// File path: assets/images/rewards.png
  AssetGenImage get rewards => const AssetGenImage('assets/images/rewards.png');

  /// File path: assets/images/service1.jpg
  AssetGenImage get service1 =>
      const AssetGenImage('assets/images/service1.jpg');

  /// File path: assets/images/service2.jpg
  AssetGenImage get service2 =>
      const AssetGenImage('assets/images/service2.jpg');

  /// File path: assets/images/service3.jpg
  AssetGenImage get service3 =>
      const AssetGenImage('assets/images/service3.jpg');

  /// File path: assets/images/service4.jpg
  AssetGenImage get service4 =>
      const AssetGenImage('assets/images/service4.jpg');

  /// List of all assets
  List<AssetGenImage> get values => [
    appIcon,
    bannerImg,
    box,
    catCafee,
    catFood,
    catOffer,
    catVigi,
    creditOffer,
    deliveryMan,
    giftMoney,
    gift,
    googleLogo,
    logo,
    logo2d,
    logo3d,
    money,
    offer1,
    offer2,
    offer3,
    orderNoti,
    privacy,
    rewards,
    service1,
    service2,
    service3,
    service4,
  ];
}

class Assets {
  const Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
