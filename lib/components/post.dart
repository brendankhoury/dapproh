import 'dart:typed_data';

import 'package:dapproh/models/post.dart';
import 'package:dapproh/schemas/config_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostWidget extends StatefulWidget {
  final Post post;
  const PostWidget(this.post, {Key? key}) : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  Uint8List? imageBytes;
  Image? imageWidget;
  @override
  void initState() {
    super.initState();
    ConfigBox.retrieveImage(widget.post.postLink, widget.post.postKey, widget.post.postIv).then((value) => setState(() {
          imageWidget = Image.memory(value);
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        child: Row(children: [
          Container(
              child: const CircleAvatar(
                child: CircleAvatar(
                  backgroundImage: NetworkImage("https://picsum.photos/100"), //todo: implement the post avatar thingy
                ),
                backgroundColor: CupertinoColors.white,
                radius: 22,
              ),
              margin: const EdgeInsets.only(right: 5)),
          const Text("name not yet implemented", textScaleFactor: 1.5)
        ]),
        margin: const EdgeInsets.only(left: 10, bottom: 5),
      ),
      if (imageBytes != null)
        Image.memory(
          imageBytes!, //NetworkImage(post.postLink), //todo: implement the post avatar thingy
          fit: BoxFit.cover,
        ),
      Container(
        child: Text(widget.post.description),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      ),
      const Divider(
        color: CupertinoColors.white,
      )
    ]);
  }
}

// class PostWidget extends StatelessWidget {
//   final Post post;
//   const PostWidget(this.post, {Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       Container(
//         child: Row(children: [
//           Container(
//               child: const CircleAvatar(
//                 child: CircleAvatar(
//                   backgroundImage: NetworkImage("https://picsum.photos/100"), //todo: implement the post avatar thingy
//                 ),
//                 backgroundColor: CupertinoColors.white,
//                 radius: 22,
//               ),
//               margin: const EdgeInsets.only(right: 5)),
//           const Text("name not yet implemented", textScaleFactor: 1.5)
//         ]),
//         margin: const EdgeInsets.only(left: 10, bottom: 5),
//       ),
//       if (true)
//         Image.memory(
//           bytes, //NetworkImage(post.postLink), //todo: implement the post avatar thingy
//           fit: BoxFit.cover,
//         ),
//       Container(
//         child: Text(post.description),
//         margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       ),
//       const Divider(
//         color: CupertinoColors.white,
//       )
//     ]);
//   }
// }
