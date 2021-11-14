import 'package:dapproh/components/mnemonic.dart';
import 'package:dapproh/controllers/navigation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import 'package:bip39/bip39.dart' as bip39;

class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  void regenerateMnemonic() {
    Hive.box("mnemonic").put("mnemonic", bip39.generateMnemonic());
  }

  @override
  Widget build(BuildContext context) {
    if (Hive.box("mnemonic").get("mnemonic") == null) {
      regenerateMnemonic();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const MnemonicDisplay(),
            OutlinedButton(onPressed: regenerateMnemonic, child: const Text("Regenerate Mnemonic")),
            TextButton(
                onPressed: () {
                  NavigationController navigation = Provider.of<NavigationController>(context, listen: false);
                  navigation.changeScreen("/start/create/confirm");
                },
                child: const Text("Continue")),
          ],
        ),
      ),
    );
  }
}
