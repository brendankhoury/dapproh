import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dapproh/controllers/navigation.dart';
import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';
import 'package:image_picker/image_picker.dart';
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
  // Future<String> _resizePhoto(String filePath) async {
  //   Image
  //     ImageProperties properties =
  //         await FlutterNativeImage.getImageProperties(filePath);

  //     int width = properties.width;
  //     var offset = (properties.height - properties.width) / 2;

  //     File croppedFile = await FlutterNativeImage.cropImage(
  //         filePath, 0, offset.round(), width, width);

  //     return croppedFile.path;
  // }
  @override
  Widget build(BuildContext context) {
    var previewSize = MediaQuery.of(context).size.width;
    if (!initialized) {
      return const Scaffold(
        body: Text("Not yet initialized"),
      );
    }
    return Scaffold(
        body: Container(
            color: Theme.of(context).primaryColor,
            child: Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              // Expanded(child: Container()),
              // Container(
              //   child: CameraPreview(controller),
              //   width: previewSize,
              //   height: previewSize,
              // ),
              CameraPreview(controller),
              // Container(
              //   width: previewSize,
              //   height: previewSize,
              //   child: ClipRect(
              //     child: OverflowBox(
              //       alignment: Alignment.center,
              //       child: FittedBox(
              //         fit: BoxFit.fitWidth,
              //         child: Container(
              //           width: previewSize / controller.value.aspectRatio,
              //           height: previewSize,
              //           child: CameraPreview(controller), // this is my CameraPreview
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      child: TextButton(
                          onPressed: () {
                            NavigationController navigation = Provider.of<NavigationController>(context, listen: false);
                            navigation.changeScreen('/home');
                          },
                          child: const Text("Cancel")),
                      margin: const EdgeInsets.only(left: 15)),
                  InkWell(
                      onTap: () {
                        // controller.pausePreview();
                        controller.takePicture().then((imageFile) async {
                          NavigationController navigation = Provider.of<NavigationController>(context, listen: false);

                          navigation.setImagePath(imageFile.path);
                          navigation.changeScreen('/home/post_camera/post_confirm');
                        });
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: const [
                          Icon(Icons.circle, color: Colors.white38, size: 80),
                          Icon(Icons.circle, color: Colors.white, size: 65),
                        ],
                      )),
                  Container(
                    child: ElevatedButton(
                        onPressed: () async {
                          NavigationController navigation = Provider.of<NavigationController>(context, listen: false);
                          XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
                          if (image == null) {
                            return;
                          }
                          navigation.setImagePath(image.path);
                          navigation.changeScreen('/home/post_camera/post_confirm');
                          // throw UnimplementedError("Gallery not yet implemented");
                        },
                        child: const Icon(Icons.photo)),
                    margin: const EdgeInsets.only(right: 15),
                  )
                ],
              )
                  //   child: Center(
                  // child: InkWell(
                  //     onTap: () {
                  //       debugPrint("Take photo tapped");
                  //     },
                  //     child: Stack(
                  //       alignment: Alignment.center,
                  //       children: const [
                  //         Icon(Icons.circle, color: Colors.white38, size: 80),
                  //         Icon(Icons.circle, color: Colors.white, size: 65),
                  //       ],
                  //     )),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       debugPrint("Taking picture");
                  //       controller.pausePreview();
                  //       controller.takePicture().then((imageFile) async {
                  //         // ... I did not expect the following to get this long
                  //         // FileImage tmp = FileImage(File(imageFile.path));

                  //         // debugPrint("pre crop");
                  //         // ImageCrop.cropImage(
                  //         //         file: File(imageFile.path),
                  //         //         area: Rect.fromCenter(
                  //         //             center: Offset(tmp.image.width / 2, tmp.height / 2),
                  //         //             width: tmp.width.toDouble() - 1,
                  //         //             height: image.width.toDouble() - 1))
                  //         //     .then((croppedImage) {
                  //         //   debugPrint("post crop");
                  //         //   NavigationController navigation = Provider.of<NavigationController>(context, listen: false);
                  //         //   navigation.setImagePath(croppedImage.path);
                  //         //   navigation.changeScreen('/home/post_camera/post_confirm');
                  //         // });
                  //       });
                  //     },
                  //     child: const Icon(
                  //       Icons.camera,
                  //       size: 55,
                  //     ))
                  )
            ]))));
  }
}
