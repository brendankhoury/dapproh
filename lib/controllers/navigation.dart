import 'package:flutter/material.dart';

class NavigationController extends ChangeNotifier {
  String screenName = '/home'; //'/start';
  void changeScreen(String newScreenName) {
    debugPrint("Routec change: $screenName to $newScreenName");
    screenName = newScreenName;
    notifyListeners();
  }
}
