import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rpg_assist_app/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

import 'character_card.dart';
import 'combat.dart';

class PlayerScreen extends StatefulWidget {
  final DocumentSnapshot adventureDoc, playerData;
  final Map<String,dynamic> userLogged;
  PlayerScreen(this.adventureDoc,this.playerData,this.userLogged);

  @override
  _PlayerScreenState createState() => _PlayerScreenState(adventureDoc,playerData,userLogged);
}

class _PlayerScreenState extends State<PlayerScreen> {
  final DocumentSnapshot adventureDoc, playerData;
  final Map<String,dynamic> userLogged;
  _PlayerScreenState(this.adventureDoc,this.playerData,this.userLogged);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          CharacterCard(adventureDoc,playerData,userLogged),
          Container(
            child: Center(
              child: Text("Messages"),
            ),
          ),
          Container(
            child: Center(
              child: Text("Glossary"),
            ),
          ),
          Container(
            child: Center(
              child: Text("Test"),
            ),
          ),
          Combat()
        ],
      ),
    );
  }
}
