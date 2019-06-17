import 'dart:math';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class Combat extends StatefulWidget {
  @override
  _CombatState createState() => _CombatState();
}

class _CombatState extends State<Combat> {
  Random seed = Random();
  String anim = "Spin1";
  bool isPaused = true;
  bool animating = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: InkWell(
        onTap: (){
          if (!animating) {
            const int MAX_VALUE = 19;
            int rand = seed.nextInt(MAX_VALUE) + 1;
            isPaused = false;
            animating = true;
            setState(() {
              anim = "Spin" + rand.toString();
              print(anim);
            });
          }
        },
          child: FlareActor(
              "assets/D20.flr",
              animation: anim,
              isPaused: isPaused,
              callback: (string) {
                //SALVAR NO FIREBASE
                setState(() {
                  anim = null;
                  animating = false;
                });
              },)),
    );
  }
}
