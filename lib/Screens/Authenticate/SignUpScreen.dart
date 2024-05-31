// ignore_for_file: prefer_const_constructors

import 'package:db_practice/Screens/Authenticate/SigninScreen.dart';
import 'package:db_practice/Screens/MainScreens/MyHomePage.dart';
import 'package:db_practice/Widgets/MyButton.dart';
import 'package:db_practice/Widgets/TextField.dart';
import 'package:db_practice/Widgets/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  //

  bool loading = false;
  final _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool isVisible = false;

  //

  Widget mainBody() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 25,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Icon(
              Icons.person,
              size: 150,
            ),
            SizedBox(
              height: 20,
            ),
            Form(
              key: _formkey,
              child: Column(
                children: [
                  MyTextField(
                      hintText: 'Email',
                      controller: emailController,
                      obsecureText: false,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Email';
                        } else {
                          return null;
                        }
                      },
                      prefixIcon: Icon(Icons.email),
                      keyboardType: TextInputType.text),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    height: 70,
                    child: Center(
                      child: TextFormField(
                        obscureText: !isVisible,
                        controller: passController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isVisible = !isVisible;
                                });
                              },
                              icon: isVisible == true
                                  ? Icon(Icons.remove_red_eye_outlined)
                                  : Icon(Icons.remove_red_eye),
                            ),
                            hintText: 'Password'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Password';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: [
                Expanded(child: Divider()),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignInPage(),
                          ));
                    },
                    child: Text(' Sign In ')),
                Expanded(child: Divider()),
              ],
            ),
            MyButton(
              loading: loading,
              text: 'Sign Up',
              onTap: () {
                setState(() {
                  loading = true;
                });
                if (_formkey.currentState!.validate()) {
                  _auth
                      .createUserWithEmailAndPassword(
                          email: emailController.text.toString(),
                          password: passController.text.toString())
                      .then((value) {
                    setState(() {
                      loading = false;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyHomePage(),
                        ));
                  }).onError((error, stackTrace) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage(error.toString());
                  });
                }
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign Up',
          style: TextStyle(fontSize: 12),
        ),
        centerTitle: true,
      ),
      body: mainBody(),
    );
  }
}
