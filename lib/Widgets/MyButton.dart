// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  String text;
  void Function()? onTap;
  final bool loading;
  MyButton({
    required this.text,
    required this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        width: 200,
        height: 50,
        decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(),
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: loading
              ? CircularProgressIndicator()
              : Text(
                  text,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
        ),
      ),
    );
  }
}
