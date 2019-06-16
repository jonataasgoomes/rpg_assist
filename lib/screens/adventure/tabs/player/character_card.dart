import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CharacterCard extends StatefulWidget {
  final DocumentSnapshot adventureDoc, playerData;
  final Map<String,dynamic> userLogged;
  CharacterCard(this.adventureDoc,this.playerData,this.userLogged);

  @override
  _CharacterCardState createState() => _CharacterCardState(adventureDoc,playerData,userLogged);
}
class _CharacterCardState extends State<CharacterCard> {
  Widget _buildBodyBack() => Container(
    decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 34, 17, 51),
            Color.fromARGB(255, 44, 100, 124)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
  );
  final DocumentSnapshot adventureDoc, playerData;
  final Map<String,dynamic> userLogged;
  _CharacterCardState(this.adventureDoc,this.playerData,this.userLogged);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            _buildBodyBack(),
            Container(
              margin: EdgeInsets.only(top: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text("CHARACTER SHEET",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "IndieFlower",
                    color: Colors.white
                  ),)
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}
