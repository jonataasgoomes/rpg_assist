import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rpg_assist_app/models/adventure_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:numberpicker/numberpicker.dart';

class StatusCharacter extends StatefulWidget {
  final String statusField;
  final DocumentSnapshot adventureDoc, characterData;

  StatusCharacter(this.statusField, this.adventureDoc, this.characterData);

  @override
  _StatusCharacterState createState() =>
      _StatusCharacterState(statusField, adventureDoc, characterData);
}

class _StatusCharacterState extends State<StatusCharacter> {
  DocumentSnapshot adventureDoc, characterData;
  String statusField;

  _StatusCharacterState(
      this.statusField, this.adventureDoc, this.characterData);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AdventureModel>(
        builder: (context, child, adventureModel) {
      return StreamBuilder<DocumentSnapshot>(
        stream: adventureModel.playerCharacterStream(
            adventureDoc['adventureId'], characterData['characterId']),
        builder: (context, characterData) {
          switch (characterData.connectionState) {
            case ConnectionState.waiting:
              return Card(
                color: Colors.black38,
                child: Container(
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white10, shape: BoxShape.circle),
                          height: 100,
                          width: 100,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color.fromARGB(255, 6, 223, 176)),
                            backgroundColor: Colors.black54,
                            strokeWidth: 5,
                          ),
                        ),
                      ),
                      Container(
                          child: Center(
                              child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(),
                          Text(
                            statusField.toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ))),
                    ],
                  ),
                  color: Colors.transparent,
                ),
              );
            default:
              if (!characterData.data.exists) {
                return Container(
                  child: Center(
                    child: Text(
                      "No data has found",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 6, 223, 176)),
                    ),
                  ),
                );
              } else {
                return InkWell(
                  highlightColor: Colors.red,
                  onLongPress: () {
                    return showDialog(
                      context: context,
                      builder: (context) {
                        return NumberPickerDialog.integer(
                          initialIntegerValue: characterData.data[statusField],
                          title: Text(
                            statusField.toUpperCase(),
                            style: TextStyle(
                                color: Color.fromARGB(255, 34, 17, 51)),
                            textAlign: TextAlign.center,
                          ),
                          minValue: -100,
                          maxValue: 100,
                        );
                      },
                    ).then(
                      (value) {
                        if (value != null) {
                          adventureModel.updateCharacterField(
                              statusField,
                              value,
                              adventureDoc["adventureId"],
                              this.characterData["characterId"]);
                        }
                        print(value);
                      },
                    );
                  },
                  onTap: (){
                    if(adventureModel.statusSnackBar){
                      adventureModel.statusSnackBar = false;
                    Scaffold.of(context).showSnackBar(
                      SnackBar(content:Text("Hold to change the value on ${statusField.toUpperCase()}"),
                      ),
                    );
                    Future.delayed(Duration(seconds: 20)).then((_) {
                      adventureModel.statusSnackBar = true;
                    });
                    }else{
                      print("Waiting some seconds");
                    }
                  },
                  child: Card(
                    color: Colors.black38,
                    child: Container(
                      child: Stack(
                        children: <Widget>[
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white10,
                                  shape: BoxShape.circle),
                              height: 100,
                              width: 100,
                              child: CircularProgressIndicator(
                                valueColor: characterData.data[statusField] > 0 ? AlwaysStoppedAnimation<Color>(
                                    Color.fromARGB(255, 6, 223, 176)): AlwaysStoppedAnimation<Color>(
                                    Color.fromARGB(255, 0, 255, 0)),
                                backgroundColor: Colors.black54,
                                strokeWidth: 5,
                                value: characterData.data[statusField] != null
                                    ? characterData.data[statusField].toDouble()/100
                                    : 0,
                              ),
                            ),
                          ),
                          Container(
                              child: Center(
                                  child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                characterData.data[statusField] != null
                                    ? characterData.data[statusField].toString()
                                    : "",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 50),
                              ),
                              Text(
                                statusField.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ))),
                        ],
                      ),
                      color: Colors.transparent,
                    ),
                  ),
                );
              }
          }
        },
      );
    });
  }
}
