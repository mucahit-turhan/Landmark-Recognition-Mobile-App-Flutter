import 'package:flutter/material.dart';

class Tools{

  static TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  static TextEditingController emailController = new TextEditingController();
  static TextEditingController passwordController = new TextEditingController();
  static String email = "GUEST";
  static bool isNotGuest;

  final emailField = TextField(
    controller: emailController,
    obscureText: false,
    style: style,
    decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Email",
        border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
  );

  final passwordField = TextField(
    controller: passwordController,
    obscureText: true,
    style: style,
    decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Password",
        border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
  );  

}