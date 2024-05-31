// ignore_for_file: prefer_const_constructors

import 'package:db_practice/Widgets/MyButton.dart';
import 'package:db_practice/Widgets/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  //

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final databasseref = FirebaseDatabase.instance.ref('Post');
  final auth = FirebaseAuth.instance;
  final postController = TextEditingController();

  //

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
                  maxLines: 4,
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
                onTap: () {
                  setState(() {
                    isLoading = true;
                  });
                  String id = DateTime.now().microsecondsSinceEpoch.toString();
                  databasseref.child(id).set({
                    'uid': '${auth.currentUser!.uid.toString()}',
                    'id': id,
                    'email': '${auth.currentUser!.email.toString()}',
                    'title': postController.text.toString(),
                  }).then((value) {
                    setState(() {
                      isLoading = false;
                    });
                    Utils().toastMessage('Post Added');
                  }).onError((error, stackTrace) {
                    print(error.toString());
                    setState(() {
                      isLoading = false;
                    });
                    Utils().toastMessage(error.toString());
                  });

                  if (_formKey.currentState!.validate()) {}
                })
          ],
        ),
      ),
    );
  }
}
