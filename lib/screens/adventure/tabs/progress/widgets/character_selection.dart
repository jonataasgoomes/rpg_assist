import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rpg_assist_app/models/adventure_model.dart';
import 'package:scoped_model/scoped_model.dart';

import '../combat.dart';

class CharacterSelection extends StatefulWidget {
  final DocumentSnapshot adventureDoc;
  final Map<String, dynamic> userLogged;
  final String sessionId;
  final int sessionStatus;

  const CharacterSelection(
      this.adventureDoc, this.sessionId, this.sessionStatus, this.userLogged);

  @override
  _CharacterSelectionState createState() => _CharacterSelectionState(
      adventureDoc, sessionId, sessionStatus, userLogged);
}

class _CharacterSelectionState extends State<CharacterSelection> {
  final DocumentSnapshot adventureDoc;
  final Map<String, dynamic> userLogged;
  final String sessionId;
  final int sessionStatus;

  _CharacterSelectionState(
      this.adventureDoc, this.sessionId, this.sessionStatus, this.userLogged);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScopedModelDescendant<AdventureModel>(
        builder: (context, child, adventureModel) {
          return Container(
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Select you character",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                Container(
                  child: FutureBuilder<QuerySnapshot>(
                      future: adventureModel.allPlayerCharacter(
                          adventureDoc["adventureId"], userLogged["id"]),
                      builder: (context, characterSnapshot) {
                        switch (characterSnapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Container(
                              color: Colors.white,
                            );
                          default:
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Visibility(
                                  visible: adventureDoc["master"] ==
                                      userLogged["id"],
                                  child: Flexible(
                                    flex: 0,
                                    child: Center(
                                      child: Card(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          splashColor:
                                              Color.fromARGB(255, 6, 223, 176),
                                          onTap: () {},
                                          onLongPress: () {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => Combat(adventureDoc, sessionId, sessionStatus,userLogged["id"],userLogged)));
                                          },
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Color.fromARGB(
                                                        255, 6, 223, 176)),
                                                child: Container(
                                                  margin: EdgeInsets.all(5),
                                                  height: 70,
                                                  width: 70,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: AssetImage(
                                                          "images/crowns.png"),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "Master",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Color.fromARGB(
                                                        255, 6, 223, 176)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: characterSnapshot.data.documents.length != 0 ,
                                  child: Flexible(
                                    child: Container(
                                      child: GridView.count(
                                        physics: NeverScrollableScrollPhysics(),
                                        childAspectRatio: adventureDoc["master"] == userLogged["id"]? 1:2,
                                        shrinkWrap: true,
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 10),
                                        crossAxisCount: 1,
                                        children: <Widget>[
                                          Center(
                                            child: ListView(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              children: List.generate(
                                                characterSnapshot
                                                    .data.documents.length,
                                                (index) {
                                                  return Center(
                                                    child: Card(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        splashColor: Color.fromARGB(
                                                            255, 6, 223, 176),
                                                        onTap: () {},
                                                        onLongPress: () {
                                                          Navigator.pushReplacement(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => Combat(
                                                                      adventureDoc,
                                                                      sessionId,
                                                                      sessionStatus,
                                                                      characterSnapshot
                                                                              .data
                                                                              .documents[index]
                                                                          [
                                                                          "characterId"],
                                                                      userLogged)));
                                                        },
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            Container(
                                                              margin:
                                                                  EdgeInsets.all(5),
                                                              decoration:
                                                                  BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color: Color
                                                                          .fromARGB(
                                                                              255,
                                                                              6,
                                                                              223,
                                                                              176)),
                                                              child: Container(
                                                                margin:
                                                                    EdgeInsets.all(
                                                                        5),
                                                                height: 70,
                                                                width: 70,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  image:
                                                                      DecorationImage(
                                                                    fit:
                                                                        BoxFit.fill,
                                                                    image: AssetImage(
                                                                        "images/race${characterSnapshot.data.documents[index]["raceNumber"]}.png"),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              characterSnapshot.data
                                                                      .documents[
                                                                  index]["name"],
                                                              textAlign:
                                                                  TextAlign.center,
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          6,
                                                                          223,
                                                                          176)),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                        }
                      }),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
