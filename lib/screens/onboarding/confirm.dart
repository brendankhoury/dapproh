import 'package:dapproh/controllers/navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmSignupPage extends StatelessWidget {
  const ConfirmSignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Confirmation"),
        ),
        body: Center(
          child: Container(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('I have backed up my mnemonic and understand that if the mnemonic gets lost I will loose access to the account.'
                  '\nIf someone else gains access to the mnemonic, they will have full access to the account.'),
              TextButton(
                  onPressed: () {
                    Provider.of<NavigationController>(context, listen: false).changeScreen('/home');
                    debugPrint("Still need to implement the confirmed portion of the hive box");
                  },
                  child: const Text("Confirm")),
              OutlinedButton(
                  onPressed: () {
                    Provider.of<NavigationController>(context, listen: false).changeScreen('/start/create');
                  },
                  child: const Text("Go Back"))
            ]),
            margin: const EdgeInsets.symmetric(horizontal: 20),
          ),
        ));
  }
}
