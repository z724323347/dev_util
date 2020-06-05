import 'wah_size_fit.dart';

extension IntFit on int {
  double get px {
    return WaHSizeFit.setPx(this.toDouble());
  }

  double get rpx {
    return WaHSizeFit.setRpx(this.toDouble());
  }
}

extension DoubleFit on double {
  double get px {
    return WaHSizeFit.setPx(this);
  }

  double get rpx {
    return WaHSizeFit.setRpx(this);
  }
}
