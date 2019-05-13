import 'package:flutter/material.dart';
import 'package:rpg_assist_app/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

import 'input_field.dart';

class FormSignInContainer extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: ScopedModelDescendant<UserModel>(
            builder: (context, child, model) {
              if(model.isLoading)
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 75),
                    child:Center(
                      child: Text("Signing in",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.yellow
                        ),)
                    ),
                );
              return Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      InputField(
                        hint: "Username",
                        obscure: false,
                        validator: (text) {
                          if (text.isEmpty) return "invalid user";
                        },
                      ),
                      InputField(
                        hint: "Password",
                        obscure: true,
                        validator: (text) {
                          if (text.isEmpty || text.length < 6)
                            return "invalid password";
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        width: 250.0,
                        child: Align(
                          alignment: Alignment.center,
                          child: RaisedButton(
                            onPressed: () {
                              if (_formKey.currentState.validate()) {

                              }
                              model.signIn();
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            color: Color.fromRGBO(0, 226, 186, 1.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  "START",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
              );
            }

        )

    );
  }
}
