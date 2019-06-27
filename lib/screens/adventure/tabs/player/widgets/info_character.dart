import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:rpg_assist_app/models/adventure_model.dart';
import 'package:scoped_model/scoped_model.dart';


class InfoCharacter extends StatefulWidget {
  final DocumentSnapshot adventureDoc, playerData, playerCharacterData;
  final Map<String, dynamic> userLogged;


  InfoCharacter(this.adventureDoc, this.playerData, this.playerCharacterData,
      this.userLogged);

  @override
  _InfoCharacterState createState() =>
      _InfoCharacterState(
          adventureDoc, playerData, playerCharacterData, userLogged);
}

class _InfoCharacterState extends State<InfoCharacter> {
  final DocumentSnapshot adventureDoc, playerData, playerCharacterData;
  final Map<String, dynamic> userLogged;
  String level = "level";

  _InfoCharacterState(this.adventureDoc, this.playerData,
      this.playerCharacterData, this.userLogged);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AdventureModel>(
      builder: (context, child, adventureModel) {
        return Wrap(
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
                  Expanded(
                    flex: 0,
                    child: Container(
                      width: 75.0,
                      height: 75.0,
                      decoration:
                      BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: playerCharacterData
                              .data["raceNumber"] != 404
                              ? AssetImage(
                              "images/race${playerCharacterData
                                  .data["raceNumber"]}.png")
                              : AssetImage(
                              "images/rpg_icon.png"),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 25.0,
                          height: 25.0,
                          decoration:
                          BoxDecoration(
                            color: Colors.black12,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: playerCharacterData
                                  .data["classNumber"] != 404
                                  ? AssetImage(
                                  "images/class${playerCharacterData
                                      .data["classNumber"]}.png")
                                  : AssetImage(
                                  "images/rpg_icon.png"),
                            ),
                          ),
                        ),
                        Container(
                          width: 25.0,
                          height: 25.0,
                          decoration:
                          BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: playerCharacterData
                                  .data["sexNumber"] != 404
                                  ? AssetImage(
                                  "images/sex${playerCharacterData
                                      .data["sexNumber"]}.png")
                                  : AssetImage(
                                  "images/rpg_icon.png"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
                          Container(
                            width: 65,
                            child: Text(
                                playerCharacterData.data[
                                'name'] !=
                                    null
                                    ? playerCharacterData
                                    .data['name']
                                    .toString()
                                    : "",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.white)),
                          ),
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
              child: StreamBuilder(
                stream: adventureModel.playerCharacterStream(
                    adventureDoc['adventureId'],
                    playerCharacterData['characterId']),
                builder: (context, characterData) {
                  switch (characterData.connectionState) {
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    default:
                      if (!characterData.hasData) {
                        return Container(
                          child: Center(
                            child: Text(
                              "No data has found",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 6, 223, 176)),
                            ),
                          ),
                        );

                      } else {
                        return Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              highlightColor: Colors.red,
                              onLongPress: (){
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return NumberPickerDialog.integer(
                                      initialIntegerValue: playerCharacterData.data[level],
                                      title: Text(
                                        level.toUpperCase(),
                                        style: TextStyle(
                                            color: Color.fromARGB(255, 34, 17, 51)),
                                        textAlign: TextAlign.center,
                                      ),
                                      minValue: 0,
                                      maxValue: 100,
                                    );
                                  },
                                ).then(
                                      (value) {
                                    if (value != null) {
                                      adventureModel.updateCharacterField(
                                          level,
                                          value,
                                          adventureDoc["adventureId"],
                                          this.playerCharacterData["characterId"]);
                                    }
                                    print(value);
                                  },
                                );

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
                                        characterData.data[
                                        level] !=
                                            null
                                            ? characterData
                                            .data[level]
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
                        );

                      }
                  }
                },),
            ),
          ],
        );
      },
    );
  }
}
