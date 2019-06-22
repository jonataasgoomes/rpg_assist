import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rpg_assist_app/models/adventure_model.dart';
import 'package:rpg_assist_app/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';


class NewSessionScreen extends StatefulWidget {
  DocumentSnapshot adventureDoc;

  NewSessionScreen(this.adventureDoc);

  @override
  _NewSessionScreenState createState() => _NewSessionScreenState(adventureDoc);
}

class _NewSessionScreenState extends State<NewSessionScreen> {
  static final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final _sessionTitleControler = TextEditingController();
  final DocumentSnapshot adventureDoc;

  String _value = DateFormat.Md().format(DateTime.now());
  DateTime _dateTime;

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(3000)
    );
    if(picked != null){
      setState((){
        _dateTime = picked;
      });
    }
  }

  _NewSessionScreenState(this.adventureDoc);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context,child,userModel){
        return Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 34, 17, 51),
              title: Image.asset(
                "images/logo.png",
                height: 20,
              ),
              centerTitle: true,
              iconTheme: IconThemeData(color: Color.fromARGB(255, 234, 205, 125)),
            ),
            floatingActionButton: Container(
              width: 80.0,
              height: 80.0,
              child: FloatingActionButton(
                backgroundColor: Colors.transparent,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  child: Image.asset("images/new_session.png"),
                ),
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
            body: Container(
                color: Color.fromARGB(255, 20, 110, 111),
                child: ScopedModelDescendant<AdventureModel>(
                  builder: (context,child,model){
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5), color: Colors.white),
                      margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                      child: ListView(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 20,right: 20,top: 50),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Text(
                                  "Create Session",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 84, 166, 145),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Form(
                                  key: _formKey,
                                  child: Container(
                                    margin: EdgeInsets.only(left: 20, right: 20),
                                    child: TextFormField(
                                      controller: _sessionTitleControler,
                                      style: TextStyle(),
                                      decoration: InputDecoration(
                                          labelText: "Choose a name for Session",
                                          hintStyle: TextStyle(
                                            fontSize: 15,
                                          ),
                                          contentPadding: EdgeInsets.only(
                                              top: 30, right: 30, bottom: 10, left: 5)),
                                      validator: (text){
                                        if(text.isEmpty){
                                          return "enter the name of the Session";
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(top: 20),
                                      child: RaisedButton(
                                        onPressed: () {
                                          _selectDate();
                                        },
                                        color: Color.fromRGBO(0, 226, 186, 1.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              _dateTime != null? DateFormat.Md().format(_dateTime) : _value,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 1.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 20),
                                      child: RaisedButton(
                                        onPressed: () {
                                          if(_formKey.currentState.validate()){
                                            Map<String, dynamic> sessionData = {
                                              "title": _sessionTitleControler.text,
                                              "date" : _dateTime,
                                            };
                                            model.registerSession(
                                                sessionData: sessionData,
                                                onSuccess: (){},
                                                onFail: (){},
                                                adventureId: adventureDoc["adventureId"],);
                                            Navigator.of(context).pop();
                                          }

                                        },
                                        color: Color.fromRGBO(0, 226, 186, 1.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              "READY",
                                              style: TextStyle(
                                                color: Colors.white,
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
            )
        );
      },
    );
  }

  void _onSuccess() {}

  void _onFail() {}
}
