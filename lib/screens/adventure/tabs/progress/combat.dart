import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rpg_assist_app/models/adventure_model.dart';
import 'package:rpg_assist_app/screens/adventure/tabs/player/widgets/dice_roll.dart';
import 'package:scoped_model/scoped_model.dart';

class Combat extends StatefulWidget {
  final DocumentSnapshot adventureDoc;
  final Map<String, dynamic> userLogged;
  final String sessionId;

  Combat(this.adventureDoc,this.sessionId ,this.userLogged);

  @override
  _CombatState createState() => _CombatState(adventureDoc,sessionId ,userLogged);
}

class _CombatState extends State<Combat> {
  Random seed = Random();
  int rand = 0;
  String anim = "Spin1";
  bool isPaused = true;
  bool animating = false;
  final DocumentSnapshot adventureDoc;
  final Map<String, dynamic> userLogged;
  final String sessionId;

  _CombatState(this.adventureDoc,this.sessionId ,this.userLogged);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 34, 17, 51),
        title: Image.asset(
          "images/logo.png",
          height: 20,
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Color.fromARGB(255, 234, 205, 125)),
        actions: <Widget>[PopupMenuButton(itemBuilder: (_) {})],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 34, 17, 51),
                  Color.fromARGB(255, 44, 100, 124),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                DiceRoll(adventureDoc,sessionId ,userLogged),
                ScopedModelDescendant<AdventureModel>(
                  builder: (context, child, adventureModel) {
                    return StreamBuilder<QuerySnapshot>(
                      stream:
                      adventureModel.rollsAdventure(adventureDoc["adventureId"],sessionId,),
                      builder: (context, rolls) {
                        switch (rolls.connectionState) {
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
                            if (rolls.data.documents.isEmpty) {
                              return Container(
                                margin: EdgeInsets.all(50),
                                child: Center(
                                  child: Text(
                                    "No dice rolls yet",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 6, 223, 176)),
                                  ),
                                ),
                              );
                            } else {
                              return ListView.builder(
                                itemExtent: 100.0,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: rolls.data.documents.length,
                                itemBuilder: (context, index) {
                                  return FutureBuilder<DocumentSnapshot>(
                                    future: adventureModel.playerCharacter(adventureDoc["adventureId"],rolls.data.documents[index]["userId"]),
                                    builder: (context,playerDoc){
                                      switch (playerDoc.connectionState){
                                        case ConnectionState.waiting:
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        default:
                                          if(rolls.data.documents[index]["userId"] == adventureDoc["master"]){
                                            return Card(
                                              color: Colors.white54,
                                              margin: EdgeInsets.fromLTRB(10, 5, 10,0),
                                              child: Padding(
                                                padding: const EdgeInsets.all(5),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex: 0,
                                                      child: Container(
                                                        margin: EdgeInsets.only(right: 25),
                                                        width: 65.0,
                                                        height: 65.0,
                                                        decoration:
                                                        BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          image: DecorationImage(
                                                            fit: BoxFit.fill,
                                                            image:AssetImage(
                                                                "images/crowns.png"),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          Expanded(
                                                            flex:2,
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8),
                                                              child: Column(
                                                                mainAxisSize: MainAxisSize.min,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: <Widget>[
                                                                  Text(
                                                                    "Master",
                                                                    style: const TextStyle(
                                                                      fontSize: 20.0,
                                                                    ),
                                                                  ),
                                                                  Text(DateFormat.yMMMd().format(rolls.data.documents[index]["timestamp"]).toString()),
                                                                  Text(DateFormat.jms().format(rolls.data.documents[index]["timestamp"]).toString()),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child: Wrap(

                                                              alignment: WrapAlignment.spaceEvenly,
                                                              direction: Axis.horizontal,
                                                              children: <Widget>[
                                                                Padding(
                                                                  padding: EdgeInsets.all(5.0),
                                                                  child: Text("Roll:",
                                                                    style: TextStyle(fontSize: 30),
                                                                  ),
                                                                ),
                                                                Text(rolls.data.documents[index]["result"].toString(),
                                                                  style: TextStyle(fontSize: 40),
                                                                ),
                                                              ],
                                                            ),
                                                          ),

                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          }else{
                                            return Card(
                                              color: Colors.white54,
                                              margin: EdgeInsets.fromLTRB(10, 5, 10,0),
                                              child: Padding(
                                                padding: const EdgeInsets.all(5.0),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex: 0,
                                                      child: Container(
                                                        width: 65.0,
                                                        height: 65.0,
                                                        decoration:
                                                        BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          image: DecorationImage(
                                                            fit: BoxFit.fill,
                                                            image: playerDoc
                                                                .data["raceNumber"] != 404
                                                                ? AssetImage(
                                                                "images/race${playerDoc
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
                                                                image: playerDoc
                                                                    .data["classNumber"] != 404
                                                                    ? AssetImage(
                                                                    "images/class${playerDoc
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
                                                                image: playerDoc
                                                                    .data["sexNumber"] != 404
                                                                    ? AssetImage(
                                                                    "images/sex${playerDoc
                                                                        .data["sexNumber"]}.png")
                                                                    : AssetImage(
                                                                    "images/rpg_icon.png"),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          Expanded(
                                                            flex:2,
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Column(
                                                                mainAxisSize: MainAxisSize.min,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: <Widget>[
                                                                  Text(
                                                                    playerDoc.data["name"] == ""? "unnamed" :playerDoc.data["name"],
                                                                    style: const TextStyle(
                                                                      fontSize: 20.0,
                                                                    ),
                                                                  ),
                                                                  Text(DateFormat.yMMMd().format(rolls.data.documents[index]["timestamp"]).toString()),
                                                                  Text(DateFormat.jms().format(rolls.data.documents[index]["timestamp"]).toString()),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child: Wrap(

                                                              alignment: WrapAlignment.spaceEvenly,
                                                              direction: Axis.horizontal,
                                                              children: <Widget>[
                                                                Padding(
                                                                  padding: EdgeInsets.all(5.0),
                                                                  child: Text("Roll:",
                                                                    style: TextStyle(fontSize: 30),
                                                                  ),
                                                                ),
                                                                Text(rolls.data.documents[index]["result"].toString(),
                                                                  style: TextStyle(fontSize: 40),
                                                                ),
                                                              ],
                                                            ),
                                                          ),

                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
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
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
