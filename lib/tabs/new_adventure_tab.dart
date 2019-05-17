import 'package:flutter/material.dart';
import 'package:rpg_assist_app/screens/login/widgets/input_field.dart';
import 'package:rpg_assist_app/widgets/custom_drawer.dart';

class NewAdventureTab extends StatefulWidget {
  @override
  _NewAdventureTabState createState() => _NewAdventureTabState();
}

class _NewAdventureTabState extends State<NewAdventureTab> {
  static final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final _adventureTitleControler = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return
        Container(
          color: Color.fromARGB(255, 20, 110, 111),
          child:
              Container(
                height: 220,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5), color: Colors.white),
                margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                child: ListView(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            "Create adventure",
                            style: TextStyle(
                                fontFamily: "IndieFlower",
                                color: Color.fromARGB(255, 84, 166, 145),
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: TextFormField(
                              key: _formKey,
                              controller: _adventureTitleControler,
                              autofocus: true,
                              style: TextStyle(),
                              decoration: InputDecoration(
                                  labelText: "Choose a name for adventure",
                                  hintStyle: TextStyle(
                                    fontSize: 15,
                                  ),
                                  contentPadding: EdgeInsets.only(
                                      top: 30, right: 30, bottom: 10, left: 5)),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: RaisedButton(
                              onPressed: () {

                                  Map<String, dynamic> adventureData = {
                                    "title": _adventureTitleControler.text,
                                  };
                                  print(adventureData);
                                  Navigator.of(context).pop();

                              },
                              color: Color.fromRGBO(0, 226, 186, 1.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: 10.0,
                                  ),
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
                    ),
                  ],
                )
              ),

        );

  }


  void _onSuccess() {}

  void _onFail() {}

}
