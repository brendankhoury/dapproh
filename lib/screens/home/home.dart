import 'package:dapproh/controllers/user_data.dart';
import 'package:dapproh/screens/home/feed.dart';
import 'package:dapproh/screens/home/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import '../../schemas/config_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    debugPrint("_HomePageState.initState called");
    UserDataController userData = Provider.of<UserDataController>(context, listen: false);
    userData.initUser();
  }

  @override
  Widget build(BuildContext context) {
    PersistentTabController _controller = PersistentTabController(initialIndex: 0);
    return PersistentTabView(
      context,
      controller: _controller,
      backgroundColor: Theme.of(context).primaryColor,

      navBarStyle: NavBarStyle.style18,
      // navBarStyle: NavBarStyle.style14,
      // navBarStyle: NavBarStyle.style13,
      // navBarStyle: NavBarStyle.style9,
      screens: const [FeedPage(), Text("This should not be shown Lol"), ProfilePage()],
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
            onPressed: (pressedContext) async {
              String newMnemonic = await ConfigBox.regenerateMnemonic();
              debugPrint("Resetting Mnemonic $newMnemonic");
              // Provider.of<NavigationController>(context, listen: false).changeScreen('/home/post_camera');
            }),
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
