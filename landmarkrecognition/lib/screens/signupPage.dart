import 'package:flutter/material.dart';
import 'package:landmarkrecognition/mix/baseAuth.dart';
import 'package:landmarkrecognition/mix/tools.dart';

class SignupP extends StatefulWidget{
  SignupP({this.auth, this.loginCallback, this.validateAndSubmit});
  final BaseAuth auth;
  final VoidCallback loginCallback;
  final VoidCallback validateAndSubmit;

  @override
  State<StatefulWidget> createState() => _SignupPState();
}

class _SignupPState extends State<SignupP> with Tools{
  @override
  Widget build(BuildContext context) {

    final signUpButton = Material(
    elevation: 5.0,
    borderRadius: BorderRadius.circular(30.0),
    color: Colors.redAccent,
    child: MaterialButton(
      minWidth: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      onPressed: () {
        pressSignUp();
      },
      child: Text("Sign-Up",
          textAlign: TextAlign.center,
          style: Tools.style.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold)),
    ),
  );

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 61.0),
                  ),
                  SizedBox(
                    height: 261,
                    child :Image.asset(
                      'assets/images/account.png',
                      fit: BoxFit.contain,),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                  ),
                  emailField,
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                  ),
                  passwordField,
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                  ),
                  signUpButton,
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void pressSignUp(){
    Navigator.pop(context);
  }

  bool checkEmail(String email){
    return true;
  }
  
}