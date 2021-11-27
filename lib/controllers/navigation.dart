import 'package:flutter/material.dart';

class NavigationController extends ChangeNotifier {
  String screenName = '/home'; //'/start';
  String imagePath = '';
  String postDescription = '';

  void setImagePath(String imagePath) {
    this.imagePath = imagePath;
  }

  void setPostDescription(String postDescription) {
    this.postDescription = postDescription;
  }

  void changeScreen(String newScreenName) {
    debugPrint("Routec change: $screenName to $newScreenName");
    screenName = newScreenName;
    notifyListeners();
  }
}
