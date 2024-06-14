import 'package:db_practice/Screens/Authenticate/SigninScreen.dart';
import 'package:db_practice/Screens/MainScreens/MyHomePage.dart';
import 'package:db_practice/Screens/MainScreens/UploadImage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final auth = FirebaseAuth.instance;

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      Timer(Duration(seconds: 2), () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MyHomePage(),
          ),
        );
      });
    } else {
      Timer(Duration(seconds: 2), () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SignInPage(),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlutterLogo(size: 100.0),
            SizedBox(height: 20),
            Text(
              'Welcome to MyApp!',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
