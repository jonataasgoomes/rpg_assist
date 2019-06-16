import 'package:flutter/material.dart';
import 'package:rpg_assist_app/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

import 'character_card.dart';

class PlayerScreen extends StatefulWidget {
  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          CharacterCard(),
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
          Container(
            child: Center(
              child: Text("Combat"),
            ),
          ),
        ],
      ),
    );
  }
}
