// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class practice extends StatefulWidget {
  const practice({super.key});

  @override
  State<practice> createState() => _practiceState();
}

class _practiceState extends State<practice> {
  final databaseRef = FirebaseDatabase.instance.ref("Practice");
  final pracController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 70,
          ),
          TextFormField(
            controller: pracController,
          ),
          ElevatedButton(
            onPressed: () {
              databaseRef
                  .child('1')
                  .set({'title': pracController.toString(), 'id': '1234'});
            },
            child: Text("Post The Data"),
          ),
          Expanded(
              child: FirebaseAnimatedList(
            query: databaseRef,
            itemBuilder: (context, snapshot, animation, index) {
              return ListTile(
                title: Text('${pracController.text.toString()}'),
              );
            },
          )),
        ],
      ),
    );
  }
}
