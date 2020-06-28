import 'dart:io';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

File selectedFile;
bool _inProcess = false;

class ImageFile {
  File get() {
    return selectedFile;
  }
}

class ImagePickerHandmade extends StatefulWidget {
  @override
  _ImagePickerHandmadeState createState() => _ImagePickerHandmadeState();
}

class _ImagePickerHandmadeState extends State<ImagePickerHandmade> {
  getImage(ImageSource source) async {
    this.setState(() {
      _inProcess = true;
    });
    //File image = await await picker.getImage(source: ImageSource.camera);
    PickedFile image = await ImagePicker.platform.pickImage(source: source);
    if (image != null) {
      File cropped = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        maxWidth: 700,
        maxHeight: 700,
        compressFormat: ImageCompressFormat.jpg,
      );

      this.setState(() {
        selectedFile = cropped;
        _inProcess = false;
      });
    } else {
      this.setState(() {
        _inProcess = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.grey[200],
      body: Column(
        children: <Widget>[
          Card(
            child: Column(
              children: <Widget>[
                CircularProfileAvatar(
                  '',
                  child: selectedFile != null
                      ? Image.file(selectedFile)
                      : Image.asset("images/placeholder.jpg"),
                  borderColor: Colors.indigo,
                  borderWidth: 5,
                  elevation: 5,
                  radius: 100,
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  'Select any',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black54,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.camera_alt),
                      iconSize: 30,
                      onPressed: () => getImage(ImageSource.camera),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    IconButton(
                      icon: Icon(Icons.photo),
                      iconSize: 30,
                      onPressed: () => getImage(ImageSource.gallery),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      iconSize: 30,
                      onPressed: () {
                        setState(() {
                          selectedFile = null;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
