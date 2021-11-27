// ignore_for_file: prefer_const_constructors

import 'package:dapproh/components/post.dart';
import 'package:dapproh/controllers/user_data.dart';
import 'package:dapproh/models/feed.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

// Things to do:
// Pull from feed.
// Make request to all followers
//
class _FeedPageState extends State<FeedPage> {
  Feed feed = Feed();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserDataController controller = Provider.of<UserDataController>(context);
    feed = controller.feed;
    if (feed.timelineOfPosts.isEmpty) {
      return Scaffold(
        body: Center(child: Text("No posts found yet...")),
      );
    } else {
      return ListView.builder(
        itemBuilder: (context, index) {
          return PostWidget(feed.timelineOfPosts[index]);
        },
        itemCount: feed.timelineOfPosts.length,
        cacheExtent: 1000,
      );
    }
  }
}
