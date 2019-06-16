import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rpg_assist_app/models/user_model.dart';
import 'package:rpg_assist_app/screens/users/friends/friends_request_screen.dart';
import 'package:rpg_assist_app/screens/users/users_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class AccountFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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

    return ScopedModelDescendant<UserModel>(
      builder: (context, child, userModel) {
        return Scaffold(
          floatingActionButton: Container(
              margin: EdgeInsets.only(bottom: 10),
              width: 70,
              height: 70,
              child: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => UsersScreen()));
                  },
                  backgroundColor: Color.fromARGB(255, 6, 223, 176),
                  child: Icon(
                    FontAwesomeIcons.userPlus,
                    color: Colors.black,
                  ))),
          body: Stack(
            children: <Widget>[
              _buildBodyBack(),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        StreamBuilder<QuerySnapshot>(
                            stream:
                                userModel.nFriends(userModel.userData["id"]),
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return Container();
                                default:
                                  if (snapshot.data.documents.length >= 1) {
                                    return Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      FriendsRequestScreen(
                                                          snapshot.data
                                                              .documents)));
                                        },
                                        child: Container(
                                          child: Column(
                                            children: <Widget>[
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Stack(
                                                    children: <Widget>[
                                                      Container(
                                                        width: 50.0,
                                                        height: 50.0,
                                                        decoration: BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            image: DecorationImage(
                                                                fit:
                                                                    BoxFit.fill,
                                                                image: AssetImage(
                                                                    "images/rpg_icon.png"))),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 35),
                                                        width: 20,
                                                        height: 20,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.red,
                                                        ),
                                                        child: Text(
                                                          snapshot.data
                                                              .documents.length
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        "Friend requests",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        "approve or ignore requests",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                              }
                            }),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.all(15),
                                    child: Column(
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            width: 70.0,
                                            height: 70.0,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: userModel.userData[
                                                              "photoUrl"] !=
                                                          null
                                                      ? NetworkImage(userModel
                                                          .userData["photoUrl"])
                                                      : AssetImage(
                                                          "images/rpg_icon.png"),
                                                )),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          width: 100,
                                          child: Text(
                                            userModel.userData["name"] != null
                                                ? userModel.userData["name"]
                                                : "",
                                            style:
                                                TextStyle(color: Colors.white),
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            overflow: TextOverflow.clip,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: userModel
                                        .userFriendsLive(userModel.userData["id"]),
                                    builder: (context, friends) {
                                      if (userModel.userData != null) {
                                        return Container(
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Text("Friends: ",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15)),
                                                  Text(
                                                      friends.data != null
                                                          ? (friends
                                                                  .data
                                                                  .documents
                                                                  .length)
                                                              .toString()
                                                          : "0",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15)),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Text("Adventures: ",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15)),
                                                  Text("0",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15)),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Container(
                                                height: 25,
                                                width: 180,
                                                child: RaisedButton(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                  ),
                                                  color: Color.fromARGB(
                                                      255, 6, 223, 176),
                                                  onPressed: () {},
                                                  child: Text("Edit profile"),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 20),
                              child: Text(
                                userModel.userData["masterTitle"] != null
                                    ? userModel.userData["masterTitle"]
                                    : "You do not have a phrase.",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                            ),
                            StreamBuilder(
                                stream: userModel
                                    .userFriendsLive(userModel.userData["id"]),
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
                                                      ["friend"]),
                                              builder: (context, snapshot) {
                                                switch (
                                                    snapshot.connectionState) {
                                                  case ConnectionState.waiting:
                                                    return Container();
                                                  default:
                                                    if (snapshot.hasError) {
                                                      Text("Error");
                                                    } else {
                                                      return Container(
                                                        child: Column(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Row(
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  width: 50.0,
                                                                  height: 50.0,
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
                                                                          color: Colors
                                                                              .white,
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
                                                                      .white,
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
                                                  fontFamily: "IndieFlower",
                                                  color: Color.fromARGB(
                                                      255, 234, 205, 125)),
                                            ),
                                          ),
                                        );
                                      }
                                  }
                                })
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
