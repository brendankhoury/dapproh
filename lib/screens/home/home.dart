import 'package:dapproh/screens/home/feed.dart';
import 'package:dapproh/screens/home/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PersistentTabController _controller = PersistentTabController(initialIndex: 0);
    return PersistentTabView(
      context,
      controller: _controller,
      backgroundColor: Theme.of(context).primaryColor,
      // navBarStyle: NavBarStyle.style2,
      screens: const [FeedPage(), ProfilePage(), ProfilePage()],
      items: [
        PersistentBottomNavBarItem(
          icon: const Icon(CupertinoIcons.home),
          title: ("Feed"),
          activeColorPrimary: CupertinoColors.white,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(CupertinoIcons.add),
          title: ("Post"),
          activeColorPrimary: CupertinoColors.white,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(CupertinoIcons.person),
          title: ("Profile"),
          activeColorPrimary: CupertinoColors.white,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
      ],
    );
  }
}
