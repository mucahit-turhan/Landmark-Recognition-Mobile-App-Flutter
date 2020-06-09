import 'package:flutter/material.dart';
import 'package:landmarkrecognition/mix/baseAuth.dart';
import 'package:landmarkrecognition/screens/rootPage.dart';

void main() => runApp(LareCog());

class LareCog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RootPage(auth: new Auth(),),
    );
  }
}