// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:ui';

import 'package:db_practice/Screens/Authenticate/SignUpScreen.dart';
import 'package:db_practice/Screens/MainScreens/MyHomePage.dart';
import 'package:db_practice/Widgets/MyButton.dart';
import 'package:db_practice/Widgets/TextField.dart';
import 'package:db_practice/Widgets/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formkey = GlobalKey<FormState>();
  final emailcontroller = TextEditingController();
  final passcontroller = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool isVisible = false;
  bool loading = false;
  void SignIn() {
    setState(() {
      loading = true;
    });
    _auth
        .signInWithEmailAndPassword(
            email: emailcontroller.text, password: passcontroller.text)
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

  Widget MainBody() {
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
            Form(
              key: _formkey,
              child: Column(
                children: [
                  MyTextField(
                    hintText: 'Email',
                    controller: emailcontroller,
                    obsecureText: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Email';
                      } else {
                        return null;
                      }
                    },
                    prefixIcon: Icon(Icons.email),
                    keyboardType: TextInputType.emailAddress,
                  ),
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
                        controller: passcontroller,
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
                Expanded(
                  child: Divider(),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpScreen(),
                          ));
                    },
                    child: Text(' Sign Up ')),
                Expanded(child: Divider()),
              ],
            ),
            MyButton(
              loading: loading,
              text: 'Sign In',
              onTap: () {
                SignIn();
                if (_formkey.currentState!.validate()) {}
              },
            )
          ],
        ),
      ),
    );
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
          title: Text(
            'Sign In',
            style: TextStyle(fontSize: 12),
          ),
          centerTitle: true,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Positioned(
                bottom: 20,
                right: 20,
                left: 20,
                child: Lottie.asset(
                  'assets/background/Test3.json',
                ),
              ),
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Lottie.asset(
                          'assets/background/background.json',
                        ),
                        MainBody(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
