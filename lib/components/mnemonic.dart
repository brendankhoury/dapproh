import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MnemonicDisplay extends StatelessWidget {
  const MnemonicDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box("configuration").listenable(),
        builder: (context, Box box, widget) {
          return Center(
              child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: box
                            .get("mnemonic")
                            .split(" ")
                            .sublist(0, 6)
                            .map<Widget>((
                              e,
                            ) =>
                                Text(
                                  e,
                                  textAlign: TextAlign.center,
                                  textScaleFactor: 1.3,
                                ))
                            .toList(),
                      )),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: box
                            .get("mnemonic")
                            .split(" ")
                            .sublist(6)
                            .map<Widget>((e) => Text(
                                  e,
                                  textAlign: TextAlign.center,
                                  textScaleFactor: 1.3,
                                ))
                            .toList(),
                      )),
                    ],
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 20)));
        });
  }
}
