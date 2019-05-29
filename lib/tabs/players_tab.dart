import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:rpg_assist_app/models/adventure_model.dart';
import 'package:scoped_model/scoped_model.dart';

class PlayersTab extends StatefulWidget {
  final Map<String, dynamic> user;
  final DocumentSnapshot adventureDoc;

  PlayersTab(this.user, this.adventureDoc);

  @override
  _PlayersTabState createState() => _PlayersTabState(user, adventureDoc);
}

class _PlayersTabState extends State<PlayersTab> {
  final Map<String, dynamic> user;
  final DocumentSnapshot adventureDoc;

  _PlayersTabState(this.user, this.adventureDoc);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 226, 226, 225) ,
      floatingActionButton: Container(
          width: 80.0,
          height: 80.0,
          child: FloatingActionButton(
            backgroundColor: Colors.transparent,
            onPressed: () {},
            child: Container(
              child: Image.asset("images/add_player.png"),
            ),
          )),
      body: ScopedModelDescendant<AdventureModel>(
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                               Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(width: 0.5
                                            )
                                        )
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.all(20),
                                          width: 55,
                                          height: 55,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: snapshot
                                                    .data
                                                    .documents[0]["photoUrl"] != null? NetworkImage(snapshot
                                                    .data.documents[0]["photoUrl"]): AssetImage("images/rpg_icon.png") ,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(right: 25),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Text(
                                                      "Mestre",
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                    Text(
                                                      snapshot.data.documents[0]
                                                      ["name"],
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontStyle: FontStyle.italic,
                                                        fontWeight: FontWeight.w200,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Text(
                                                  snapshot.data.documents[0]
                                                  ["masterTitle"],
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

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
      )
    );
  }


}
