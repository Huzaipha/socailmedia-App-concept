// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  String hintText;
  final controller;
  bool obsecureText;
  String? Function(String?) validator;
  final Icon prefixIcon;
  TextInputType? keyboardType;

  MyTextField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.obsecureText,
    required this.validator,
    required this.prefixIcon,
    required this.keyboardType,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(), borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 70,
      child: Center(
        child: TextFormField(
          keyboardType: widget.keyboardType,
          obscureText: widget.obsecureText,
          controller: widget.controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: widget.prefixIcon,
            hintText: widget.hintText,
          ),
          validator: widget.validator,
        ),
      ),
    );
  }
}
