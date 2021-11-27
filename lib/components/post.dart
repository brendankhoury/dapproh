import 'dart:async';
import 'dart:typed_data';

import 'package:dapproh/models/post.dart';
import 'package:dapproh/schemas/config_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PostWidget extends StatefulWidget {
  final Post post;

  const PostWidget(this.post, {Key? key}) : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  // Image? imageWidget;
  // double? height;
  @override
  void initState() {
    super.initState();
    // ConfigBox.retrieveImage(widget.post.postLink, widget.post.postKey, widget.post.postIv).then((value) {
    //   setState(() {
    //     imageWidget = Image.memory(
    //       value,
    //       fit: BoxFit.cover,
    //     );
    //     height = imageWidget!.height;
    //     ConfigBox.cacheBox.put("height:${widget.post.postLink}", height);
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        // height: imageWidget != null ? imageWidget!.height : null,
        child: Row(children: [
          Container(
              child: CircleAvatar(
                child: widget.post.posterProfilePicture == null
                    ? null
                    : FutureBuilder(
                        future: ConfigBox.retrieveImage(widget.post.posterProfilePicture!, widget.post.posterProfilePictureKeyAndIv!.split(' ')[0],
                            widget.post.posterProfilePictureKeyAndIv!.split(' ')[1]),
                        builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            return CircleAvatar(
                              backgroundImage: Image.memory(snapshot.data!).image, //todo: implement the post avatar thingy
                            );
                          }
                          return Container();
                        },
                      ),
                backgroundColor: CupertinoColors.white,
                radius: 22,
              ),
              margin: const EdgeInsets.only(right: 5)),
          Text("${widget.post.posterName}", textScaleFactor: 1.5)
        ]),
        margin: const EdgeInsets.only(left: 10, bottom: 5),
      ),
      // imageWidget != null
      //     ? imageWidget!
      //     : Container(
      //         height: height,
      //       ),\
      FutureBuilder(
          future: ConfigBox.retrieveImage(widget.post.postLink, widget.post.postKey, widget.post.postIv),
          builder: (context, AsyncSnapshot<Uint8List> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Image tmpWidget = Image.memory(
                snapshot.data!,
                fit: BoxFit.contain,
              );
              if (ConfigBox.getImageHeight(widget.post.postLink) == null) {
                tmpWidget.image.resolve(const ImageConfiguration()).addListener(ImageStreamListener((ImageInfo info, bool _) {
                  // debugPrint("ImageInfo: ${info.image.height} ${info.scale} ${info.image.height * info.scale} ${tmpWidget.height}");
                  try {
                    double ratio = MediaQuery.of(context).size.width / info.image.width;
                    // debugPrint("${info.image.height * ratio}");
                    ConfigBox.cacheBox.put("height:${widget.post.postLink}", info.image.height * ratio);
                  } catch (e) {
                    debugPrint("Error calculating image widget height $e");
                  }
                }));
              }

              // debugPrint("WidgetHeight: ${tmpWidget.}");
              return tmpWidget;
            } else {
              return ValueListenableBuilder(
                  valueListenable: Hive.box("cache").listenable(),
                  builder: (context, box, _) {
                    // debugPrint("HEIGHT IS BAD: ${(ConfigBox.getImageHeight(widget.post.postLink) ?? 400)}");
                    return SizedBox(
                      height: 1.0 * (ConfigBox.getImageHeight(widget.post.postLink) ?? 400),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  });
            }
          }),
      // Image.memory(
      //   imageBytes!, //NetworkImage(post.postLink), //todo: implement the post avatar thingy
      //   fit: BoxFit.cover,
      // ),
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
