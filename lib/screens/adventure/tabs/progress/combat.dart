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
  final int sessionStatus;

  Combat(this.adventureDoc,this.sessionId ,this.userLogged,this.sessionStatus);

  @override
  _CombatState createState() => _CombatState(adventureDoc,sessionId ,userLogged,sessionStatus);
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
  final int sessionStatus;
  final GlobalKey<ScaffoldState> _scaffoldKeyCombat = new GlobalKey<ScaffoldState>();

  _CombatState(this.adventureDoc,this.sessionId ,this.userLogged,this.sessionStatus);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKeyCombat,
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
                sessionStatus != 2 ?
                DiceRoll(adventureDoc,sessionId ,userLogged)
                    : Container(),
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
                          case ConnectionState.waiting:
                            return Center(
                              child: Text("Loading..."),
                            );
                          default:
                            if (rolls.data.documents.isEmpty) {
                              return Container(
                                margin: EdgeInsets.all(50),
                                child: Center(
                                  child: Text(
                                    "No dice rolls yet, tap on dice",
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
                                itemExtent: 113.0,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: rolls.data.documents.length,
                                itemBuilder: (context, index) {
                                  return Dismissible(
                                    direction: DismissDirection.startToEnd,
                                      onDismissed: (direction){
                                        if(direction == DismissDirection.startToEnd && adventureDoc["master"] == userLogged["id"] ){
                                          print("startToEndDismiss");
                                        }
                                      },
                                    confirmDismiss: (direction) async {
                                        if(adventureDoc["master"] == userLogged["id"]){
                                          final bool result = await showDialog(
                                              context: context,
                                              builder: (context){
                                                return AlertDialog(
                                                  title: Text("confirm delete".toUpperCase()),
                                                  content: Text("Are you sure you wish to delete this result? this is irreversible! "),
                                                  actions: <Widget>[
                                                    FlatButton(onPressed: () => Navigator.of(context).pop(false),
                                                        child: const Text("CANCEL")
                                                    ),

                                                    FlatButton(
                                                      onPressed: () => Navigator.of(context).pop(true),
                                                      child: const Text("DELETE",style: TextStyle(color: Colors.red),),)
                                                  ],
                                                );
                                              }
                                          );
                                          if (result){
                                            _scaffoldKeyCombat.currentState.showSnackBar(SnackBar(content: Text("Successfully removed")));
                                          }else{
                                            return result;
                                          }
                                        }
                                    },
                                      key: Key(rolls.data.documents[index].toString()),
                                      child: FutureBuilder<DocumentSnapshot>(
                                        future: adventureModel.playerCharacter(adventureDoc["adventureId"],rolls.data.documents[index]["userId"]),
                                        builder: (context,playerDoc){
                                          switch (playerDoc.connectionState){
                                            case ConnectionState.waiting:
                                              return Center(
                                                child: CircularProgressIndicator(),
                                              );
                                            case ConnectionState.none:
                                              return Center(
                                                child: Text("INTERNET DISCONNECTED"),
                                              );
                                            case ConnectionState.active:
                                              return Center(
                                                child: Text("Connection Active"),
                                              );
                                            case ConnectionState.done:
                                              if (playerDoc.hasError) {
                                                return Text("Data Error");
                                              }if(!playerDoc.data.exists){
                                                if(adventureDoc["master"] == rolls.data.documents[index]["userId"]){
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
                                                                        rolls.data.documents[index]["timestamp"] != null?
                                                                        Text(DateFormat.yMMMd().format(rolls.data.documents[index]["timestamp"]).toString()): Text("Loading ..."),
                                                                        rolls.data.documents[index]["timestamp"] != null?
                                                                        Text(DateFormat.jms().format(rolls.data.documents[index]["timestamp"]).toString()): Text("Loading ..."),
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
                                                                      "images/rip_player.png"),
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
                                                                          "RIP",
                                                                          style: const TextStyle(
                                                                            fontSize: 20.0,
                                                                          ),
                                                                        ),
                                                                        rolls.data.documents[index]["timestamp"] != null?
                                                                        Text(DateFormat.yMMMd().format(rolls.data.documents[index]["timestamp"]).toString()): Text("Loading ..."),
                                                                        rolls.data.documents[index]["timestamp"] != null?
                                                                        Text(DateFormat.jms().format(rolls.data.documents[index]["timestamp"]).toString()): Text("Loading ..."),
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
                                              }else{
                                                if(adventureDoc["master"] == rolls.data.documents[index]["userId"]){
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
                                                                    padding: const EdgeInsets.all(8),
                                                                    child: Column(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: <Widget>[
                                                                        Text( playerDoc.data["name"] == null ?
                                                                        "Master" : "Mestre ${playerDoc.data["name"]}",
                                                                          maxLines: 2,
                                                                          style: const TextStyle(
                                                                            fontSize: 20.0,
                                                                          ),
                                                                        ),
                                                                        rolls.data.documents[index]["timestamp"] != null?
                                                                        Text(DateFormat.yMMMd().format(rolls.data.documents[index]["timestamp"]).toString()): Text("Loading ..."),
                                                                        rolls.data.documents[index]["timestamp"] != null?
                                                                        Text(DateFormat.jms().format(rolls.data.documents[index]["timestamp"]).toString()): Text("Loading ..."),
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
                                                                          playerDoc.data["name"] == ""? "Unnamed" :playerDoc.data["name"],
                                                                          maxLines: 2,
                                                                          style: const TextStyle(
                                                                            fontSize: 20.0,
                                                                          ),
                                                                        ),
                                                                        rolls.data.documents[index]["timestamp"] != null?
                                                                        Text(DateFormat.yMMMd().format(rolls.data.documents[index]["timestamp"]).toString()): Text("Loading ..."),
                                                                        rolls.data.documents[index]["timestamp"] != null?
                                                                        Text(DateFormat.jms().format(rolls.data.documents[index]["timestamp"]).toString()): Text("Loading ..."),
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
                                          }
                                        },
                                      ),
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
