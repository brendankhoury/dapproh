import 'package:dapproh/secret.dart';
import 'package:flutter/material.dart';

class MnemonicDisplay extends StatelessWidget {
  const MnemonicDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: TEST_MNEMONIC
              .split(" ")
              .sublist(0, 6)
              .map((e) => Text(
                    e,
                  ))
              .toList(),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: TEST_MNEMONIC
              .split(" ")
              .sublist(6)
              .map((e) => Text(
                    e,
                  ))
              .toList(),
        ),
      ],
    ));
  }
}
