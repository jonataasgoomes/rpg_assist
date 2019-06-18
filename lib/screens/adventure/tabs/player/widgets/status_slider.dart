import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class StatusSlider extends StatefulWidget {
  final DocumentSnapshot adventureDoc;
  final DocumentSnapshot playerData;

  StatusSlider(
      this.adventureDoc, this.playerData);

  @override
  _StatusSliderState createState() => _StatusSliderState(adventureDoc, playerData);
}

class _StatusSliderState extends State<StatusSlider> {
  final DocumentSnapshot adventureDoc;
  final DocumentSnapshot playerData;

  _StatusSliderState(this.adventureDoc, this.playerData);

  double _hp = 100;
  double _xp = 100;

  @override
  Widget build(BuildContext context) {
//    Firestore.instance
//        .collection("adventures")
//        .document(adventureDoc["adventureId"])
//        .collection("players")
//        .document(playerData["characterId"])
//        .snapshots().listen((doc) {
//          setState(() {
//            _hp = doc["hp"].toDouble();
//            _xp = doc["xp"].toDouble();
//          });
//    });
    return Card(
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
                          value: _hp,
                          onChangeEnd: (t) async {
                            Map<String, dynamic> aMap = Map();
                            aMap["hp"] = t.toInt();
//                            await Firestore.instance
//                                .collection("adventures")
//                                .document(adventureDoc["adventureId"])
//                                .collection("players")
//                                .document(playerData["characterId"]).updateData(aMap);
                          },
                          onChanged: (t) {
                            setState(() => _hp = t.roundToDouble());
                          }
                    )),
                  ),
                  Container(
                    width: 40,
                    child: Text(
                      _hp.toInt().toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "IndieFlower",
                          fontSize: 30,
                          color: Colors.white),
                    ),
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
                          value: _xp,
                          onChangeEnd: (t) async {
                            Map<String, dynamic> aMap = Map();
                            aMap["xp"] = t.toInt();
//                            await Firestore.instance
//                                .collection("adventures")
//                                .document(adventureDoc["adventureId"])
//                                .collection("players")
//                                .document(playerData["characterId"]).updateData(aMap);
                          },
                          onChanged: (t) {
                            setState(() => _xp = t.roundToDouble());
                          }),
                    ),
                  ),
                  Container(
                    width: 40,
                    child: Text(
                     _xp.toInt().toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "IndieFlower",
                          fontSize: 30,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
