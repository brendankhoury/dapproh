import 'package:dapproh/controllers/navigation.dart';
import 'package:dapproh/schemas/config_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UploadingPage extends StatefulWidget {
  const UploadingPage({Key? key}) : super(key: key);

  @override
  _UploadingPageState createState() => _UploadingPageState();
}

class _UploadingPageState extends State<UploadingPage> {
  @override
  void initState() {
    super.initState();
    NavigationController navigation = Provider.of<NavigationController>(context, listen: false);

    ConfigBox.postImage(navigation.imagePath, navigation.postDescription).then((value) {
      if (value) {
        navigation.changeScreen('/home');
      } else {
        debugPrint("Error uploading image :(");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: LinearProgressIndicator(),
    ));
  }
}

// class UploadingPage extends Stat {
//   const UploadingPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: LinearProgressIndicator(),
//       ),
//     );
//   }
// }
