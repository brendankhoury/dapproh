import 'package:camera/camera.dart';
import 'package:dapproh/controllers/navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostCameraPage extends StatefulWidget {
  const PostCameraPage({Key? key}) : super(key: key);

  @override
  _PostCameraPageState createState() => _PostCameraPageState();
}

class _PostCameraPageState extends State<PostCameraPage> {
  late CameraController controller;
  bool initialized = false;
  List<CameraDescription> cameras = [];

  @override
  void initState() {
    super.initState();
    availableCameras().then((value) {
      cameras = value;
      debugPrint("Availible cameras ${value.toString()}");
      controller = CameraController(cameras[0], ResolutionPreset.max);
      controller.initialize().then((_) {
        debugPrint("Controller.initialize()");
        if (!mounted) {
          return;
        }
        setState(() {
          initialized = true;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var previewSize = MediaQuery.of(context).size.width;
    if (!initialized) {
      return Center(
        child: Text("Not yet initialized"),
      );
    }
    return MaterialApp(
        home: Container(
            color: Theme.of(context).primaryColor,
            child: Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(child: Container()),
              // Container(
              //   child: CameraPreview(controller),
              //   width: previewSize,
              //   height: previewSize,
              // ),
              Container(
                width: previewSize,
                height: previewSize,
                child: ClipRect(
                  child: OverflowBox(
                    alignment: Alignment.center,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Container(
                        width: previewSize / controller.value.aspectRatio,
                        height: previewSize,
                        child: CameraPreview(controller), // this is my CameraPreview
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: Center(
                      child: ElevatedButton(
                          onPressed: () {
                            debugPrint("Taking picture");
                            controller.pausePreview();
                            controller.takePicture().then((image) {
                              NavigationController navigation = Provider.of<NavigationController>(context, listen: false);
                              navigation.setImagePath(image.path);
                              navigation.changeScreen('/home/post_camera/post_confirm');
                            });
                          },
                          child: Icon(
                            Icons.camera,
                            size: 55,
                          )))),
            ]))));
  }
}
