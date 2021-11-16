// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            child: Row(children: [
              Container(
                  child: CircleAvatar(
                    child: CircleAvatar(
                      backgroundImage: NetworkImage("https://picsum.photos/100"),
                    ),
                    backgroundColor: CupertinoColors.white,
                    radius: 23,
                  ),
                  margin: EdgeInsets.only(right: 5)),
              Text("Poster Name", textScaleFactor: 1.5)
            ]),
            margin: EdgeInsets.only(left: 10, bottom: 5),
          ),
          // Container(
          //   height: 5,
          // ),
          Image(
            image: NetworkImage("https://picsum.photos/500"),
            fit: BoxFit.cover,
          ),
          Container(
            child: Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum"),
            margin: EdgeInsets.only(left: 10, top: 5, bottom: 5),
          ),
          Divider(
            color: CupertinoColors.white,
          )
        ]);
      },
      itemCount: 5,
    );
  }
}
