import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:rpg_assist_app/models/adventure_model.dart';
import 'package:rpg_assist_app/models/user_model.dart';
import 'package:rpg_assist_app/screens/adventure/tabs/player/character_view.dart';
import 'package:rpg_assist_app/screens/adventure/tabs/player/player_screen.dart';
import 'package:rpg_assist_app/screens/users/friends/friends_list.dart';
import 'package:rpg_assist_app/widgets/popup_menu.dart';
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
     floatingActionButton: Visibility(
    visible: adventureDoc["master"] == user["id"],
      child: Container(
        width: 80.0,
        height: 80.0,
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) =>
                        FriendList(adventureDoc["adventureId"])));
          },
          child: Container(
            child:
            Image.asset("images/add_player.png"),
          ),
        ),
      ),
    ),
      backgroundColor: Colors.transparent,
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
                                  color: Color.fromARGB(255, 234, 205, 125),
                                  fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            child: FlareActor("assets/Dice_Loading.flr",
                                animation: "loading"),
                          ),
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
                                    color: Color.fromARGB(255, 234, 205, 125),
                                    fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        );
                      } else {
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Card(
                                child: ListTile(
                                  contentPadding: EdgeInsets.only(right: 20),
                                  leading: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 25),
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: snapshot.data.documents[0]
                                                      ["photoUrl"] !=
                                                  null
                                              ? NetworkImage(snapshot.data
                                                  .documents[0]["photoUrl"])
                                              : AssetImage(
                                                  "images/rpg_icon.png"),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  title: Row(
                                    children: <Widget>[
                                      Text(
                                        "Mestre ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Flexible(
                                        child: Text(
                                          snapshot.data.documents[0]["name"] !=
                                                  null
                                              ? snapshot.data.documents[0]
                                                  ["name"]
                                              : snapshot.data.documents[0]
                                                          ["username"] !=
                                                      null
                                                  ? snapshot.data.documents[0]
                                                      ["username"]
                                                  : "",
                                          softWrap: true,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w200,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: Text(
                                    snapshot.data.documents[0]["masterTitle"] !=
                                            null
                                        ? snapshot.data.documents[0]
                                            ["masterTitle"]
                                        : "",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  isThreeLine: true,
                                ),
                              ),
                              ScopedModelDescendant<UserModel>(
                                builder: (context, child, userModel) {
                                  return StreamBuilder(
                                      stream: adventureModel.adventuresPlayers(
                                          adventureId:
                                              adventureDoc["adventureId"]),
                                      builder: (context, playerSnapshot) {
                                        switch (
                                            playerSnapshot.connectionState) {
                                          case ConnectionState.waiting:
                                            return Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: 70),
                                                    child: Text(
                                                      "Loading ...",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color.fromARGB(
                                                              255,
                                                              234,
                                                              205,
                                                              125),
                                                          fontSize: 20),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: 20),
                                                    width: 80,
                                                    height: 80,
                                                    alignment: Alignment.center,
                                                    child: FlareActor(
                                                        "assets/Dice_Loading.flr",
                                                        animation: "loading"),
                                                  ),
                                                ],
                                              ),
                                            );
                                          default:
                                            if (playerSnapshot
                                                .data.documents.isNotEmpty) {
                                              return Container(
                                                margin: playerSnapshot.data.documents.length >= 1? EdgeInsets.only(bottom: 100): EdgeInsets.only(bottom: 0) ,
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemCount: playerSnapshot
                                                      .data.documents.length,
                                                  itemBuilder: (context, index) {
                                                    return FutureBuilder<
                                                        DocumentSnapshot>(
                                                      future: userModel.userTeste(
                                                          playerSnapshot
                                                                  .data.documents[
                                                              index]["userId"]),
                                                      builder:
                                                          (context, snapshot) {
                                                        switch (snapshot
                                                            .connectionState) {
                                                          case ConnectionState
                                                              .waiting:
                                                            return Container();
                                                          default:
                                                            if (snapshot
                                                                .hasError) {
                                                              Text("Error");
                                                            } else {
                                                              return InkWell(
                                                                onTap: () {
                                                                  if ((adventureDoc["master"] == user["id"]) | (user["id"] == playerSnapshot.data.documents[index]["userId"])) {
                                                                    return Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder: (context) => PlayerScreen(
                                                                            adventureDoc,
                                                                            snapshot
                                                                                .data,
                                                                            user,
                                                                            playerSnapshot
                                                                                .data
                                                                                .documents[index]),
                                                                      ),
                                                                    );
                                                                  } else {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) => CharacterView(
                                                                                adventureDoc,
                                                                                snapshot.data,
                                                                                user,
                                                                                playerSnapshot.data.documents[index])));
                                                                  }
                                                                },
                                                                child: Container(
                                                                  child: Card(
                                                                    child: Center(
                                                                      child:
                                                                          ListTile(
                                                                        contentPadding:
                                                                            EdgeInsets.all(
                                                                                0),
                                                                        leading:
                                                                            Container(
                                                                          margin: EdgeInsets.symmetric(
                                                                              horizontal:
                                                                                  25),
                                                                          width:
                                                                              45.0,
                                                                          height:
                                                                              45.0,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            image:
                                                                                DecorationImage(
                                                                              fit:
                                                                                  BoxFit.fill,
                                                                              image: snapshot.data["photoUrl"] != null
                                                                                  ? NetworkImage(snapshot.data["photoUrl"])
                                                                                  : AssetImage("images/rpg_icon.png"),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        title:
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
                                                                              TextOverflow.ellipsis,
                                                                          style: TextStyle(
                                                                              fontWeight:
                                                                                  FontWeight.bold,
                                                                              fontSize: 15),
                                                                        ),
                                                                        trailing: (adventureDoc["master"] == user["id"]) | (user["id"] == playerSnapshot.data.documents[index]["userId"]) ?
                                                                            PopupMenuButton<
                                                                                String>(
                                                                          onSelected: (String choice){
                                                                            adventureModel.
                                                                            choiceActionAdventure(choice,
                                                                                adventureDoc["adventureId"],
                                                                                playerSnapshot.data.documents[index]["characterId"],
                                                                                playerSnapshot.data.documents[index]["userId"],
                                                                                adventureDoc["master"],
                                                                                this.context
                                                                            );
                                                                          },
                                                                          itemBuilder:(context) {
                                                                            if(adventureDoc["master"] == user["id"]){
                                                                              return PopupMenuMaster.choices.map((choice){
                                                                                return PopupMenuItem<String>(
                                                                                  value: choice,
                                                                                  child: Text(choice),
                                                                                );
                                                                              },).toList();
                                                                            }else if (user["id"] == playerSnapshot.data.documents[index]["userId"]){
                                                                              return PopupMenuPlayer.choices.map((choice){
                                                                                return PopupMenuItem<String>(
                                                                                  value: choice,
                                                                                  child: Text(choice),
                                                                                );
                                                                              },).toList();
                                                                            }
                                                                          },
                                                                        ): IconButton(icon: Icon(Icons.person_outline), onPressed: null),
                                                                        subtitle:
                                                                            Text(snapshot.data["masterTitle"] != null ? snapshot.data["masterTitle"] : "",
                                                                          maxLines:1,
                                                                          overflow: TextOverflow.ellipsis,),
                                                                        isThreeLine:
                                                                            true,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                        }
                                                      },
                                                    );
                                                  },
                                                ),
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Color.fromARGB(
                                                            255, 6, 223, 176)),
                                                  ),
                                                ),
                                              );
                                            }
                                        }
                                      });
                                },
                              ),
                            ],
                          ),
                        );
                      }
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
