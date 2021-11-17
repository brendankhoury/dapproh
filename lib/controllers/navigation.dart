import 'package:flutter/material.dart';

class NavigationController extends ChangeNotifier {
  String screenName = '/home'; //'/start';
  String imagePath = '';

  void setImagePath(String imagePath) {
    this.imagePath = imagePath;
  }

  void changeScreen(String newScreenName) {
    debugPrint("Routec change: $screenName to $newScreenName");
    screenName = newScreenName;
    notifyListeners();
  }
}
