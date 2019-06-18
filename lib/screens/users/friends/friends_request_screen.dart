import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rpg_assist_app/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class FriendsRequestScreen extends StatefulWidget {
  final List<DocumentSnapshot> friends;

  FriendsRequestScreen(this.friends);

  @override
  _FriendsRequestScreenState createState() => _FriendsRequestScreenState(friends);
}

class _FriendsRequestScreenState extends State<FriendsRequestScreen> {


  final List<DocumentSnapshot> friends;

  _FriendsRequestScreenState(this.friends);

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
            "Requests to accept",
            style: TextStyle(color: Color.fromARGB(255, 234, 205, 125)),
          ),
          backgroundColor: Color.fromARGB(255, 34, 17, 51),
          iconTheme: IconThemeData(color: Color.fromARGB(255, 234, 205, 125)),
        ),
        body: Stack(
          children: <Widget>[
            _buildBodyBack(),
            ListView.builder(
                shrinkWrap: true,
                itemCount: friends.length,
                itemBuilder: (context, index) {
                  return
                    ScopedModelDescendant<UserModel>(
                    builder: (context, child, userModel) {
                      return FutureBuilder<DocumentSnapshot>(
                        future:
                            userModel.userTeste(friends[index]["friend"]),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Container();
                            default:
                              if (snapshot.hasError) {
                                return Text("Error");
                              } else {
                                return Container(
                                    child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.only(left: 20),
                                                  width: 50.0,
                                                  height: 50.0,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: snapshot.data
                                                        ["photoUrl"] !=
                                                            null
                                                            ? NetworkImage(snapshot
                                                            .data
                                                        ["photoUrl"])
                                                            : AssetImage(
                                                            "images/rpg_icon.png"),
                                                      )
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      width: 120,
                                                      margin: EdgeInsets.only(left: 5),
                                                      child: Text(snapshot.data["name"] != null ? snapshot.data["name"]:
                                                      snapshot.data["username"] != null ? snapshot.data["username"]:snapshot.data["email"],
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            fontSize: 15),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 120,
                                                      margin: EdgeInsets.only(left: 5),
                                                      child: Text(snapshot.data["email"] != null ? snapshot.data["email"]:"",
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15,
                                                      ),
                                                    )
                                                    ),
                                                  ],
                                                ),

                                              ],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.only(right: 20),
                                                  width: 100,
                                                  child: RaisedButton(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(5.0),
                                                    ),
                                                    color: Color.fromARGB(255, 6, 223, 176),
                                                    onPressed: () {
                                                      Map<String,dynamic> receiverData = {
                                                        "friend" : userModel.userData["id"],
                                                        "status" : 2,
                                                        "requestId" : friends[index].documentID
                                                      };



                                                      userModel.acceptRequest
                                                        ( requesterId: snapshot.data["id"],
                                                          userId: userModel.userData["id"],
                                                          requestId: friends[index].documentID,
                                                          friendReceiver: receiverData);
                                                      setState(() {
                                                        friends.removeAt(index);
                                                      });
                                                      if(friends.length == 0){
                                                        Navigator.pop(context);
                                                      }

                                                    },
                                                    child: Text("ACCEPT",
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(right: 20),
                                                  child: Text("X",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
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
                                              start: 1.0,
                                              end: 1.0),
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ));
                              }
                          }
                        },
                      );
                    },
                  );
                }),
          ],
        ));
  }
}
