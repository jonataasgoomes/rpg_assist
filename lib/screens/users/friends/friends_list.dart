import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:rpg_assist_app/models/adventure_model.dart';
import 'package:rpg_assist_app/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class FriendList extends StatefulWidget {
  final String adventureId;

  FriendList(this.adventureId);

  @override
  _FriendListState createState() => _FriendListState(adventureId);
}

class _FriendListState extends State<FriendList> {
  String adventureId;

  _FriendListState(this.adventureId);

  Widget _buildBodyBack() => Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 34, 17, 51),
            Color.fromARGB(255, 44, 100, 124)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Friend's list",
            style: TextStyle(color: Color.fromARGB(255, 234, 205, 125)),
          ),
          backgroundColor: Color.fromARGB(255, 34, 17, 51),
          iconTheme: IconThemeData(color: Color.fromARGB(255, 234, 205, 125)),
        ),
        body: Stack(
          children: <Widget>[
            _buildBodyBack(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: ScopedModelDescendant<UserModel>(
                builder: (context, child, userModel) {
                  return ScopedModelDescendant<AdventureModel>(
                    builder: (context, child, adventureModel) {
                      return FutureBuilder<QuerySnapshot>(
                          future: userModel
                              .getUserFriends(userModel.userData["id"]),
                          builder: (context, userSnapshot) {
                            switch (userSnapshot.connectionState) {
                              case ConnectionState.waiting:
                                return Container(
                                    child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                        margin: EdgeInsets.only(top: 70),
                                        child: Text(
                                          "Loading ...",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
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
                                if (userSnapshot.data.documents.isNotEmpty) {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: userSnapshot.data.documents.length,
                                    itemBuilder: (context, index) {
                                      return FutureBuilder<DocumentSnapshot>(
                                        future: userModel.userTeste(userSnapshot
                                            .data.documents[index]["friend"]),
                                        builder: (context, snapshot) {
                                          switch (snapshot.connectionState) {
                                            case ConnectionState.waiting:
                                              return Container();
                                            default:
                                              if (snapshot.hasError) {
                                                Text("Error");
                                              } else {
                                                return Container(
                                                  margin:
                                                      EdgeInsets.only(top: 10),
                                                  child: Column(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: <Widget>[
                                                          Container(
                                                            width: 50.0,
                                                            height: 50.0,
                                                            decoration:
                                                                BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    image:
                                                                        DecorationImage(
                                                                      fit: BoxFit
                                                                          .fill,
                                                                      image: snapshot.data["photoUrl"] !=
                                                                              null
                                                                          ? NetworkImage(snapshot.data[
                                                                              "photoUrl"])
                                                                          : AssetImage(
                                                                              "images/rpg_icon.png"),
                                                                    )),
                                                          ),
                                                          Flexible(
                                                            child: Container(
                                                              width: 150,
                                                              child: Text(
                                                                snapshot.data["name"] !=
                                                                        null
                                                                    ? snapshot
                                                                            .data[
                                                                        "name"]
                                                                    : snapshot.data["username"] !=
                                                                            null
                                                                        ? snapshot.data[
                                                                            "username"]
                                                                        : snapshot
                                                                            .data["email"],
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        15),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 100,
                                                            child: RaisedButton(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                              ),
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      6,
                                                                      223,
                                                                      176),
                                                              onPressed: () {
                                                                adventureModel.addPlayersOnAdventure(adventureId: adventureId,
                                                                userId: snapshot.data["id"]).then((e){
                                                                  Navigator.pop(context);
                                                                });


                                                              },
                                                              child: Text(
                                                                "ADD",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      SizedBox(
                                                        height: 0.3,
                                                        child: Center(
                                                          child: Container(
                                                            margin:
                                                                EdgeInsetsDirectional
                                                                    .only(
                                                                        start:
                                                                            1.0,
                                                                        end:
                                                                            1.0),
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
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
                                    margin: EdgeInsets.only(top: 20),
                                    child: Center(
                                      child: Text(
                                        "You do not have any friends yet",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 234, 205, 125)),
                                      ),
                                    ),
                                  );
                                }
                            }
                          });
                    },
                  );
                },
              ),
            ),
          ],
        ));
  }
}
