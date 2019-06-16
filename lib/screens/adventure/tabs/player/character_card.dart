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
  Widget _buildBodyBack() => Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 34, 130, 124),
            Color.fromARGB(255, 154, 52, 79)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
      );
  final DocumentSnapshot adventureDoc, playerData;
  final Map<String, dynamic> userLogged;

  _CharacterCardState(this.adventureDoc, this.playerData, this.userLogged);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/adventure_start" +
                        adventureDoc["photoNumber"] +
                        ".png"),
                    fit: BoxFit.cover)),
          ),
          Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 100),
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
            ],
          ),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                data: Theme.of(context).sliderTheme.copyWith(
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                data: Theme.of(context).sliderTheme.copyWith(
                                    trackHeight: 10,
                                    activeTrackColor:
                                        Color.fromARGB(255, 6, 223, 176),
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
                Flexible(
                  child: Container(
                    child: GridView.count(
                      padding: EdgeInsets.all(0),
                      crossAxisCount: 3,
                      children: <Widget>[
                        Card(
                          color: Colors.black26,
                          child: Container(
                            child: Stack(
                              children: <Widget>[
                                Center(
                                  child: Container(
                                    height: 110,
                                    width: 110,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Color.fromARGB(255, 6, 223, 176)),
                                      backgroundColor: Colors.black26,
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
                            color: Colors.transparent,
                          ),
                        ),
                        Card(
                          color: Colors.black26,
                          child: Container(
                            child: Stack(
                              children: <Widget>[
                                Center(
                                  child: Container(
                                    height: 110,
                                    width: 110,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Color.fromARGB(255, 6, 223, 176)),
                                      backgroundColor: Colors.black26,
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
                          color: Colors.black26,
                          child: Container(
                            child: Stack(
                              children: <Widget>[
                                Center(
                                  child: Container(
                                    height: 110,
                                    width: 110,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Color.fromARGB(255, 6, 223, 176)),
                                      backgroundColor: Colors.black26,
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
                          color: Colors.black26,
                          child: Container(
                            child: Stack(
                              children: <Widget>[
                                Center(
                                  child: Container(
                                    height: 110,
                                    width: 110,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Color.fromARGB(255, 6, 223, 176)),
                                      backgroundColor: Colors.black26,
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
                          color: Colors.black26,
                          child: Container(
                            child: Stack(
                              children: <Widget>[
                                Center(
                                  child: Container(
                                    height: 110,
                                    width: 110,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Color.fromARGB(255, 6, 223, 176)),
                                      backgroundColor: Colors.black26,
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
                          color: Colors.black26,
                          child: Container(
                            child: Stack(
                              children: <Widget>[
                                Center(
                                  child: Container(
                                    height: 110,
                                    width: 110,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Color.fromARGB(255, 6, 223, 176)),
                                      backgroundColor: Colors.black26,
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
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ));
  }
}
