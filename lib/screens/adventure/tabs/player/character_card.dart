import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:rpg_assist_app/models/adventure_model.dart';
import 'package:rpg_assist_app/screens/adventure/tabs/player/widgets/info_character.dart';
import 'package:rpg_assist_app/screens/adventure/tabs/player/widgets/status_character.dart';
import 'package:rpg_assist_app/screens/adventure/tabs/player/widgets/status_slider.dart';
import 'package:scoped_model/scoped_model.dart';

class CharacterCard extends StatefulWidget {
  final DocumentSnapshot adventureDoc, userPlayerData, playerData;
  final Map<String, dynamic> userLogged;

  CharacterCard(
      this.adventureDoc, this.userPlayerData, this.userLogged, this.playerData);

  @override
  _CharacterCardState createState() =>
      _CharacterCardState(adventureDoc, userPlayerData, userLogged, playerData);
}

class _CharacterCardState extends State<CharacterCard> {
  final DocumentSnapshot adventureDoc, userPlayerData, playerData;
  final Map<String, dynamic> userLogged;

  _CharacterCardState(
      this.adventureDoc, this.userPlayerData, this.userLogged, this.playerData);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AdventureModel>(
      builder: (context, child, adventureModel) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            child: FutureBuilder<DocumentSnapshot>(
              future: adventureModel.playerCharacter(
                  adventureDoc["adventureId"], playerData["characterId"]),
              builder: (context, playerCharacterData) {
                switch (playerCharacterData.connectionState) {
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
                    if (!playerCharacterData.data.exists) {
                      return Container(
                        child: Center(
                          child: Text(
                            "This Character is not available",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 6, 223, 176)),
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        margin: EdgeInsets.only(top: 30,bottom: 0,left: 5,right: 5),
                        child: ListView(
                          padding: EdgeInsets.all(0),
                          children: <Widget>[
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 25),
                                    width: 70.0,
                                    height: 70.0,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: userPlayerData["photoUrl"] != null
                                              ? NetworkImage(
                                                  userPlayerData["photoUrl"])
                                              : AssetImage("images/rpg_icon.png"),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: Colors.black26,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                      "CHARACTER SHEET",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.white),
                                    ),
                                  ),
                                  Card(
                                    color: Colors.black38,
                                    child: InfoCharacter(adventureDoc,playerData,playerCharacterData.data,userLogged),
                                  ),
                                  Card(
                                    elevation: 10,
                                    color: Colors.black38,
                                    child: Column(
                                      children: <Widget>[
                                        StatusSlider("hp",Color.fromARGB(255, 255, 0, 0),adventureDoc, playerCharacterData.data,userLogged["id"]),
                                        StatusSlider("xp",Color.fromARGB(255, 6, 223, 176),adventureDoc, playerCharacterData.data,userLogged["id"]),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    height: 270,
                                    child: GridView.count(
                                      physics: NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.all(0),
                                      crossAxisCount: 3,
                                      children: <Widget>[
                                        StatusCharacter("str", adventureDoc, playerCharacterData.data,userLogged["id"]),
                                        StatusCharacter("dex", adventureDoc, playerCharacterData.data,userLogged["id"]),
                                        StatusCharacter("int", adventureDoc, playerCharacterData.data,userLogged["id"]),
                                        StatusCharacter("cha", adventureDoc, playerCharacterData.data,userLogged["id"]),
                                        StatusCharacter("con", adventureDoc, playerCharacterData.data,userLogged["id"]),
                                        StatusCharacter("wis", adventureDoc, playerCharacterData.data,userLogged["id"]),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                }
              },
            ),
          ),
        );
      },
    );
  }
}
