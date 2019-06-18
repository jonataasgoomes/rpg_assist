import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:rpg_assist_app/models/adventure_model.dart';
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
          body: StreamBuilder<DocumentSnapshot>(
            stream: adventureModel.playerCharacter(
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
                                fontFamily: "IndieFlower",
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
                  if (playerCharacterData.data == null) {
                    return Container(
                      margin: EdgeInsets.all(50),
                      child: Center(
                        child: Text(
                          "This Character is not available",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              fontFamily: "IndieFlower",
                              color: Color.fromARGB(255, 6, 223, 176)),
                        ),
                      ),
                    );
                  } else {
                    return ListView(
                      padding: EdgeInsets.all(0),
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 25),
                                width: 100.0,
                                height: 100.0,
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Text(
                                "CHARACTER SHEET",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "IndieFlower",
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                              Card(
                                color: Colors.black38,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
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
                                                            "images/dwarf-helmet.png"),
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
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.blue,
                                                    ),
                                                    child: Text(
                                                      "+",
                                                      style: TextStyle(
                                                        fontSize: 15,
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
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
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
                                          Spacer(),
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
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            width: 90,
                                            height: 80,
                                            color: Colors.white10,
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
                                                  playerCharacterData
                                                              .data['level'] !=
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
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Card(
                                elevation: 10,
                                color: Colors.black38,
                                child: Container(
                                  height: 130,
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(top: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "HP",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "IndieFlower",
                                                  fontSize: 30,
                                                  color: Colors.white),
                                            ),
                                            SliderTheme(
                                              data: Theme.of(context)
                                                  .sliderTheme
                                                  .copyWith(
                                                      trackHeight: 10,
                                                      activeTrackColor:
                                                          Colors.red,
                                                      inactiveTrackColor:
                                                          Colors.white30,
                                                      thumbColor: Colors.white,
                                                      thumbShape:
                                                          RoundSliderThumbShape(
                                                              enabledThumbRadius:
                                                                  10)),
                                              child: Flexible(
                                                child: Slider(
                                                    min: 0,
                                                    max: 100,
                                                    value: playerCharacterData.data['hp'] != null ? playerCharacterData.data['hp'].toDouble() : 0.0,
                                                    onChanged: (t) {}),
                                              ),
                                            ),
                                            Text(
                                              playerCharacterData.data['hp'] !=
                                                      null
                                                  ? playerCharacterData
                                                      .data['hp']
                                                      .toString()
                                                  : "0",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "IndieFlower",
                                                  fontSize: 30,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "XP",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "IndieFlower",
                                                  fontSize: 30,
                                                  color: Colors.white),
                                            ),
                                            SliderTheme(
                                              data: Theme.of(context)
                                                  .sliderTheme
                                                  .copyWith(
                                                      trackHeight: 10,
                                                      activeTrackColor:
                                                          Color.fromARGB(
                                                              255, 6, 223, 176),
                                                      inactiveTrackColor:
                                                          Colors.white30,
                                                      thumbColor: Colors.white,
                                                      thumbShape:
                                                          RoundSliderThumbShape(
                                                              enabledThumbRadius:
                                                                  10)),
                                              child: Flexible(
                                                child: Slider(
                                                    min: 0,
                                                    max: 100,
                                                    value: playerCharacterData.data['xp'] != null ? playerCharacterData.data['xp'].toDouble() : 0.0,
                                                    onChanged: (t) {}),
                                              ),
                                            ),
                                            Text(
                                              playerCharacterData.data['xp'] !=
                                                      null
                                                  ? playerCharacterData
                                                      .data['xp']
                                                      .toString()
                                                  : "",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "IndieFlower",
                                                  fontSize: 30,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: 280,
                                child: GridView.count(
                                  padding: EdgeInsets.all(0),
                                  crossAxisCount: 3,
                                  children: <Widget>[
                                    Card(
                                      color: Colors.black38,
                                      child: Container(
                                        child: Stack(
                                          children: <Widget>[
                                            Center(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white10,
                                                    shape: BoxShape.circle),
                                                height: 100,
                                                width: 100,
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          Color.fromARGB(255, 6,
                                                              223, 176)),
                                                  backgroundColor:
                                                      Colors.black54,
                                                  strokeWidth: 5,
                                                  value: playerCharacterData.data["str"] != null? playerCharacterData.data["str"].toDouble()/100 :0,
                                                ),
                                              ),
                                            ),
                                            Container(
                                                child: Center(
                                                    child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  playerCharacterData
                                                              .data['str'] !=
                                                          null
                                                      ? playerCharacterData
                                                          .data['str']
                                                          .toString()
                                                      : "",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 50),
                                                ),
                                                Text(
                                                  "STR",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 2,
                                                  ),
                                                ),
                                              ],
                                            ))),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Card(
                                      color: Colors.black38,
                                      child: Container(
                                        child: Stack(
                                          children: <Widget>[
                                            Center(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white10,
                                                    shape: BoxShape.circle),
                                                height: 100,
                                                width: 100,
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          Color.fromARGB(255, 6,
                                                              223, 176)),
                                                  backgroundColor:
                                                      Colors.black54,
                                                  strokeWidth: 5,
                                                  value: playerCharacterData.data["dex"] != null? playerCharacterData.data["dex"].toDouble()/100 :0,
                                                ),
                                              ),
                                            ),
                                            Container(
                                                child: Center(
                                                    child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  playerCharacterData
                                                              .data['dex'] !=
                                                          null
                                                      ? playerCharacterData
                                                          .data['dex']
                                                          .toString()
                                                      : "",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 50),
                                                ),
                                                Text(
                                                  "DEX",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 2,
                                                  ),
                                                ),
                                              ],
                                            ))),
                                          ],
                                        ),
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    Card(
                                      color: Colors.black38,
                                      child: Container(
                                        child: Stack(
                                          children: <Widget>[
                                            Center(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white10,
                                                    shape: BoxShape.circle),
                                                height: 100,
                                                width: 100,
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          Color.fromARGB(255, 6,
                                                              223, 176)),
                                                  backgroundColor:
                                                      Colors.black54,
                                                  strokeWidth: 5,
                                                  value: playerCharacterData.data["int"] != null? playerCharacterData.data["int"].toDouble()/100 :0,
                                                ),
                                              ),
                                            ),
                                            Container(
                                                child: Center(
                                                    child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  playerCharacterData
                                                              .data['int'] !=
                                                          null
                                                      ? playerCharacterData
                                                          .data['int']
                                                          .toString()
                                                      : "",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 50),
                                                ),
                                                Text(
                                                  "INT",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 2,
                                                  ),
                                                ),
                                              ],
                                            ))),
                                          ],
                                        ),
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    Card(
                                      color: Colors.black38,
                                      child: Container(
                                        child: Stack(
                                          children: <Widget>[
                                            Center(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white10,
                                                    shape: BoxShape.circle),
                                                height: 100,
                                                width: 100,
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          Color.fromARGB(255, 6,
                                                              223, 176)),
                                                  backgroundColor:
                                                      Colors.black54,
                                                  strokeWidth: 5,
                                                  value: playerCharacterData.data["cha"] != null? playerCharacterData.data["cha"].toDouble()/100 :0,
                                                ),
                                              ),
                                            ),
                                            Container(
                                                child: Center(
                                                    child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  playerCharacterData
                                                              .data['cha'] !=
                                                          null
                                                      ? playerCharacterData
                                                          .data['cha']
                                                          .toString()
                                                      : "",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 50),
                                                ),
                                                Text(
                                                  "CHA",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 2,
                                                  ),
                                                ),
                                              ],
                                            ))),
                                          ],
                                        ),
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    Card(
                                      color: Colors.black38,
                                      child: Container(
                                        child: Stack(
                                          children: <Widget>[
                                            Center(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white10,
                                                    shape: BoxShape.circle),
                                                height: 100,
                                                width: 100,
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          Color.fromARGB(255, 6,
                                                              223, 176)),
                                                  backgroundColor:
                                                      Colors.black54,
                                                  strokeWidth: 5,
                                                  value: playerCharacterData.data["con"] != null? playerCharacterData.data["con"].toDouble()/100 :0,
                                                ),
                                              ),
                                            ),
                                            Container(
                                                child: Center(
                                                    child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  playerCharacterData
                                                              .data['con'] !=
                                                          null
                                                      ? playerCharacterData
                                                          .data['con']
                                                          .toString()
                                                      : "",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 50),
                                                ),
                                                Text(
                                                  "CON",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 2,
                                                  ),
                                                ),
                                              ],
                                            ))),
                                          ],
                                        ),
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    Card(
                                      color: Colors.black38,
                                      child: Container(
                                        child: Stack(
                                          children: <Widget>[
                                            Center(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white10,
                                                    shape: BoxShape.circle),
                                                height: 100,
                                                width: 100,
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          Color.fromARGB(255, 6,
                                                              223, 176)),
                                                  backgroundColor:
                                                      Colors.black54,
                                                  strokeWidth: 5,
                                                  value: playerCharacterData.data["wis"] != null? playerCharacterData.data["wis"].toDouble()/100 :0,
                                                ),
                                              ),
                                            ),
                                            Container(
                                                child: Center(
                                                    child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  playerCharacterData
                                                              .data['wis'] !=
                                                          null
                                                      ? playerCharacterData
                                                          .data['wis']
                                                          .toString()
                                                      : "",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 50),
                                                ),
                                                Text(
                                                  "WIS",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 2,
                                                  ),
                                                ),
                                              ],
                                            ))),
                                          ],
                                        ),
                                        color: Colors.transparent,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  }
              }
            },
          ),
        );
      },
    );
  }
}
