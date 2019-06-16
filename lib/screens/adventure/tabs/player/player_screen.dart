import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PlayerScreen extends StatefulWidget {

  final DocumentSnapshot adventureData,playerData;
  final Map<String,dynamic > userLoggedData;

  PlayerScreen(this.adventureData,this.userLoggedData,this.playerData);

  @override
  _PlayerScreenState createState() => _PlayerScreenState(adventureData,userLoggedData,playerData);
}

class _PlayerScreenState extends State<PlayerScreen> {
  final DocumentSnapshot adventure, playerData;
  final Map<String,dynamic > userLogged;

  _PlayerScreenState(this.adventure,this.userLogged,this.playerData);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/adventure_start" +
                        adventure["photoNumber"] +
                        ".png"),
                    fit: BoxFit.cover)),
            child: Container(
              margin: EdgeInsets.only(left: 40, top: 20, right: 40),
            )
        ),
        Container(
          margin: EdgeInsets.only(top: 100),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 100.0,
                height: 100.0,
                decoration:
                BoxDecoration(
                    shape: BoxShape
                        .circle,
                    border: Border.all(width: 2,color: Colors.black),
                    image:
                    DecorationImage(
                      fit:
                      BoxFit.fill,
                      image: playerData["photoUrl"] != null
                          ? NetworkImage(playerData["photoUrl"])
                          : AssetImage("images/rpg_icon.png"),
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
