import 'package:dapproh/components/mnemonic.dart';
import 'package:dapproh/controllers/navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to Dapproh'),
        ),
        body: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Welcome to Dapproh, please select one of the following to get started.",
                  textAlign: TextAlign.center,
                ),
                OutlinedButton(
                  onPressed: () {
                    Provider.of<NavigationController>(context, listen: false).changeScreen('/start/create');
                  },
                  child: const Text("Create Account"),
                ),
                TextButton(
                    onPressed: () {
                      debugPrint("Restore not implemented");
                    },
                    child: const Text("Restore Account")),
              ],
            ),
          ),
        ));
  }
}
