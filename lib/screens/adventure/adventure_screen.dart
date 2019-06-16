import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rpg_assist_app/screens/adventure/tabs/player/players_tab.dart';
import 'package:rpg_assist_app/screens/adventure/tabs/progress_tab.dart';
import 'package:rpg_assist_app/screens/users/friends/friends_list.dart';

import 'new_session_screen.dart';

class AdventureScreen extends StatefulWidget {
  final DocumentSnapshot adventureDoc;
  final Map<String, dynamic> user;

  AdventureScreen(this.adventureDoc, this.user);

  @override
  _AdventureScreenState createState() =>
      _AdventureScreenState(adventureDoc, user);
}

class _AdventureScreenState extends State<AdventureScreen>
    with SingleTickerProviderStateMixin {
  final DocumentSnapshot adventureDoc;
  final Map<String, dynamic> user;

  _AdventureScreenState(this.adventureDoc, this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 34, 17, 51),
          title: Image.asset(
            "images/logo.png",
            height: 20,
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Color.fromARGB(255, 234, 205, 125)),
          actions: <Widget>[PopupMenuButton(itemBuilder: (_) {})],
        ),
        body: Stack(
          children: <Widget>[
            Container(
                constraints: BoxConstraints.expand(),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/adventure_start" +
                            adventureDoc["photoNumber"] +
                            ".png"),
                        fit: BoxFit.cover)),
                child: Container(
                  margin: EdgeInsets.only(left: 40, top: 20, right: 40),
                  child: Text(
                    adventureDoc["title"],
                    style: TextStyle(
                      fontFamily: "IndieFlower",
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                )
            ),
            Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Color.fromARGB(255, 156, 183, 182),
                    blurRadius: 5.0,
                    spreadRadius: 1.0,
                    offset: Offset(3, 3))
              ]),
              margin:
                  EdgeInsets.only(top: 120, left: 10, right: 10, bottom: 40),
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: <Widget>[
                    Container(
                      constraints: BoxConstraints.expand(height: 50),
                      child: TabBar(
                        labelColor: Colors.black,
                        tabs: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            child: Text("PROGRESS"),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text("PLAYERS"),
                          )
                        ],
                        indicator: ShapeDecoration(
                            shape: BeveledRectangleBorder(),
                            color: Color.fromARGB(255, 226, 226, 225)),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: TabBarView(
                          children: <Widget>[
                            Scaffold(
                              floatingActionButton: Container(
                                  width: 80.0,
                                  height: 80.0,
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
                              body: Container(
                                  child: ProgressTab(user, adventureDoc),
                                  color: Color.fromARGB(255, 226, 226, 225)),
                            ),
                            Scaffold(
                              floatingActionButton: Container(
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
                                  )),
                              body: Container(
                                  child: PlayersTab(user, adventureDoc,),
                                  color: Color.fromARGB(255, 226, 226, 225)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
