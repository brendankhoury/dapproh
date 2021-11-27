import 'package:dapproh/controllers/navigation.dart';
import 'package:dapproh/controllers/user_data.dart';
import 'package:dapproh/models/skynet_schema.dart';
import 'package:dapproh/screens/home/feed.dart';
import 'package:dapproh/screens/home/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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
      screens: [
        FeedPage(),
        // Text("This should not be shown Lol"),
        Text("This should not be shown Lol"),
        // Text("This should not be shown Lol"),
        ProfilePage()
      ],
      items: [
        PersistentBottomNavBarItem(
          icon: const Icon(CupertinoIcons.home),
          title: ("Feed"),
          activeColorPrimary: CupertinoColors.white,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        // PersistentBottomNavBarItem(
        //     icon: const Icon(CupertinoIcons.refresh),
        //     title: ("Refresh"),
        //     activeColorPrimary: CupertinoColors.white,
        //     inactiveColorPrimary: CupertinoColors.systemGrey,
        //     onPressed: (pressedContext) async {
        //       debugPrint("refreshed pressed");
        //       UserDataController userData = Provider.of<UserDataController>(context, listen: false);
        //       userData.populateFeed(); // I think this should refresh :shrugging_man:
        //     }),
        PersistentBottomNavBarItem(
            icon: const Icon(CupertinoIcons.add),
            title: ("Post"),
            activeColorPrimary: CupertinoColors.white,
            inactiveColorPrimary: CupertinoColors.systemGrey,
            onPressed: (pressedContext) async {
              // debugPrint("Post called uploading to estuary");
              // String resultingCID = await ConfigBox.uploadToEstuary("Notdoneyet", "notdoneyet", "notdoneyet");
              // debugPrint("Resulting cid: $resultingCID");

              // debugPrint("Post Called");
              // PublicFeed feed = ConfigBox.getOwnedFeed();
              // feed.addPost(Post(DateTime.now(), "The first post made on dapproh", "https://avatars.githubusercontent.com/u/53023770?v=4",
              //     "no encryption yet", "no pub key yet", "satoshi"));
              // ConfigBox.setOwnedFeed(feed, setSkynet: true);

              Provider.of<NavigationController>(context, listen: false).changeScreen('/home/post_camera');
            }),
        // PersistentBottomNavBarItem(
        //     icon: const Icon(CupertinoIcons.delete),
        //     title: ("Reset"),
        //     activeColorPrimary: CupertinoColors.white,
        //     inactiveColorPrimary: CupertinoColors.systemGrey,
        //     onPressed: (pressedContext) async {
        //       debugPrint("resetting cache");
        //       Hive.box("cache").clear().then((value) => debugPrint("Cache reset"));

        //       // String newMnemonic = await ConfigBox.regenerateMnemonic();
        //       // debugPrint("Resetting Mnemonic $newMnemonic");
        //     }),
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
