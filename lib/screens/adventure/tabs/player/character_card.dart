import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CharacterCard extends StatefulWidget {
  final DocumentSnapshot adventureDoc, playerData;
  final Map<String, dynamic> userLogged;

  CharacterCard(this.adventureDoc, this.playerData, this.userLogged);

  @override
  _CharacterCardState createState() =>
      _CharacterCardState(adventureDoc, playerData, userLogged);
}

class _CharacterCardState extends State<CharacterCard> {
  final DocumentSnapshot adventureDoc, playerData;
  final Map<String, dynamic> userLogged;

  _CharacterCardState(this.adventureDoc, this.playerData, this.userLogged);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
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
                        image: playerData["photoUrl"] != null
                            ? NetworkImage(playerData["photoUrl"])
                            : AssetImage("images/rpg_icon.png"),
                      )),
                ),
              ],
            ),
          ),
          ListView(
            padding: EdgeInsets.all(0),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 200),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Container(
                                margin: EdgeInsets.all(10),
                                width: 80.0,
                                height: 80.0,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: AssetImage("images/dwarf-helmet.png"),
                                    )),
                              ),
                            ]),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text("NAME: ",
                                            style: TextStyle(color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text("RACE: ",
                                            style: TextStyle(color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text("CLASS: ",
                                            style: TextStyle(color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text("SEX: ",
                                            style: TextStyle(color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text("AWAFUL",
                                            style: TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text("DWARF",
                                            style: TextStyle(color: Colors.white,
                                                )),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text("WARRIOR",
                                            style: TextStyle(color: Colors.white,
                                                )),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text("MALE",
                                            style: TextStyle(color: Colors.white,
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 90,
                                  height: 80,
                                  color: Colors.white10,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "LEVEL",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        "10",
                                        style: TextStyle(color: Colors.white,
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                            activeTrackColor: Colors.red,
                                            inactiveTrackColor: Colors.white30,
                                            thumbColor: Colors.white,
                                            thumbShape: RoundSliderThumbShape(
                                                enabledThumbRadius: 10)),
                                    child: Flexible(
                                      child: Slider(
                                          min: 0,
                                          max: 100,
                                          value: 50,
                                          onChanged: (t) {}),
                                    ),
                                  ),
                                  Text(
                                    "100",
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
                                            activeTrackColor: Color.fromARGB(
                                                255, 6, 223, 176),
                                            inactiveTrackColor: Colors.white30,
                                            thumbColor: Colors.white,
                                            thumbShape: RoundSliderThumbShape(
                                                enabledThumbRadius: 10)),
                                    child: Flexible(
                                      child: Slider(
                                          min: 0,
                                          max: 100,
                                          value: 50,
                                          onChanged: (t) {}),
                                    ),
                                  ),
                                  Text(
                                    "100",
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
                                      height: 110,
                                      width: 110,
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<
                                                Color>(
                                            Color.fromARGB(255, 6, 223, 176)),
                                        backgroundColor: Colors.black54,
                                        strokeWidth: 5,
                                        value: .5,
                                      ),
                                    ),
                                  ),
                                  Container(
                                      child: Center(
                                          child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "50",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 50),
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
                                      height: 110,
                                      width: 110,
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<
                                                Color>(
                                            Color.fromARGB(255, 6, 223, 176)),
                                        backgroundColor: Colors.black54,
                                        strokeWidth: 5,
                                        value: .5,
                                      ),
                                    ),
                                  ),
                                  Container(
                                      child: Center(
                                          child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "50",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 50),
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
                                      height: 110,
                                      width: 110,
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<
                                                Color>(
                                            Color.fromARGB(255, 6, 223, 176)),
                                        backgroundColor: Colors.black54,
                                        strokeWidth: 5,
                                        value: .5,
                                      ),
                                    ),
                                  ),
                                  Container(
                                      child: Center(
                                          child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "50",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 50),
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
                                      height: 110,
                                      width: 110,
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<
                                                Color>(
                                            Color.fromARGB(255, 6, 223, 176)),
                                        backgroundColor: Colors.black54,
                                        strokeWidth: 5,
                                        value: .5,
                                      ),
                                    ),
                                  ),
                                  Container(
                                      child: Center(
                                          child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "50",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 50),
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
                                      height: 110,
                                      width: 110,
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<
                                                Color>(
                                            Color.fromARGB(255, 6, 223, 176)),
                                        backgroundColor: Colors.black54,
                                        strokeWidth: 5,
                                        value: .5,
                                      ),
                                    ),
                                  ),
                                  Container(
                                      child: Center(
                                          child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "50",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 50),
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
                                      height: 110,
                                      width: 110,
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<
                                                Color>(
                                            Color.fromARGB(255, 6, 223, 176)),
                                        backgroundColor: Colors.black54,
                                        strokeWidth: 5,
                                        value: .5,
                                      ),
                                    ),
                                  ),
                                  Container(
                                      child: Center(
                                          child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "50",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 50),
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
          )
        ],
      ),
    );
  }
}
