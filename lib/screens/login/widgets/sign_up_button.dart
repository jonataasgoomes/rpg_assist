import 'package:flutter/material.dart';

import '../register_screen.dart';

class SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 62),
          child:  Row(
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                     MaterialPageRoute(builder: (context)=> RegisterScreen()));
                  },
                  child: Text(
                    "Start here.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: 12,
                        letterSpacing: 0.5),
                  ),
                ),
                FlatButton(
                  onPressed: () {},
                  child: Text(
                    "Forgot your password?",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: Colors.white, fontSize: 10, letterSpacing: 0.4),
                  ),
                ),
              ],
            ),
        );
  }
}
