// ignore_for_file: unused_import

import 'package:db_practice/Screens/Authenticate/SignUpScreen.dart';
import 'package:db_practice/Screens/Authenticate/SpashScreen.dart';
import 'package:db_practice/Screens/MainScreens/MyHomePage.dart';
import 'package:db_practice/Screens/Authenticate/SigninScreen.dart';
import 'package:db_practice/Screens/practice.dart';

import 'package:db_practice/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}
