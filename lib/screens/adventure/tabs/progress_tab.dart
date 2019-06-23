import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rpg_assist_app/models/adventure_model.dart';
import 'package:scoped_model/scoped_model.dart';

import '../new_session_screen.dart';

class ProgressTab extends StatefulWidget {
  final Map<String, dynamic> user;
  final DocumentSnapshot adventureDoc;

  ProgressTab(this.user, this.adventureDoc);

  @override
  _ProgressTabState createState() => _ProgressTabState(user, adventureDoc);
}

class _ProgressTabState extends State<ProgressTab> {
  int seeMore = 6;
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
        margin: EdgeInsets.only(top: 20, left: 40, right: 40, bottom: 20),
        child: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                adventureDoc["summary"] != null
                                    ? adventureDoc["summary"]
                                    : "Add summary on this adventure ",
                                maxLines: seeMore,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (seeMore == 6) {
                        seeMore = 20;
                      } else {
                        seeMore = 6;
                      }
                    });
                  },
                  child: Row(
                    children: <Widget>[
                      Text(
                        seeMore <= 6 ? "see more" : "see less",
                        style: TextStyle(color: Color.fromARGB(255, 6, 223, 176)),
                      ),
                      Icon(
                        seeMore <= 6
                            ? Icons.arrow_drop_down
                            : Icons.arrow_drop_up,
                        color: Color.fromARGB(255, 6, 223, 176),
                      )
                    ],
                  ),
                ),
              ],
            ),
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
                          return Column(
                              children: snapshot.data.documents.map((document) {
                                return Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Column(
                                    children: <Widget>[
                                      Divider(
                                        color: Colors.black,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            document["date"] != null
                                                ? DateFormat.Md()
                                                .format(document["date"])
                                                : "",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            document["title"] != null
                                                ? document["title"]
                                                : "No title session",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              }).toList());
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
