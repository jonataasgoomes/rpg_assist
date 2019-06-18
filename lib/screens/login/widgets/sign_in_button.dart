import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rpg_assist_app/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../home_screen.dart';

class SignInButton extends StatefulWidget {
  @override
  _SignInButtonState createState() => _SignInButtonState();
}

class _SignInButtonState extends State<SignInButton> {
  @override
  Widget build(BuildContext context) {
    return Container(child: ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        if (model.isLoading)
          return Container(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 20),
                width: 80,
                height: 80,
                alignment: Alignment.center,
                child:
                    FlareActor("assets/Dice_Loading.flr", animation: "loading"),
              )
            ],
          ));
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Container(
              width: 250.0,
              child: RaisedButton(
                onPressed: () {
                  model.signInGoogle(
                      context: context, onFail: _onFail, onSuccess: _onSuccess);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Color.fromRGBO(221, 75, 57, 1.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.google,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      "Sign in with Google",
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 250.0,
              child: Align(
                alignment: Alignment.center,
                child: RaisedButton(
                  onPressed: () {
                    model.signOutGoogle();
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Color.fromRGBO(59, 89, 152, 1.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.facebook,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        "Sign in with Facebook",
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ));
  }

  void _onFail() {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("failed to Sign In"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }

  void _onSuccess() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
  }
}
