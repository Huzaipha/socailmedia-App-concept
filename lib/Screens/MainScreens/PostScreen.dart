// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:db_practice/Widgets/MyButton.dart';
import 'package:db_practice/Widgets/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  //

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool loading = false;
  final databasseref = FirebaseDatabase.instance.ref('Post');
  final databseRef = FirebaseDatabase.instance.ref('Images');
  final auth = FirebaseAuth.instance;
  final authRef = FirebaseAuth.instance.currentUser!;
  final postController = TextEditingController();
  File? _image;
  final picker = ImagePicker();

  //

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
        title: Text('Post Screen'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          getGalleryImage();
                        },
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.purple),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: _image != null
                                ? Image.file(
                                    _image!.absolute,
                                  )
                                : Icon(Icons.upload, size: 100),
                          ),
                        ),
                      ),
                      // MyButton(
                      //   loading: loading,
                      //   text: 'Upload',
                      //   onTap: () async {
                      //     setState(() {
                      //       loading = true;
                      //     });
                      //     firebase_storage.Reference ref = firebase_storage
                      //         .FirebaseStorage.instance
                      //         .ref('/Huzaifa/' +
                      //             '${authRef.uid}__${authRef.email}__${DateTime.now().microsecondsSinceEpoch}');
                      //     firebase_storage.UploadTask uploadTask =
                      //         ref.putFile(_image!.absolute);
                      //     Future.value(uploadTask).then((value) async {
                      //       var newUrl = await ref.getDownloadURL();

                      //       String id = DateTime.now()
                      //           .microsecondsSinceEpoch
                      //           .toString();

                      //       databseRef
                      //           .child('${id}_Image_UID_${authRef.uid}')
                      //           .set({
                      //         'id': id,
                      //         'uid': '${authRef.uid}',
                      //         'email': '${authRef.email}',
                      //         'title': newUrl.toString(),
                      //       }).then((value) {
                      //         setState(() {
                      //           loading = false;
                      //         });
                      //       }).onError((error, stackTrace) {
                      //         Utils().toastMessage(error.toString());
                      //       });
                      //       Utils().toastMessage('Uploaded');
                      //       setState(() {
                      //         loading = false;
                      //       });
                      //     });
                      //   },
                      // )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.purple),
                  borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: postController,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: "How was the day!"),
                  maxLines: 2,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please write about the Post!';
                    } else
                      return null;
                  },
                ),
              ),
            ),
            MyButton(
              loading: isLoading,
              text: 'Add Post',
              onTap: () async {
                setState(() {
                  isLoading = true;
                });
                firebase_storage.Reference ref =
                    firebase_storage.FirebaseStorage.instance.ref('/Huzaifa/' +
                        '${authRef.uid}__${authRef.email}__${DateTime.now().microsecondsSinceEpoch}');
                firebase_storage.UploadTask uploadTask =
                    ref.putFile(_image!.absolute);
                Future.value(uploadTask).then((value) async {
                  var newUrl = await ref.getDownloadURL();

                  String id = DateTime.now().microsecondsSinceEpoch.toString();

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

                  setState(() {
                    loading = false;
                  });
                });

                try {
                  firebase_storage.Reference ref = firebase_storage
                      .FirebaseStorage.instance
                      .ref('/Huzaifa/' +
                          '${authRef.uid}__${authRef.email}__${DateTime.now().microsecondsSinceEpoch}');

                  firebase_storage.UploadTask uploadTask =
                      ref.putFile(_image!.absolute);

                  await uploadTask;
                  var newUrl = await ref.getDownloadURL();

                  String id = DateTime.now().microsecondsSinceEpoch.toString();

                  await databasseref.child(id).set({
                    'uid': auth.currentUser!.uid.toString(),
                    'id': id,
                    'image': newUrl.toString(),
                    'email': auth.currentUser!.email.toString(),
                    'title': postController.text.toString(),
                  });

                  setState(() {
                    isLoading = false;
                  });

                  Utils().toastMessage('Post Added');
                } catch (error) {
                  print(error.toString());
                  setState(() {
                    isLoading = false;
                  });
                  Utils().toastMessage(error.toString());
                }

                if (_formKey.currentState!.validate()) {
                  // Form is valid, do further actions if needed
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
