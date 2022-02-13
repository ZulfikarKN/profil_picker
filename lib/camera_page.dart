import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:test_pt_ekstramarks/ganti_poto_profi_pagel.dart';
import 'package:test_pt_ekstramarks/main.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController controller;
  XFile? photo;
  File? image;

  @override
  void initState() {
    getCamera();
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text('Camera'),
            ),
            body: Stack(
              children: [
                CameraPreview(controller),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.blue,
                    child: IconButton(
                      icon: Icon(Icons.camera),
                      onPressed: () async {
                        photo = await controller.takePicture();
                        setState(() {});
                        _cropImage();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GantiFotoProfil(
                                      photoPath: photo!.path,
                                    )));
                      },
                    ),
                  ),
                )
              ],
            )));
  }

  Future getCamera() async {
    cameras = await availableCameras();
  }

  Future<void> _cropImage() async {
    File? croppedImage = await ImageCropper.cropImage(
        sourcePath: photo!.path.toString(),
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Potong Gambar',
          toolbarColor: Colors.blue,
        ));
    if (croppedImage != null) {
      image = croppedImage;
      setState(() {});
    }
  }
}
