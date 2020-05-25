import 'package:flutter/foundation.dart';

enum DropType { current, another }

class DropMenuController extends ChangeNotifier {
  double dropDownHeaderHeight;

  int menuIndex = 0;

  bool isShow = false;

  bool isShowHideAnimation = false;

  DropType dropType;

  void show(int index) {
    isShow = true;
    menuIndex = index;
    notifyListeners();
  }

  void hide({bool isShowHideAnimation = true}) {
    this.isShowHideAnimation = isShowHideAnimation;
    isShow = false;
    notifyListeners();
  }
}