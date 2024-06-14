// ignore_for_file: prefer_const_constructors

import 'package:db_practice/Screens/Authenticate/SigninScreen.dart';
import 'package:db_practice/Screens/MainScreens/PostScreen.dart';
import 'package:db_practice/Widgets/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //

  FirebaseAuth auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Post');
  final imageRef = FirebaseDatabase.instance.ref('Images');
  final editcontroller = TextEditingController();

  //

  Future<void> _handleRefresh() async {
    return await Future.delayed(Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Column(
            children: [
              Text(
                "What new for",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple),
              ),
              Text(
                auth.currentUser!.email.toString(),
                style: TextStyle(fontSize: 8),
              )
            ],
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  auth.signOut().then((value) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignInPage()));
                  }).onError((error, stackTrace) {
                    Utils().toastMessage(error.toString());
                  });
                },
                icon: Icon(Icons.logout))
          ],
        ),
        body: LiquidPullToRefresh(
          onRefresh: () => _handleRefresh(),
          height: 150,
          color: Colors.purple,
          animSpeedFactor: 2,
          showChildOpacityTransition: false,
          child: Column(
            children: [
              Expanded(
                child: FirebaseAnimatedList(
                  defaultChild: Center(
                    child: Text(
                      'Your Friends forgot to POST',
                      style: TextStyle(
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  query: ref,
                  itemBuilder: (context, snapshot, animation, index) {
                    return ListTile(
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    snapshot.child('email').value.toString(),
                                    style: TextStyle(
                                        color: Colors.purple, fontSize: 8),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      if (snapshot.child('email').value ==
                                          auth.currentUser!.email.toString()) {
                                        showMyDialog(snapshot
                                            .child('id')
                                            .value
                                            .toString());
                                      } else {
                                        return Utils().toastMessage(
                                            'You cannot edit this post');
                                      }
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      size: 15,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      if (snapshot.child('email').value ==
                                          auth.currentUser!.email.toString()) {
                                        ref
                                            .child(snapshot
                                                .child('id')
                                                .value
                                                .toString())
                                            .remove();
                                        Utils().toastMessage(
                                            "Your Post is Deleted");
                                      } else {
                                        return Utils().toastMessage(
                                            "You can't delete someone else's post");
                                      }
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      size: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Center(
                            child: Container(
                              height: 400,
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(10)),
                              clipBehavior: Clip.hardEdge,
                              child: Image.network(
                                fit: BoxFit.cover,
                                snapshot.child('image').value.toString(),
                              ),
                            ),
                          ),
                          Text(snapshot.child('title').value.toString()),
                        ],
                      ),
                      subtitle: Text(
                        snapshot.child('email').value.toString(),
                        style: TextStyle(color: Colors.purple, fontSize: 8),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.purple,
          shape: CircleBorder(),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostScreen(),
                ));
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> showMyDialog(String id) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Edit Your Post!'),
            content: Container(
              padding: EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                  border: Border.all(), borderRadius: BorderRadius.circular(8)),
              child: TextField(
                controller: editcontroller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ref.child(id).update(
                      {'title': editcontroller.text.toString()}).then((value) {
                    Utils().toastMessage('Post Updated');
                  }).onError((error, stackTrace) {
                    Utils().toastMessage(error.toString());
                  });
                },
                child: Text('Edit'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
            ],
          );
        });
  }
}
