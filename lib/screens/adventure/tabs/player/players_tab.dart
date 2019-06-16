import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:rpg_assist_app/models/adventure_model.dart';
import 'package:rpg_assist_app/models/user_model.dart';
import 'package:rpg_assist_app/screens/adventure/tabs/player/player_screen.dart';
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
        backgroundColor: Color.fromARGB(255, 226, 226, 225),
        body: ScopedModelDescendant<AdventureModel>(
          builder: (context, child, adventureModel) {
            return ListView(
              children: <Widget>[
                FutureBuilder<QuerySnapshot>(
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
                            return Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(width: 0.5))),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.all(20),
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: snapshot.data
                                                                .documents[0]
                                                            ["photoUrl"] !=
                                                        null
                                                    ? NetworkImage(snapshot
                                                            .data.documents[0]
                                                        ["photoUrl"])
                                                    : AssetImage(
                                                        "images/rpg_icon.png"),
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
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      snapshot.data.documents[0]
                                                                  ["name"] !=
                                                              null
                                                          ? snapshot.data
                                                                  .documents[0]
                                                              ["name"]
                                                          : snapshot.data.documents[
                                                                          0][
                                                                      "username"] !=
                                                                  null
                                                              ? snapshot.data
                                                                      .documents[
                                                                  0]["username"]
                                                              : "",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        fontWeight:
                                                            FontWeight.w200,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Text(
                                                  snapshot.data.documents[0]
                                                              ["masterTitle"] !=
                                                          null
                                                      ? snapshot
                                                              .data.documents[0]
                                                          ["masterTitle"]
                                                      : "",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ScopedModelDescendant<UserModel>(
                                    builder: (context,child,userModel){
                                      return StreamBuilder(
                                          stream: adventureModel.adventuresPlayers(adventureId: adventureDoc["adventureId"]),
                                          builder: (context, snapshot) {
                                            switch (snapshot.connectionState) {
                                              case ConnectionState.waiting:
                                                return Container(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.stretch,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                      children: <Widget>[
                                                        Container(
                                                            margin: EdgeInsets.only(top: 70),
                                                            child: Text(
                                                              "Loading ...",
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  fontFamily: "IndieFlower",
                                                                  color: Color.fromARGB(
                                                                      255, 234, 205, 125),
                                                                  fontSize: 20),
                                                              textAlign: TextAlign.center,
                                                            )),
                                                        Container(
                                                          margin: EdgeInsets.only(top: 20),
                                                          width: 80,
                                                          height: 80,
                                                          alignment: Alignment.center,
                                                          child: FlareActor(
                                                              "assets/Dice_Loading.flr",
                                                              animation: "loading"),
                                                        )
                                                      ],
                                                    ));
                                              default:
                                                if (snapshot.data.documents.isNotEmpty) {
                                                  return ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                    NeverScrollableScrollPhysics(),
                                                    itemCount:
                                                    snapshot.data.documents.length,
                                                    itemBuilder: (context, index) {
                                                      return FutureBuilder<
                                                          DocumentSnapshot>(
                                                        future: userModel.userTeste(
                                                            snapshot.data.documents[index]
                                                            ["userId"]),
                                                        builder: (context, snapshot) {
                                                          switch (
                                                          snapshot.connectionState) {
                                                            case ConnectionState.waiting:
                                                              return Container();
                                                            default:
                                                              if (snapshot.hasError) {
                                                                Text("Error");
                                                              } else {
                                                                return InkWell(
                                                                  onTap: (){
                                                                    return Navigator.push(context, MaterialPageRoute(
                                                                        builder: (context)=> PlayerScreen(adventureDoc,snapshot.data,user)));
                                                                  },
                                                                  child: Container(
                                                                    child: Column(
                                                                      children: <Widget>[
                                                                        SizedBox(
                                                                          height: 10,
                                                                        ),
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Container(
                                                                              margin: EdgeInsets.symmetric(horizontal: 25),
                                                                              width: 45.0,
                                                                              height: 45.0,
                                                                              decoration:
                                                                              BoxDecoration(
                                                                                  shape: BoxShape
                                                                                      .circle,
                                                                                  image:
                                                                                  DecorationImage(
                                                                                    fit:
                                                                                    BoxFit.fill,
                                                                                    image: snapshot.data["photoUrl"] != null
                                                                                        ? NetworkImage(snapshot.data["photoUrl"])
                                                                                        : AssetImage("images/rpg_icon.png"),
                                                                                  )),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Column(
                                                                              crossAxisAlignment:
                                                                              CrossAxisAlignment
                                                                                  .start,
                                                                              children: <
                                                                                  Widget>[
                                                                                Text(
                                                                                  snapshot.data["name"] !=
                                                                                      null
                                                                                      ? snapshot.data[
                                                                                  "name"]
                                                                                      : snapshot.data["username"] != null
                                                                                      ? snapshot.data["username"]
                                                                                      : snapshot.data["email"],
                                                                                  maxLines:
                                                                                  1,
                                                                                  overflow:
                                                                                  TextOverflow
                                                                                      .ellipsis,
                                                                                  style: TextStyle(
                                                                                      fontWeight: FontWeight
                                                                                          .bold,
                                                                                      fontSize:
                                                                                      15),
                                                                                ),
                                                                              ],
                                                                            )
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height: 10,
                                                                        ),
                                                                        SizedBox(
                                                                          height: 0.3,
                                                                          child: Center(
                                                                            child:
                                                                            Container(
                                                                              margin: EdgeInsetsDirectional
                                                                                  .only(
                                                                                  start:
                                                                                  1.0,
                                                                                  end:
                                                                                  1.0),
                                                                              color: Colors
                                                                                  .black,
                                                                            ),
                                                                          ),
                                                                        ),
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
                                                } else {
                                                  return Container(
                                                    margin: EdgeInsets.all(50),
                                                    child: Center(
                                                      child: Text(
                                                        "Adventure doesn´t have any players yet",
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.bold,
                                                            fontFamily: "IndieFlower",
                                                            color: Color.fromARGB(255, 6, 223, 176)),
                                                      ),
                                                    ),
                                                  );
                                                }
                                            }
                                          });
                                    },
                                  )
                                ],
                              ),
                            );
                          }
                      }
                    }),
              ],
            );
          },
        ));
  }
}
