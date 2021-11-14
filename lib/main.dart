import 'dart:convert';
import 'dart:typed_data';

import 'package:dapproh/controllers/navigation.dart';
import 'package:dapproh/screens/onboarding/confirm.dart';
import 'package:dapproh/screens/onboarding/create.dart';
import 'package:dapproh/screens/onboarding/restore.dart';
import 'package:dapproh/screens/onboarding/start.dart';
import 'package:flutter/material.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:provider/provider.dart';

import 'secret.dart' as secret;

void main() {
  debugPrint("Starting app");

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
              Provider.of<NavigationController>(context, listen: false).changeScreen('/start');
            }
            return popStatus;
          },
        ));
  }
}

List<Page> getPages(context) {
  NavigationController navigation = Provider.of<NavigationController>(context);

  List<Page> pages = [];

  switch (navigation.screenName) {
    case '/start':
      pages.add(const MaterialPage(child: StartPage()));
      break;
    case '/create':
      pages.add(const MaterialPage(child: StartPage()));
      pages.add(const MaterialPage(child: CreatePage()));
      break;

    case '/confirm':
      pages.add(const MaterialPage(child: ConfirmSignupPage()));
      pages.add(const MaterialPage(child: StartPage()));
      break;
    case '/restore':
      pages.add(const MaterialPage(child: StartPage()));
      pages.add(const MaterialPage(child: RestorePage()));
      break;
  }

  return pages;
}
// void testSky() async {
//   debugPrint("Entering TestSky" + bip39.generateMnemonic(strength: 160).split(" ").length.toString());
//   const String testMnemonic = secret.TEST_MNEMONIC;
//   final SkynetClient skynetClient = SkynetClient();
// // skynetClient.registry.getEntry(user, datakey)
// //   // How I assume this works is that this is the user that can set data
//   // final newUser = SkynetUser.fromMySkySeedPhrase(bip39.generateMnemonic(strength: 160));
//   final SkynetUser privateUser = await SkynetUser.createFromSeedAsync(bip39.mnemonicToSeed(testMnemonic).sublist(0, 32));
//   // SkynetUser.fromSeedAsync();
//   await privateUser.init();
//   debugPrint("Userid: " + privateUser.id);
//   const String DATA_KEY = 'daproh';
//   bool response = await skynetClient.skydb.setFile(
//       privateUser,
//       DATA_KEY,
//       SkyFile(
//         content: Uint8List.fromList(utf8.encode('Data Test')),
//         filename: 'private.txt',
//         type: 'text/plain', // Content type (Other examples: application/json or image/png)
//       ));
//   debugPrint("File set?: $response");

//   final publicUser = SkynetUser.fromId(privateUser.id);

//   SkyFile retrievedFile = await skynetClient.skydb.getFile(publicUser, DATA_KEY);

//   debugPrint("File retrieval: ${retrievedFile.asString}");
//   response = await skynetClient.skydb.setFile(
//       publicUser,
//       DATA_KEY,
//       SkyFile(
//         content: Uint8List.fromList(utf8.encode('Data Test')),
//         filename: 'private.txt',
//         type: 'text/plain', // Content type (Other examples: application/json or image/png)
//       ));
//   debugPrint("Public User file set?: $response");
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   // int _counter = 0;
//   String mnemonic = "";
//   String retrievedData = "Nothing yet ¯\\_(ツ)_/¯";

//   TextEditingController dataController = TextEditingController();

//   void setMnemonic() async {
//     String newMnemonic = bip39.generateMnemonic();
//     setState(() {
//       mnemonic = newMnemonic;
//     });
//     debugPrint(newMnemonic);
//   }

//   // void _incrementCounter() {
//   //   setState(() {
//   //     _counter++;
//   //     setMnemonic();
//   //   });
//   // }

//   void sendData() {
//     debugPrint("Will eventually send: " + dataController.text);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             TextField(
//               controller: dataController,
//               // te
//             ),
//             OutlinedButton(onPressed: sendData, child: const Text("Set Data")),
//             Text(retrievedData),
//             OutlinedButton(onPressed: () => {debugPrint("Retrieval request")}, child: const Text("Retrieve Data"))
//           ],
//         ),
//       ),
//       // floatingActionButton: FloatingActionButton(
//       //   onPressed: setMnemonic,
//       //   tooltip: 'Increment',
//       //   child: const Icon(Icons.replay_outlined),
//       // ),
//     );
//   }
// }
