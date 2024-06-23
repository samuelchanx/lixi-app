/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/Animation - 1709482057336.json
  String get animation1709482057336 =>
      'assets/images/Animation - 1709482057336.json';

  /// File path: assets/images/app_icon.png
  AssetGenImage get appIcon =>
      const AssetGenImage('assets/images/app_icon.png');

  /// File path: assets/images/lixi_splash.gif
  AssetGenImage get lixiSplash =>
      const AssetGenImage('assets/images/lixi_splash.gif');

  /// File path: assets/images/lixi_splash_flash.gif
  AssetGenImage get lixiSplashFlash =>
      const AssetGenImage('assets/images/lixi_splash_flash.gif');

  /// File path: assets/images/lixi_splash_rotate.gif
  AssetGenImage get lixiSplashRotate =>
      const AssetGenImage('assets/images/lixi_splash_rotate.gif');

  /// File path: assets/images/logo.svg
  SvgGenImage get logo => const SvgGenImage('assets/images/logo.svg');

  /// File path: assets/images/m-gun-red.png
  AssetGenImage get mGunRedPng =>
      const AssetGenImage('assets/images/m-gun-red.png');

  /// File path: assets/images/m-gun-red.svg
  SvgGenImage get mGunRedSvg =>
      const SvgGenImage('assets/images/m-gun-red.svg');

  /// File path: assets/images/m-gun.png
  AssetGenImage get mGunPng => const AssetGenImage('assets/images/m-gun.png');

  /// File path: assets/images/m-gun.svg
  SvgGenImage get mGunSvg => const SvgGenImage('assets/images/m-gun.svg');

  /// File path: assets/images/pregnancy-new.png
  AssetGenImage get pregnancyNew =>
      const AssetGenImage('assets/images/pregnancy-new.png');

  /// File path: assets/images/pregnancy.png
  AssetGenImage get pregnancy =>
      const AssetGenImage('assets/images/pregnancy.png');

  /// File path: assets/images/texture_1.png
  AssetGenImage get texture1 =>
      const AssetGenImage('assets/images/texture_1.png');

  /// File path: assets/images/texture_2.png
  AssetGenImage get texture2 =>
      const AssetGenImage('assets/images/texture_2.png');

  /// File path: assets/images/texture_3.png
  AssetGenImage get texture3 =>
      const AssetGenImage('assets/images/texture_3.png');

  /// File path: assets/images/texture_4.png
  AssetGenImage get texture4 =>
      const AssetGenImage('assets/images/texture_4.png');

  /// List of all assets
  List<dynamic> get values => [
        animation1709482057336,
        appIcon,
        lixiSplash,
        lixiSplashFlash,
        lixiSplashRotate,
        logo,
        mGunRedPng,
        mGunRedSvg,
        mGunPng,
        mGunSvg,
        pregnancyNew,
        pregnancy,
        texture1,
        texture2,
        texture3,
        texture4
      ];
}

class $AssetsSvgsGen {
  const $AssetsSvgsGen();

  /// File path: assets/svgs/static_splash.svg
  SvgGenImage get staticSplash =>
      const SvgGenImage('assets/svgs/static_splash.svg');

  /// List of all assets
  List<SvgGenImage> get values => [staticSplash];
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsSvgsGen svgs = $AssetsSvgsGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

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
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
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

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class SvgGenImage {
  const SvgGenImage(this._assetName);

  final String _assetName;

  SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    SvgTheme theme = const SvgTheme(),
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    return SvgPicture.asset(
      _assetName,
      key: key,
      matchTextDirection: matchTextDirection,
      bundle: bundle,
      package: package,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      theme: theme,
      colorFilter: colorFilter,
      color: color,
      colorBlendMode: colorBlendMode,
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
