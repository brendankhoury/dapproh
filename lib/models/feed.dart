import 'package:dapproh/models/post.dart';
import 'dart:collection';

class Feed {
  List<Post> timelineOfPosts = [];
  Feed();
  void addPosts(List<Post> posts) {
    timelineOfPosts.insertAll(timelineOfPosts.length, posts);
    timelineOfPosts.sort((Post a, Post b) => a.datePosted.compareTo(b.datePosted));
  }
}
