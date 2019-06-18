import 'package:flutter/material.dart';

import 'package:rpg_assist_app/screens/login/widgets/form_sign_in_container.dart';
import 'package:rpg_assist_app/screens/login/widgets/sign_in_button.dart';
import 'package:rpg_assist_app/screens/login/widgets/sign_up_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/background_min.png"),
                fit: BoxFit.cover)),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Image.asset(
                "images/logo1.png",
                height: 100,
              ),
              SignInButton(),
              SizedBox(
                height: 30.0,
              ),
              FormSignInContainer(),
              SignUpButton(),
              SizedBox(
                height: 50.0,
              ),
              Image.asset(
                "images/logo.png",
                height: 20,
              ),
              SizedBox(
                height: 50.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
