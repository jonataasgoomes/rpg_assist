import 'package:flutter/material.dart';
import 'package:rpg_assist_app/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

import '../register_screen.dart';

class SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 60),
          child:  ScopedModelDescendant<UserModel>(
            builder: (context,child,model){
              if(model.isLoading)
                return Container();
              return Row(
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).push(
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
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: Colors.white, fontSize: 10, letterSpacing: 0.4),
                    ),
                  ),
                ],
              );
            },
          )
        );
  }
}
