import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:rpg_assist_app/models/adventure_model.dart';
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
                                    child: Wrap(
                                      runAlignment: WrapAlignment.center,
                                      alignment: WrapAlignment.spaceAround,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      direction: Axis.horizontal,
                                      children: <Widget>[
                                        Container(
                                          height: 100,
                                          width: 100,
                                          child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Stack(
                                                  children: <Widget>[
                                                    Container(
                                                      margin: EdgeInsets.all(10),
                                                      width: 80.0,
                                                      height: 80.0,
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          image: DecorationImage(
                                                            fit: BoxFit.fill,
                                                            image: AssetImage(
                                                                "images/race0.png"),
                                                          )),
                                                    ),
                                                    Visibility(
                                                      visible: ((adventureDoc[
                                                      "master"] ==
                                                          userLogged["id"]) |
                                                      (userLogged["id"] ==
                                                          playerData[
                                                          "userId"])),
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            left: 65, top: 70),
                                                        width: 20,
                                                        height: 20,
                                                        alignment:
                                                        Alignment.center,
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: Colors.blue,
                                                        ),
                                                        child: Text(
                                                          "+",
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ]),
                                        ),
                                        Container(
                                          height: 70,
                                          width: 110,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Text("NAME: ",
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontWeight:
                                                              FontWeight.bold)),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Text("RACE: ",
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontWeight:
                                                              FontWeight.bold)),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Text("CLASS: ",
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontWeight:
                                                              FontWeight.bold)),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Text("SEX: ",
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontWeight:
                                                              FontWeight.bold)),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                          playerCharacterData.data[
                                                          'name'] !=
                                                              null
                                                              ? playerCharacterData
                                                              .data['name']
                                                              .toString()
                                                              : "",
                                                          style: TextStyle(
                                                              color: Colors.white)),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                          playerCharacterData.data[
                                                          'race'] !=
                                                              null
                                                              ? playerCharacterData
                                                              .data['race']
                                                              .toString()
                                                              : "",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          )),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                          playerCharacterData.data[
                                                          'class'] !=
                                                              null
                                                              ? playerCharacterData
                                                              .data['class']
                                                              .toString()
                                                              : "",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          )),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                          playerCharacterData.data[
                                                          'sex'] !=
                                                              null
                                                              ? playerCharacterData
                                                              .data['sex']
                                                              .toString()
                                                              : "",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          )),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 100,
                                          height: 100,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                highlightColor: Colors.red,
                                                onLongPress: (){

                                                },
                                                child: Card(
                                                  color: Colors.white10,
                                                  child: Container(
                                                    width: 90,
                                                    height: 80,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                      children: <Widget>[
                                                        Text(
                                                          "LEVEL",
                                                          style: TextStyle(
                                                              color: Colors.white),
                                                        ),
                                                        Text(
                                                          playerCharacterData.data[
                                                          'level'] !=
                                                              null
                                                              ? playerCharacterData
                                                              .data['level']
                                                              .toString()
                                                              : "",
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 45),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Card(
                                    elevation: 10,
                                    color: Colors.black38,
                                    child: Column(
                                      children: <Widget>[
                                        StatusSlider("hp",Color.fromARGB(255, 255, 0, 0),adventureDoc, playerCharacterData.data),
                                        StatusSlider("xp",Color.fromARGB(255, 6, 223, 176),adventureDoc, playerCharacterData.data),
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
                                        StatusCharacter("str", adventureDoc, playerCharacterData.data),
                                        StatusCharacter("dex", adventureDoc, playerCharacterData.data),
                                        StatusCharacter("int", adventureDoc, playerCharacterData.data),
                                        StatusCharacter("cha", adventureDoc, playerCharacterData.data),
                                        StatusCharacter("con", adventureDoc, playerCharacterData.data),
                                        StatusCharacter("wis", adventureDoc, playerCharacterData.data),
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
