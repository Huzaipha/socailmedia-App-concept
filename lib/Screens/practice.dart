// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

// class practice extends StatefulWidget {
//   const practice({super.key});

//   @override
//   State<practice> createState() => _practiceState();
// }

// class _practiceState extends State<practice> {
//   final databaseref = FirebaseDatabase.instance.ref('Practice');
//   final formController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Container(
//             decoration: BoxDecoration(border: Border.all()),
//             padding: EdgeInsets.all(9),
//             margin: EdgeInsets.symmetric(vertical: 100),
//             child: TextFormField(
//               maxLines: 4,
//               decoration: InputDecoration(border: InputBorder.none),
//               controller: formController,
//             ),
//           ),
//           ElevatedButton(
//               onPressed: () {
//                 databaseref
//                     .child('2')
//                     .set({'id': '${formController.text.toString()}'});
//               },
//               child: Text('Post Data')),
//           SizedBox(
//             height: 20,
//           ),
//           Expanded(
//             child: FirebaseAnimatedList(
//                 query: databaseref,
//                 itemBuilder: (context, snapshot, animation, index) {
//                   return ListTile(
//                     title: Text('${snapshot.child('id').value.toString()}'),
//                   );
//                 }),
//           )
//         ],
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class practice extends StatefulWidget {
  const practice({super.key});

  @override
  State<practice> createState() => _practiceState();
}

class _practiceState extends State<practice> {
  final posttcontroller = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.ref('Post');
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextFormField(
            controller: posttcontroller,
            maxLines: 4,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                databaseRef
                    .child('1')
                    .set({'anything': '${posttcontroller.text.toString()}'});
              },
              child: Text('Post')),
          Expanded(
            child: FirebaseAnimatedList(
                query: databaseRef,
                itemBuilder: (context, snapshot, animation, index) {
                  return ListTile(
                    title: Text('${snapshot.child('anything').value.toString()}'),
                  );
                }),
          )
        ],
      ),
    );
  }
}
