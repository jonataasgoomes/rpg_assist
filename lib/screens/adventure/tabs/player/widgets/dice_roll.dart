import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:rpg_assist_app/models/adventure_model.dart';
import 'package:scoped_model/scoped_model.dart';

class DiceRoll extends StatefulWidget {
  final DocumentSnapshot adventureDoc;
  final Map<String, dynamic> userLogged;

  DiceRoll(this.adventureDoc, this.userLogged);
  @override
  _DiceRollState createState() => _DiceRollState(adventureDoc,userLogged);
}

class _DiceRollState extends State<DiceRoll> {
  final DocumentSnapshot adventureDoc;
  final Map<String, dynamic> userLogged;
  Random seed = Random();
  int rand = 0;
  String anim = "Spin1";
  bool isPaused = true;
  bool animating = false;

  _DiceRollState(this.adventureDoc,this.userLogged);
  @override
  Widget build(BuildContext context) {
    return           Container(
      width: 350,
      height: 250,
      child: GestureDetector(
        onTap: () {
          if (!animating) {
            const int MAX_VALUE = 19;
            rand = seed.nextInt(MAX_VALUE) + 1;
            isPaused = false;
            animating = true;
            setState(() {
              anim = "Spin" + rand.toString();
              print(anim);
            });
          }
        },
        child: ScopedModelDescendant<AdventureModel>(
          builder: (context, child, adventureModel) {
            return FlareActor(
              "assets/D20.flr",
              animation: anim,
              isPaused: isPaused,
              callback: (string) {
                adventureModel.rollDice(
                    adventureDoc["adventureId"], userLogged["id"], rand);
                setState(
                      () {
                    anim = null;
                    animating = false;
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
