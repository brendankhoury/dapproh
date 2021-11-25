import 'package:dapproh/components/mnemonic.dart';
import 'package:dapproh/controllers/navigation.dart';
import 'package:dapproh/schemas/config_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  @override
  Widget build(BuildContext context) {
    if (ConfigBox.getMnemonic() == '') {
      ConfigBox.regenerateMnemonic();
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
            const OutlinedButton(onPressed: ConfigBox.regenerateMnemonic, child: Text("Regenerate Mnemonic")),
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
