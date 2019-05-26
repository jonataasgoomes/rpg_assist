import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:rpg_assist_app/models/adventure_model.dart';
import 'package:scoped_model/scoped_model.dart';

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
    return ScopedModelDescendant<AdventureModel>(
          builder: (context,child,adventureModel){
            return FutureBuilder<QuerySnapshot>(
                future: adventureModel.masterAdventure(adventureDoc),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Container(color: Colors.blue);
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
                                    fontFamily: "IndieFlower",
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
                      if (snapshot.hasError)
                        return Text(
                          'Error to loading: ${snapshot.error}',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        );
                      else if (snapshot.data.documents.length == 0) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(top: 120),
                                child: Text(
                                  "Who is the master ?",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "IndieFlower",
                                      color: Color.fromARGB(255, 234, 205, 125),
                                      fontSize: 20),
                                  textAlign: TextAlign.center,
                                )),
                          ],
                        );
                      } else {
                        return ListView(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.all(40),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    adventureDoc
                                                    ["summary"],
                                                    maxLines: 6,
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
                                    onTap: (){},
                                    child: Row(
                                      children: <Widget>[
                                        Text("see more",
                                          style: TextStyle(
                                          ),
                                        ),
                                        Icon(Icons.arrow_drop_down)
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                  }
                }
            );
          },
        );

  }


}
