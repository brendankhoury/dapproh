import 'dart:io';

import 'package:dapproh/controllers/navigation.dart';
import 'package:dapproh/schemas/config_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostConfirmationPage extends StatelessWidget {
  final TextEditingController descriptionController = TextEditingController();
  PostConfirmationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NavigationController navigation = Provider.of<NavigationController>(context, listen: false);
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Image.file(
                  File(navigation.imagePath),
                  width: MediaQuery.of(context).size.width,
                ),
                TextField(
                    controller: descriptionController,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      hintText: "Description",
                      // focusColor: Color.fromARGB(60, 255, 0, 0),
                    )),
              ],
            ),
            Container(
              child: SizedBox(
                  child: ElevatedButton(
                      onPressed: () {
                        navigation.setPostDescription(descriptionController.text);
                        debugPrint("ImagePath: ${navigation.imagePath} and description: ${descriptionController.text}");
                        navigation.changeScreen('/home/post_camera/post_confirm/uploading');
                        // ConfigBox.postImage(navigation.imagePath, descriptionController.text);
                      },
                      child: const Icon(Icons.upload)),
                  width: double.infinity),
              margin: const EdgeInsets.only(left: 15, right: 15, top: 40),
            ),
            Container(
              child: SizedBox(
                  child: TextButton(
                      onPressed: () {
                        NavigationController navigation = Provider.of<NavigationController>(context, listen: false);
                        navigation.changeScreen('/home/post_camera');
                      },
                      child: const Text(
                        "Cancel",
                      )),
                  width: double.infinity),
              margin: const EdgeInsets.only(left: 15, right: 15, top: 0),
            ),
          ],
        )));
  }
}
