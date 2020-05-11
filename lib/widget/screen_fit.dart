import 'package:flutter/material.dart';
import 'dart:ui' as ui show window;

/**
 * 配置设计稿尺寸（单位 dp or pt）
 * width  宽
 * height 高
 * density 像素密度
 */
///默认设计稿尺寸（单位 dp or pt）
// double designW = 360.0;
// double designH = 640.0;
// double designD = 3.0;

/// 配置设计稿尺寸 屏幕 宽，高，密度。
/// Configuration design draft size  screen width, height, density.
// void screenSetDesign(double width, double height, {double density = 3.0}) {
//   _designW = width ?? _designW;
//   _designH = height ?? _designH;
//   _designD = density ?? _designD;
// }

/// Screen Fit.
class ScreenFit {
  ///默认设计稿尺寸（单位 dp or pt）
  double designW ;
  double designH ;
  double designD ;

  double _screenWidth = 0.0;
  double _screenHeight = 0.0;
  double _screenDensity = 0.0;
  double _statusBarHeight = 0.0;
  double _bottomBarHeight = 0.0;
  double _appBarHeight = 0.0;
  MediaQueryData _mediaQueryData;

  static final ScreenFit _singleton = ScreenFit();

  /// 配置设计稿尺寸 屏幕 宽，高，密度。
  /// Configuration design draft size  screen width, height, density.
  ScreenFit({
    this.designW = 360.0,
    this.designH = 640.0,
    this.designD = 3.0,
  });

  static ScreenFit getInstance() {
    _singleton.init();
    return _singleton;
  }

  init() {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    if (_mediaQueryData != mediaQuery) {
      _mediaQueryData = mediaQuery;
      _screenWidth = mediaQuery.size.width;
      _screenHeight = mediaQuery.size.height;
      _screenDensity = mediaQuery.devicePixelRatio;
      _statusBarHeight = mediaQuery.padding.top;
      _bottomBarHeight = mediaQuery.padding.bottom;
      _appBarHeight = kToolbarHeight;
    }
  }

  /// screen width
  /// 屏幕 宽
  double get screenWidth => _screenWidth;

  /// screen height
  /// 屏幕 高
  double get screenHeight => _screenHeight;

  /// appBar height
  /// appBar 高
  double get appBarHeight => _appBarHeight;

  /// screen density
  /// 屏幕 像素密度
  double get screenDensity => _screenDensity;

  /// status bar Height
  /// 状态栏高度
  double get statusBarHeight => _statusBarHeight;

  /// bottom bar Height
  double get bottomBarHeight => _bottomBarHeight;

  /// media Query Data
  MediaQueryData get mediaQueryData => _mediaQueryData;

  /// screen width
  /// 当前屏幕 宽
  static double getScreenW(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.width;
  }

  /// screen height
  /// 当前屏幕 高
  static double getScreenH(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.height;
  }

  /// screen density
  /// 当前屏幕 像素密度
  static double getScreenDensity(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return mediaQuery.devicePixelRatio;
  }

  /// status bar Height
  /// 当前状态栏高度
  static double getStatusBarHeight(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return mediaQuery.padding.top;
  }

  /// status bar Height
  /// 当前BottomBar高度
  static double getBottomBarHeight(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return mediaQuery.padding.bottom;
  }

  /// 当前MediaQueryData
  static MediaQueryData getMediaQueryData(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return mediaQuery;
  }

  /// Orientation
  /// 设备方向(portrait, landscape)
  static Orientation getOrientation(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return mediaQuery.orientation;
  }

  /// 兼容横/竖屏。
  /// 获取适配后的尺寸，兼容横/竖屏切换，可用于宽，高，字体尺寸适配。
  /// Get the appropriate size, compatible with horizontal/vertical screen switching, can be used for wide, high, font size adaptation.
  double setAdapterSize(double dp) {
    if (_screenWidth == 0 || _screenHeight == 0) return dp;
    return getRatio() * dp;
  }

  /// 适配比率。
  /// Ratio.
  double getRatio() {
    return (_screenWidth > _screenHeight ? _screenHeight : _screenWidth) /
        designW;
  }

  /// 兼容横/竖屏。
  /// 获取适配后的尺寸，兼容横/竖屏切换，适应宽，高，字体尺寸。
  /// Get the appropriate size, compatible with horizontal/vertical screen switching, can be used for wide, high, font size adaptation.
  double setAdapterSizeCtx(BuildContext context, double dp) {
    Size size = MediaQuery.of(context).size;
    if (size == Size.zero) return dp;
    return getRatioCtx(context) * dp;
  }

  /// 适配比率。
  /// Ratio.
  double getRatioCtx(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return (size.width > size.height ? size.height : size.width) / designW;
  }
}
