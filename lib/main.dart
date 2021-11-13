import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:skynet/skynet.dart';

import 'secret.dart' as secret;

void main() {
  debugPrint("Starting app");

  testSky();

  runApp(const MyApp());
}

void testSky() async {
  debugPrint("Entering TestSky" + bip39.generateMnemonic(strength: 160).split(" ").length.toString());
  const String testMnemonic = secret.TEST_MNEMONIC;
  final SkynetClient skynetClient = SkynetClient();
// skynetClient.registry.getEntry(user, datakey)
//   // How I assume this works is that this is the user that can set data
  // final newUser = SkynetUser.fromMySkySeedPhrase(bip39.generateMnemonic(strength: 160));
  final SkynetUser privateUser = await SkynetUser.createFromSeedAsync(bip39.mnemonicToSeed(testMnemonic).sublist(0, 32));
  // SkynetUser.fromSeedAsync();
  await privateUser.init();
  debugPrint("Userid: " + privateUser.id);
  const String DATA_KEY = 'daproh';
  bool response = await skynetClient.skydb.setFile(
      privateUser,
      DATA_KEY,
      SkyFile(
        content: Uint8List.fromList(utf8.encode('Data Test')),
        filename: 'private.txt',
        type: 'text/plain', // Content type (Other examples: application/json or image/png)
      ));
  debugPrint("File set?: $response");

  final publicUser = SkynetUser.fromId(privateUser.id);

  SkyFile retrievedFile = await skynetClient.skydb.getFile(publicUser, DATA_KEY);

  debugPrint("File retrieval: ${retrievedFile.asString}");
  response = await skynetClient.skydb.setFile(
      publicUser,
      DATA_KEY,
      SkyFile(
        content: Uint8List.fromList(utf8.encode('Data Test')),
        filename: 'private.txt',
        type: 'text/plain', // Content type (Other examples: application/json or image/png)
      ));
  debugPrint("Public User file set?: $response");
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // int _counter = 0;
  String mnemonic = "";
  String retrievedData = "Nothing yet ¯\\_(ツ)_/¯";

  TextEditingController dataController = TextEditingController();

  void setMnemonic() async {
    String newMnemonic = bip39.generateMnemonic();
    setState(() {
      mnemonic = newMnemonic;
    });
    debugPrint(newMnemonic);
  }

  // void _incrementCounter() {
  //   setState(() {
  //     _counter++;
  //     setMnemonic();
  //   });
  // }

  void sendData() {
    debugPrint("Will eventually send: " + dataController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: dataController,
              // te
            ),
            OutlinedButton(onPressed: sendData, child: const Text("Set Data")),
            Text(retrievedData),
            OutlinedButton(onPressed: () => {debugPrint("Retrieval request")}, child: const Text("Retrieve Data"))
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: setMnemonic,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.replay_outlined),
      // ),
    );
  }
}
