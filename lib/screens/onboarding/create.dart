import 'package:dapproh/components/mnemonic.dart';
import 'package:flutter/material.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Dapproh'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MnemonicDisplay(),
            OutlinedButton(
                onPressed: () {
                  debugPrint("Generate Mnemonic not implemented");
                },
                child: const Text("Regenerate Mnemonic")),
            TextButton(
                onPressed: () {
                  debugPrint("Continue not implemented");
                },
                child: const Text("Continue")),
          ],
        ),
      ),
    );
  }
}
