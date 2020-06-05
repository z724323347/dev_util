import 'screen_fit.dart';

/// eg: 简化适配代码示例
///
///  示例， 把该文件配置到项目中
///
///  使用：
///  Container(
///     width: 200.rpx,
///     height: 40.px,
///   )
///  or
///  Container(
///     width: IntFit(200).rpx,
///     height: IntFit(40).px,
///   )
///
extension IntFit on int {
  double get px {
    return ScreenFit.setPx(this.toDouble());
  }

  double get rpx {
    return ScreenFit.setRpx(this.toDouble());
  }
}

extension DoubleFit on double {
  double get px {
    return ScreenFit.setPx(this);
  }

  double get rpx {
    return ScreenFit.setRpx(this);
  }
}

extension StringX on String {}
