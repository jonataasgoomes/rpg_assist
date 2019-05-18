import 'package:flutter/material.dart';
import 'package:rpg_assist_app/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../home_screen.dart';
import 'input_field.dart';

class FormSignInContainer extends StatefulWidget {
  @override
  _FormSignInContainerState createState() => _FormSignInContainerState();
}

class _FormSignInContainerState extends State<FormSignInContainer> {
  final _formKey = GlobalKey<FormState>();



  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

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
                        controller: _emailController,
                        hint: "Email",
                        obscure: false,
                        validator: (text) {
                          if (text.isEmpty) return "invalid user";
                        },
                      ),
                      InputField(
                        controller: _passwordController,
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
                              model.signIn(email: _emailController.text,
                                  password: _passwordController.text,
                                  onSuccess: _onSuccess,
                                  onFail: _onFail);
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

  void _onSuccess() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  void _onFail() {

    Scaffold.of(context).showSnackBar(
        SnackBar(content: Text("failed to Sign In"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),)
    );


  }
}
