import 'package:flutter/material.dart';

import 'package:rpg_assist_app/screens/login/widgets/form_sign_in_container.dart';
import 'package:rpg_assist_app/screens/login/widgets/sign_in_button.dart';
import 'package:rpg_assist_app/screens/login/widgets/sign_up_button.dart';



class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                    "images/background_min.png"),
                fit: BoxFit.cover)
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                    padding: EdgeInsets.only(top: 50, bottom: 30),
                    child: Image.asset("images/logo1.png",
                        width: 100,
                        fit: BoxFit.fitWidth
                          ),
                    ),

                    SignInButton(),
                    FormSignInContainer(),
                    SizedBox(
                      height: 30.0,
                    ),
                    SignUpButton(),
                    SizedBox(
                      height: 50.0,
                    ),
                        Padding(
                    padding: EdgeInsets.only(bottom:10),
                    child: Image.asset("images/logo.png",
                    width: 80,
                    fit: BoxFit.fitWidth
                    ),
                    ),

                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
