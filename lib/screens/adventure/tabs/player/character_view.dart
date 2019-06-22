import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'character_card.dart';

class CharacterView extends StatelessWidget {
  final DocumentSnapshot adventureDoc, userPlayerData, playerData;
  final Map<String, dynamic> userLogged;

  const CharacterView(this.adventureDoc, this.userPlayerData, this.userLogged, this.playerData) ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 34, 17, 51),
        iconTheme: IconThemeData(color: Color.fromARGB(255, 234, 205, 125)),
        centerTitle: true,
        title: Text(userPlayerData["name"],style: TextStyle(color: Color.fromARGB(255, 234, 205, 125)),),
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
            CharacterCard(adventureDoc,userPlayerData,userLogged,playerData),
          ]
      )
    );
  }
}
