import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'character_card.dart';
import 'combat.dart';
import 'glossary.dart';
import 'messages.dart';
import 'test.dart';

class PlayerScreen extends StatefulWidget {
  final DocumentSnapshot adventureDoc, playerData;
  final Map<String, dynamic> userLogged;

  PlayerScreen(this.adventureDoc, this.playerData, this.userLogged);

  @override
  _PlayerScreenState createState() =>
      _PlayerScreenState(adventureDoc, playerData, userLogged);
}

class _PlayerScreenState extends State<PlayerScreen> {
  final DocumentSnapshot adventureDoc, playerData;
  final Map<String, dynamic> userLogged;

  _PlayerScreenState(this.adventureDoc, this.playerData, this.userLogged);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 34, 17, 51),
        title: Image.asset(
          "images/logo.png",
          height: 20,
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Color.fromARGB(255, 234, 205, 125)),
        actions: <Widget>[PopupMenuButton(itemBuilder: (_) {})],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 34, 17, 51),
                  Color.fromARGB(255, 44, 100, 124),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          PageView(
            children: <Widget>[
              CharacterCard(adventureDoc, playerData, userLogged),
              Messages(),
              Container(
                  child: Combat()),
            ],
          ),
        ],
      ),
    );
  }
}
