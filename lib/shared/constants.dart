import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  //hintText: 'Password',
  fillColor: Colors.white,
  filled: true,
  //icon: Icon(Icons.key),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.green, width: 2.0),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromARGB(248, 180, 8, 8), width: 2.0),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromARGB(248, 180, 8, 8), width: 2.0),
  ),
);