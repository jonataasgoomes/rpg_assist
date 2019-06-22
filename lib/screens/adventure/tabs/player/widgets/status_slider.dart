import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rpg_assist_app/models/adventure_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';

class StatusSlider extends StatefulWidget {
  final DocumentSnapshot adventureDoc;
  final DocumentSnapshot playerData;
  final String sliderField;
  final Color color;

  StatusSlider(
    this.sliderField,
    this.color,
    this.adventureDoc,
    this.playerData,
  );

  @override
  _StatusSliderState createState() =>
      _StatusSliderState(sliderField, color, adventureDoc, playerData);
}

class _StatusSliderState extends State<StatusSlider> {
  final DocumentSnapshot adventureDoc;
  final DocumentSnapshot playerData;
  final String sliderField;
  final Color color;

  _StatusSliderState(
      this.sliderField, this.color, this.adventureDoc, this.playerData);

  double _value = 0, _xp = 0;
  final StreamController<double> _streamXpController =
      StreamController<double>();
  final StreamController<double> _streamHpController =
      StreamController<double>();

  @override
  void dispose() {
    _streamXpController.close();
    _streamHpController.close();
    super.dispose();
  }

  void _incrementSlider() {}

  double _hpaux, _xpaux;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AdventureModel>(
      builder: (context, child, adventureModel) {
        return StreamBuilder<DocumentSnapshot>(
          stream: adventureModel.playerCharacterStream(
              adventureDoc["adventureId"], playerData["characterId"]),
          builder: (context, adventureData) {
            switch (adventureData.connectionState) {
              case ConnectionState.waiting:
                return Container(
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
                              sliderField.toUpperCase(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: Colors.white),
                            ),
                            SliderTheme(
                              data: Theme.of(context).sliderTheme.copyWith(
                                  trackHeight: 10,
                                  activeTrackColor: color,
                                  inactiveTrackColor: Colors.white30,
                                  thumbColor: Colors.white,
                                  thumbShape: RoundSliderThumbShape(
                                      enabledThumbRadius: 10)),
                              child: Flexible(
                                child: Slider(
                                  min: 0,
                                  max: 100,
                                  value: _value,
                                ),
                              ),
                            ),
                            Container(
                              width: 40,
                              child: Text(
                                _value.toInt().toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              default:
                if (adventureData.data == null) {
                  return Container(
                    child: Center(
                      child: Text(
                        "data error",
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
                    margin: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    child: StreamBuilder<double>(
                      initialData: adventureData.data[sliderField].toDouble(),
                      stream: _streamHpController.stream,
                      builder: (context, sliderSnapshot) {
                        return Container(
                          child: Row(
                            mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                sliderField.toUpperCase(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                              SliderTheme(
                                data: Theme.of(context).sliderTheme.copyWith(
                                    trackHeight: 10,
                                    activeTrackColor: color,
                                    inactiveTrackColor: Colors.white30,
                                    thumbColor: Colors.white,
                                    thumbShape: RoundSliderThumbShape(
                                        enabledThumbRadius: 10)),
                                child: Flexible(
                                  child: Slider(
                                    min: 0,
                                    max: 100,
                                    value: sliderSnapshot.data != adventureData.data[sliderField] ?
                                            adventureData.data[sliderField].toInt().toDouble() : sliderSnapshot.data,
                                    onChangeEnd: (value) async {
                                      print(value);
                                      Map<String, dynamic> aMap = Map();
                                      aMap[sliderField] = value.toInt();
                                      await Firestore.instance
                                          .collection("adventures")
                                          .document(adventureDoc["adventureId"])
                                          .collection("players")
                                          .document(playerData["characterId"])
                                          .updateData(aMap);
                                    },
                                    onChanged: (value) {
                                      _value = value;
                                      _streamHpController.sink.add(_value);
                                    },
                                  ),
                                ),
                              ),
                              Text(
                                sliderSnapshot.data != adventureData.data[sliderField]?
                                adventureData.data[sliderField].toString() : sliderSnapshot.data.toInt().toString() ,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }
            }
          },
        );
      },
    );
  }
}
