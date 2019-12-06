import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soundshare/pages/login.dart';
import 'package:soundshare/pages/register.dart';

enum _AuthType {SignIn, SignUp}

BuildContext authContext;

class AuthenticationPage extends StatefulWidget {
  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  _AuthType type = _AuthType.SignIn;

  @override
  Widget build(BuildContext context) {
    authContext = context;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        getPage(),
        GestureDetector(
          onTap: () {
            setState(() {
              if (type == _AuthType.SignIn) {
                type = _AuthType.SignUp;
              } else {
                type = _AuthType.SignIn;
              }
            });
          },
          child: Text(
            getText(),
            style: TextStyle(
                color: Colors.blueAccent,
                decoration: TextDecoration.underline,
            ),
          ),
        )
      ],
    );
  }

  Widget getPage() => type == _AuthType.SignIn ? LoginPage() : RegisterPage();

  String getText() => type == _AuthType.SignIn ? "Hast du noch kein Soundshare Konto? Erstelle hier eines!" : "Du hast bereits ein SoundShare Konto? Logge dich hier ein!";
}