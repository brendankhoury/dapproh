import 'dart:io';

import 'package:dapproh/controllers/navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostConfirmationPage extends StatelessWidget {
  const PostConfirmationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NavigationController navigation = Provider.of<NavigationController>(context, listen: false);
    return Scaffold(
        body: Column(
      children: [
        Image.file(
          File(navigation.imagePath),
          width: MediaQuery.of(context).size.width,
        )
      ],
    ));
  }
}
