import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rpg_assist_app/models/adventure_model.dart';
import 'package:rpg_assist_app/screens/adventure/new_session_screen.dart';
import 'package:rpg_assist_app/screens/adventure/tabs/progress/widgets/summary.dart';
import 'package:scoped_model/scoped_model.dart';

import 'combat.dart';



class ProgressTab extends StatefulWidget {
  final Map<String, dynamic> user;
  final DocumentSnapshot adventureDoc;

  ProgressTab(this.user, this.adventureDoc);

  @override
  _ProgressTabState createState() => _ProgressTabState(user, adventureDoc);
}

class _ProgressTabState extends State<ProgressTab> {
  final Map<String, dynamic> user;
  final DocumentSnapshot adventureDoc;

  _ProgressTabState(this.user, this.adventureDoc);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Visibility(
    visible: adventureDoc["master"] == user["id"],
      child: Container(
          width: 70.0,
          height: 70.0,
          child: FloatingActionButton(
            backgroundColor: Colors.transparent,
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) =>
                          NewSessionScreen(
                              adventureDoc)));
            },
            child: Container(
              child:
              Image.asset("images/new_session.png"),
            ),
          )),
    ),
      backgroundColor: Colors.transparent,
      body: Container(
        margin: EdgeInsets.only(top: 20, left: 30, right: 30,bottom: 20),
        child: ListView(
          children: <Widget>[
            Summary(adventureDoc),
            ScopedModelDescendant<AdventureModel>(
              builder: (context, child, adventureModel) {
                return StreamBuilder<QuerySnapshot>(
                    stream: adventureModel.sessionsAdventure(adventureDoc),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  child: Text(
                                    "Loading ...",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 234, 205, 125),
                                        fontSize: 20),
                                    textAlign: TextAlign.center,
                                  )),
                              Container(
                                width: 50,
                                height: 50,
                                alignment: Alignment.center,
                                child: FlareActor("assets/Dice_Loading.flr",
                                    animation: "loading"),
                              )
                            ],
                          );
                        default:
                          return Container(
                            margin: EdgeInsets.only(bottom: 100),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                                children: snapshot.data.documents.map((document) {
                                  return InkWell(
                                    onTap: document["status"] != 0 || adventureDoc["master"] == user["id"]? (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Combat(adventureDoc,document["sessionId"],user,document["status"])));
                                    }:null,
                                    child: Container(
                                      child: Column(
                                        children: <Widget>[
                                          Divider(
                                            color: Colors.black,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex:0,
                                                child: Text(
                                                  document["date"] != null
                                                      ? DateFormat.Md()
                                                      .format(document["date"])
                                                      : "",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                              flex:2,
                                                child: Container(
                                                  margin: EdgeInsets.only(left: 10),
                                                  child: Text(
                                                    document["title"] != null
                                                        ? document["title"]
                                                        : "No title session",
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex:0,
                                                child: Container(
                                                  width: 30.0,
                                                  height: 30.0,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: document["status"] == 0
                                                            ? AssetImage("images/session_status${document["status"]}.png")
                                                            : document["status"] == 1 ?
                                                              AssetImage("images/session_status${document["status"]}.png")
                                                            : document["status"] == 2 ?
                                                              AssetImage("images/session_status${document["status"]}.png")
                                                            : AssetImage("images/rpg_icon.png"),
                                                      ),),
                                                ),),

                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList()),
                          );
                      }
                    });
              },
            )
          ],
        ),
      )
    );
  }
}
