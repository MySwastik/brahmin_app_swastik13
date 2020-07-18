import 'dart:io';
import 'package:brahminapp/services/database.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSelector extends StatefulWidget {
  ImageSelector({@required this.database, @required this.uid});
final uid;
  static var url;
  final DatabaseL database;

  @override
  _ImageSelectorState createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector> {
  bool _inProcess = false;
  File selectedFile;
  String file;

  getImage(ImageSource source) async {
    this.setState(() {
      _inProcess = true;
    });
    // ignore: invalid_use_of_visible_for_testing_member
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

  imageUpload(AsyncSnapshot<QuerySnapshot> snapshot, DatabaseL database) async {
    StorageReference reference =
        FirebaseStorage.instance.ref().child('Users/${widget.uid}/ProfilePic');
    StorageUploadTask uploadTask = reference.putFile(selectedFile);
    var downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    var url = downloadUrl.toString();
    database.setData(data: {'file': url});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: widget.database.getUserData,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.data.documents.isNotEmpty) {
            file = snapshot.data.documents[0].data['file'];
          }
          return Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.done),
                  onPressed: () {
                    var img = imageUpload(snapshot, widget.database);
                    print('Ye raha link:$img');
                    Navigator.of(context).pop(selectedFile);
                  },
                ),
              ],
            ),
            backgroundColor: Colors.grey[200],
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Card(
                  elevation: 5,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 40,
                      ),
                      CircularProfileAvatar(
                        '',
                        child: selectedFile == null
                            ? (file == null
                                ? Image.asset('images/placeholder.jpg')
                                : Image.network(
                                    file,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes
                                              : null,
                                        ),
                                      );
                                    },
                                  ))
                            : Image.file(selectedFile),
                        radius: 100,
                        borderColor: Colors.deepOrange,
                        elevation: 8,
                        borderWidth: 5,
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      Divider(
                        thickness: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.camera_alt),
                            iconSize: 35,
                            onPressed: () => getImage(ImageSource.camera),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          IconButton(
                            icon: Icon(Icons.photo),
                            iconSize: 35,
                            onPressed: () => getImage(ImageSource.gallery),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            iconSize: 35,
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
              ),
            ),
          );
        });
  }

  Future<String> uploadImage({
    @required File imageToUpload,
  }) async {
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('Users/ProfilePic');

    StorageUploadTask uploadTask = firebaseStorageRef.putFile(imageToUpload);

    StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;

    var downloadUrl = await storageSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }
}
