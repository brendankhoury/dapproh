import 'dart:typed_data';

import 'package:dapproh/models/post.dart';
import 'package:dapproh/schemas/config_box.dart';
import 'package:flutter/material.dart';

class RemoteImage extends StatefulWidget {
  final Post post;
  const RemoteImage(this.post, {Key? key}) : super(key: key);

  @override
  _RemoteImageState createState() => _RemoteImageState();
}

class _RemoteImageState extends State<RemoteImage> {
  Uint8List? imageBytes;

  @override
  void initState() {
    super.initState();
    ConfigBox.retrieveImage(widget.post.postLink, widget.post.postKey, widget.post.postIv).then((value) => setState(() {
          imageBytes = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    if (imageBytes == null) {
      return Center(
        child: Text("Loading and decrypting image"),
      );
    } else {
      return Image.memory(imageBytes!);
    }
  }
}
