import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:rpg_assist_app/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class UsersScreen extends StatefulWidget {
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
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
        backgroundColor: Color.fromARGB(255, 34, 17, 51),
        iconTheme: IconThemeData(color: Color.fromARGB(255, 234, 205, 125)),
      ),
      body: Stack(
        children: <Widget>[
          _buildBodyBack(),
          ScopedModelDescendant<UserModel>(
            builder: (context, child, userModel) {
              return FutureBuilder<QuerySnapshot>(
                future: userModel.allUsers(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
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
                                    fontFamily: "IndieFlower",
                                    color: Color.fromARGB(255, 234, 205, 125),
                                    fontSize: 20),
                                textAlign: TextAlign.center,
                              )),
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            width: 100,
                            height: 100,
                            alignment: Alignment.center,
                            child: FlareActor("assets/Dice_Loading.flr",
                                animation: "loading"),
                          )
                        ],
                      ));
                    default:
                      if (snapshot.hasError) {
                        return Container(
                            child: Text(
                          'Error to loading: ${snapshot.error}',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ));
                      } else if (snapshot.data.documents.length <= 1) {
                        return Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(top: 120),
                                  child: Text(
                                    "No found users",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "IndieFlower",
                                        color:
                                            Color.fromARGB(255, 234, 205, 125),
                                        fontSize: 20),
                                    textAlign: TextAlign.center,
                                  )),
                              Container(
                                margin: EdgeInsets.only(top: 20),
                                width: 100,
                                height: 100,
                                alignment: Alignment.center,
                                child: FlareActor("assets/Dice_Loading.flr",
                                    animation: "loading"),
                              )
                            ],
                          ),
                        );
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            if (snapshot.data.documents[index]["id"] !=
                                userModel.userData["id"]) {
                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Map<String, dynamic> requestData = {
                                      "friend": userModel.userData["id"],
                                    };
                                    userModel.registerRequest(
                                        requestData: requestData,
                                        receiverId: snapshot
                                            .data.documents[index]["id"]);
                                    setState(() {
                                      snapshot.data.documents.removeAt(index);
                                    });

                                    if (snapshot.data.documents.length == 0) {
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: snapshot.data.documents[
                                                                    index]
                                                                ["photoUrl"] !=
                                                            null
                                                        ? NetworkImage(snapshot
                                                                .data.documents[
                                                            index]["photoUrl"])
                                                        : AssetImage(
                                                            "images/rpg_icon.png")),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  snapshot.data.documents[index]
                                                              ["name"] !=
                                                          null
                                                      ? snapshot.data
                                                              .documents[index]
                                                          ["name"]
                                                      : snapshot.data.documents[index]
                                                                  [
                                                                  "username"] !=
                                                              null
                                                          ? snapshot.data
                                                                  .documents[index]
                                                              ["username"]
                                                          : snapshot.data
                                                                  .documents[
                                                              index]["email"],
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15),
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
                                                  margin: EdgeInsetsDirectional
                                                      .only(
                                                          start: 1.0, end: 1.0),
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        );
                      }
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
