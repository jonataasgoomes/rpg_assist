import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rpg_assist_app/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../home_screen.dart';
import 'input_field.dart';

class FormRegisterContainer extends StatefulWidget {
  @override
  _FormRegisterContainerState createState() => _FormRegisterContainerState();
}

class _FormRegisterContainerState extends State<FormRegisterContainer> {
  static final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _sexController = TextEditingController();

  String _value = DateFormat.Md().format(DateTime.now());
  DateTime _dateTime;

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(3000));
    if (picked != null) {
      setState(() {
        _dateTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: Color.fromRGBO(226, 226, 225, 1.0),
          borderRadius: BorderRadius.circular(5)),
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if (model.isLoading) {
            return Container(
              width: 250,
              child: Column(
                children: <Widget>[
                  Text(
                    "SIGNING UP",
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 50, bottom: 30),
                    child: Image.asset("images/logo1.png",
                        width: 100, fit: BoxFit.fitWidth),
                  ),
                ],
              ),
            );
          }
          return Column(
            children: <Widget>[
              Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      InputField(
                        controller: _emailController,
                        hint: "E-mail",
                        obscure: false,
                        color: Colors.black,
                        inputType: TextInputType.emailAddress,
                        validator: (text) {
                          if (text.isEmpty || !text.contains("@"))
                            return "invalid email";
                        },
                      ),
                      InputField(
                        controller: _passwordController,
                        hint: "Password",
                        obscure: true,
                        color: Colors.black,
                        validator: (text) {
                          if (text.isEmpty || text.length < 6)
                            return "password must be more than 6 digits";
                        },
                      ),
                      InputField(
                        controller: _usernameController,
                        hint: "Username",
                        obscure: false,
                        color: Colors.black,
                        validator: (text) {
                          if (text.isEmpty) return "required";
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10,left: 25,right: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Birthday"),
                            Container(
                              child: RaisedButton(
                                onPressed: () {
                                  _selectDate();
                                },
                                color: Color.fromRGBO(0, 226, 186, 1.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      _dateTime != null
                                          ? DateFormat.Md().format(_dateTime)
                                          : _value,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      InputField(
                        controller: _sexController,
                        hint: "Sex",
                        obscure: false,
                        color: Colors.black,
                        validator: (text) {
                          if (text.isEmpty) return "required";
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                    ],
                  )),
              SizedBox(
                height: 80.0,
                child: Container(
                  width: 250.0,
                  child: Align(
                    alignment: Alignment.center,
                    child: RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          Map<String, dynamic> userData = {
                            "email": _emailController.text,
                            "name": _usernameController.text,
                            "birthday": _dateTime != null? _dateTime: _value,
                            "Sex": _sexController.text
                          };

                          model.signUp(
                              userData: userData,
                              password: _passwordController.text,
                              onSucess: _onSuccess,
                              onFail: _onFail);
                        }
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
                            "CREATE AN ACCOUNT",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _onSuccess() {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("your account has been successfully created!"),
      duration: Duration(seconds: 5),
    ));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  void _onFail() {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("failed to create user"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }
}
