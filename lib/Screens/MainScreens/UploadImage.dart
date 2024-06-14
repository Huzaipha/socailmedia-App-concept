import 'dart:io';
import 'package:db_practice/Widgets/MyButton.dart';
import 'package:db_practice/Widgets/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  File? _image;
  final picker = ImagePicker();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final authRef = FirebaseAuth.instance.currentUser!;
  final databseRef = FirebaseDatabase.instance.ref('Images');

  bool loading = false;

  Future getGalleryImage() async {
    final pickFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 40);
    setState(() {
      if (pickFile != null) {
        _image = File(pickFile.path);
      } else {
        print('No Image is Picked');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    getGalleryImage();
                  },
                  child: Container(
                    height: 400,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: _image != null
                          ? Image.file(
                              _image!.absolute,
                            )
                          : Icon(Icons.upload, size: 200),
                    ),
                  ),
                ),
                MyButton(
                  loading: loading,
                  text: 'Upload',
                  onTap: () async {
                    setState(() {
                      loading = true;
                    });
                    firebase_storage.Reference ref = firebase_storage
                        .FirebaseStorage.instance
                        .ref('/Huzaifa/' +
                            '${authRef.uid}__${authRef.email}__${DateTime.now().microsecondsSinceEpoch}');
                    firebase_storage.UploadTask uploadTask =
                        ref.putFile(_image!.absolute);
                    Future.value(uploadTask).then((value) async {
                      var newUrl = await ref.getDownloadURL();

                      final id = DateTime.now().microsecondsSinceEpoch;

                      databseRef.child('${id}_Image_UID_${authRef.uid}').set({
                        'id': id,
                        'uid': '${authRef.uid}',
                        'email': '${authRef.email}',
                        'title': newUrl.toString(),
                      }).then((value) {
                        setState(() {
                          loading = false;
                        });
                      }).onError((error, stackTrace) {
                        Utils().toastMessage(error.toString());
                      });
                      Utils().toastMessage('Uploaded');
                      setState(() {
                        loading = false;
                      });
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
