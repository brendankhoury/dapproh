import 'package:dapproh/controllers/navigation.dart';
import 'package:dapproh/schemas/config_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GettingThingsReady extends StatelessWidget {
  const GettingThingsReady({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConfigBox.setUsers().then((value) {
      if (value) {
        // navigate home
        debugPrint("setUsers");
        NavigationController controller = Provider.of<NavigationController>(context, listen: false);
        controller.changeScreen('/home');
      } else {
        throw UnimplementedError("Users not set");
      }
    });
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: const Text(
              "Generating new Dapproh account, should take a few seconds",
              textScaleFactor: 1.5,
              textAlign: TextAlign.center,
            ),
            margin: const EdgeInsets.all(15),
          ),
          Container(
            height: 30,
          ),
          const CircularProgressIndicator()
        ],
      ),
    );
  }
}
