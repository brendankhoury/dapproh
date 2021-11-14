import 'package:dapproh/controllers/navigation.dart';
import 'package:dapproh/screens/onboarding/confirm.dart';
import 'package:dapproh/screens/onboarding/create.dart';
import 'package:dapproh/screens/onboarding/restore.dart';
import 'package:dapproh/screens/onboarding/start.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  debugPrint("Starting app");

  await Hive.initFlutter();
  await Hive.openBox("mnemonic");
  // testSky();
  runApp(MultiProvider(providers: [
    ListenableProvider<NavigationController>(
      create: (_) => NavigationController(),
    ),
  ], child: const Dapproh()));
}

class Dapproh extends StatelessWidget {
  const Dapproh({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.dark(),
        home: Navigator(
          pages: getPages(context),
          onPopPage: (route, result) {
            bool popStatus = route.didPop(result);
            // TODO: Invalid implementation
            if (popStatus) {
              NavigationController navigation = Provider.of<NavigationController>(context, listen: false);
              navigation.changeScreen(navigation.screenName.substring(0, navigation.screenName.lastIndexOf('/')));
            }
            return popStatus;
          },
        ));
  }
}

List<Page> getPages(context) {
  NavigationController navigation = Provider.of<NavigationController>(context);

  List<Page> pages = [];

  navigation.screenName.split("/").forEach((element) {
    switch (element) {
      case 'start':
        pages.add(const MaterialPage(child: StartPage()));
        break;
      case 'create':
        pages.add(const MaterialPage(child: CreatePage()));
        break;
      case 'confirm':
        pages.add(const MaterialPage(child: ConfirmSignupPage()));
        break;
      case 'restore':
        pages.add(const MaterialPage(child: RestorePage()));
        break;
    }
  });

  // switch (navigation.screenName) {
  //   case '/start':
  //     pages.add(const MaterialPage(child: StartPage()));
  //     break;
  //   case '/create':
  //     pages.add(const MaterialPage(child: StartPage()));
  //     pages.add(const MaterialPage(child: CreatePage()));
  //     break;

  //   case '/confirm':
  //     pages.add(const MaterialPage(child: ConfirmSignupPage()));
  //     pages.add(const MaterialPage(child: StartPage()));
  //     break;
  //   case '/restore':
  //     pages.add(const MaterialPage(child: StartPage()));
  //     pages.add(const MaterialPage(child: RestorePage()));
  //     break;
  // }

  return pages;
}
