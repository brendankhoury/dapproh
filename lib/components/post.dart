import 'package:dapproh/models/post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostWidget extends StatelessWidget {
  final Post post;
  const PostWidget(this.post, {Key? key}) : super(key: key);

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
          Text(post.posterName, textScaleFactor: 1.5)
        ]),
        margin: const EdgeInsets.only(left: 10, bottom: 5),
      ),
      Image(
        image: NetworkImage(post.postLink), //todo: implement the post avatar thingy
        fit: BoxFit.cover,
      ),
      Container(
        child: Text(post.description),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      ),
      const Divider(
        color: CupertinoColors.white,
      )
    ]);
  }
}
