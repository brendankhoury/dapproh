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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: box
                            .get("mnemonic")
                            .split(" ")
                            .sublist(0, 6)
                            .map<Widget>((e) => Text(
                                  e,
                                ))
                            .toList(),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: box
                            .get("mnemonic")
                            .split(" ")
                            .sublist(6)
                            .map<Widget>((e) => Text(
                                  e,
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 20)));
        });
  }
}
