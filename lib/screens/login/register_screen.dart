import 'package:flutter/material.dart';
import 'package:rpg_assist_app/screens/login/widgets/form_register_container.dart';
import 'package:rpg_assist_app/screens/login/widgets/sign_in_button.dart';



class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage (
            image: AssetImage("images/background_min.png"),
          fit: BoxFit.cover),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 50),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 50.0,
                      ),
                      SignInButton(),
                      SizedBox(
                        height: 20.0,
                      ),
                      FormRegisterContainer(),
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
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );

  }
}