import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:rpg_assist_app/models/adventure_model.dart';
import 'package:rpg_assist_app/screens/adventure/tabs/player/widgets/dice_roll.dart';
import 'package:scoped_model/scoped_model.dart';

class Combat extends StatefulWidget {
  final DocumentSnapshot adventureDoc;
  final Map<String, dynamic> userLogged;

  Combat(this.adventureDoc, this.userLogged);

  @override
  _CombatState createState() => _CombatState(adventureDoc, userLogged);
}

class _CombatState extends State<Combat> {
  Random seed = Random();
  int rand = 0;
  String anim = "Spin1";
  bool isPaused = true;
  bool animating = false;
  final DocumentSnapshot adventureDoc;
  final Map<String, dynamic> userLogged;

  _CombatState(this.adventureDoc, this.userLogged);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DiceRoll(adventureDoc, userLogged),
          ScopedModelDescendant<AdventureModel>(
            builder: (context, child, adventureModel) {
              return StreamBuilder<QuerySnapshot>(
                stream:
                    adventureModel.rollsAdventure(adventureDoc["adventureId"]),
                builder: (context, rolls) {
                  switch (rolls.connectionState) {
                    case ConnectionState.waiting:
                      return Container(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(top: 70),
                              child: Text(
                                "Loading ...",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 234, 205, 125),
                                    fontSize: 20),
                                textAlign: TextAlign.center,
                              )),
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            width: 80,
                            height: 80,
                            alignment: Alignment.center,
                            child: FlareActor("assets/Dice_Loading.flr",
                                animation: "loading"),
                          )
                        ],
                      ));
                    default:
                      if (rolls.data.documents.isEmpty) {
                        return Container(
                          margin: EdgeInsets.all(50),
                          child: Center(
                            child: Text(
                              "No dice rolls yet",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 6, 223, 176)),
                            ),
                          ),
                        );
                      } else {
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: rolls.data.documents.length,
                            itemBuilder: (context, index) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text(
                                    rolls.data.documents[index]["userId"],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    rolls.data.documents[index]["result"].toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              );
                            });
                      }
                  }
                },
              );
            },
          )
        ],
      ),
    );
  }
}
