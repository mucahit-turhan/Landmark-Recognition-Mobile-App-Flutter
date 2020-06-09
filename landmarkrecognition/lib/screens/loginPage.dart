import 'package:flutter/material.dart';
import 'package:landmarkrecognition/mix/baseAuth.dart';
import 'package:landmarkrecognition/mix/tools.dart';
import 'package:landmarkrecognition/screens/imageSelectionPage.dart';
import 'package:landmarkrecognition/screens/signupPage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginP extends StatefulWidget{
  LoginP({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() => _LoginPState();
}

class _LoginPState extends State<LoginP> with Tools{

  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _errorMessage;

  bool _isLoginForm;
  bool _isLoading;

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
      String userId = "";
      try {
        if (_isLoginForm) {
          userId = await widget.auth.signIn(_email, _password);
          print('Signed in: $userId');
          Tools.email = _email;
        } else {
          userId = await widget.auth.signUp(_email, _password);
          //widget.auth.sendEmailVerification();
          //_showVerifyEmailSentDialog();
          print('Signed up user: $userId');
        }
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null && _isLoginForm) {
          widget.loginCallback();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content:
              new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                toggleFormMode();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;
    super.initState();
  }

  void resetForm() {
    Tools.emailController.clear();
    Tools.passwordController.clear();
    //_formKey.currentState.reset();
    _errorMessage = "";
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  @override
  Widget build(BuildContext context) {

    final loginButton = Material(
    elevation: 5.0,
    borderRadius: BorderRadius.circular(30.0),
    color: Colors.blue,
    child: MaterialButton(
      minWidth: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      onPressed: () {
        goToImageSelection();
        Tools.isNotGuest = true;
      },
      child: Text(_isLoginForm ? 'Login' : 'Create account',
          textAlign: TextAlign.center,
          style: Tools.style.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold)),
    ),
  );

    final signUpButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.redAccent,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: (){
          toggleFormMode();
        },
        child: Text(
            _isLoginForm ? 'Create an account' : 'Have an account? Sign in',
            textAlign: TextAlign.center,
            style: Tools.style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final asAGuest = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.greenAccent,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: (){
          goToImageSelectionGuest();
          Tools.isNotGuest = false;
        },
        child: Text("As a Guest",
            textAlign: TextAlign.center,
            style: Tools.style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    Widget showErrorMessage() {
      if (_errorMessage.length > 0 && _errorMessage != null) {
        return new Text(
          _errorMessage,
          style: Tools.style.copyWith(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        );
      } else {
        return new Container(
          height: 0.0,
        );
      }
    }

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
                    padding: EdgeInsets.only(top: 34.0),
                  ),
                  SizedBox(
                    height: 235,
                    child :Image.asset(
                      'assets/images/flutter.png',
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
                    padding: EdgeInsets.only(top: 15),
                  ),
                  loginButton,
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                  ),
                  signUpButton,
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                  ),
                  asAGuest,
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                  ),
                  showErrorMessage(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void goToSignUp(){
    _isLoginForm = false;
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SignupP()),
    );
  }

  void goToImageSelectionGuest(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ImageSelectionP()),
    );
  }

  void goToImageSelection(){
    _email = Tools.emailController.text;
    Tools.email = _email;
    _password = Tools.passwordController.text;
    validateAndSubmit();
  }

}