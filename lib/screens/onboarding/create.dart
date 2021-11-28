import 'package:dapproh/components/mnemonic.dart';
import 'package:dapproh/controllers/navigation.dart';
import 'package:dapproh/schemas/config_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
            ElevatedButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: ConfigBox.getMnemonic()));
                },
                child: const Text("     Copy Mnemonic     ")),
            const OutlinedButton(onPressed: ConfigBox.regenerateMnemonic, child: Text("Regenerate Mnemonic")),
            TextButton(
                onPressed: () {
                  NavigationController navigation = Provider.of<NavigationController>(context, listen: false);
                  navigation.changeScreen("/start/create/confirm");
                },
                child: const Text("Continue")),
            Container(
                margin: const EdgeInsets.all(15),
                child: ValueListenableBuilder(
                  builder: (BuildContext _context, _value, Widget? _child) => Text(
                    "*Note, if you record the mnemonic in one line, record one column at a time. The order is \"${ConfigBox.getMnemonic().split(" ")[0]}\" to \"${ConfigBox.getMnemonic().split(" ")[5]}\" and then \"${ConfigBox.getMnemonic().split(" ")[6]}\" to \"${ConfigBox.getMnemonic().split(" ")[11]}\"",
                    textAlign: TextAlign.center,
                  ),
                  valueListenable: Hive.box("configuration").listenable(),
                ))
          ],
        ),
      ),
    );
  }
}
