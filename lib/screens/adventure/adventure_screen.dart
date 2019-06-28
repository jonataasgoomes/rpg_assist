import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rpg_assist_app/models/adventure_model.dart';
import 'package:rpg_assist_app/models/user_model.dart';
import 'package:rpg_assist_app/screens/adventure/tabs/player/players_tab.dart';
import 'package:rpg_assist_app/screens/adventure/tabs/progress/progress_tab.dart';
import 'package:rpg_assist_app/widgets/popup_menu.dart';
import 'package:scoped_model/scoped_model.dart';

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
    return ScopedModelDescendant<AdventureModel>(
      builder: (context, child, adventureModel) {
        return ScopedModelDescendant<UserModel>(
          builder: (context, child, userModel) {
            return Scaffold(
                appBar: AppBar(
                  title: Image.asset(
                    "images/logo.png",
                    height: 20,
                  ),
                  centerTitle: true,
                  actions: <Widget>[
                    Visibility(
                        visible: adventureDoc["master"] == user["id"],
                        child: PopupMenuButton<String>(
                            onSelected: (String choice) {
                          userModel.choiceAction(choice);
                          setState(() {
                            adventureModel.choiceAction(choice);
                          });
                        }, itemBuilder: (context) {
                          return PopupMenu.choices.map((choice) {
                            return PopupMenuItem<String>(
                              value: choice,
                              child: Text(choice),
                            );
                          }).toList();
                        }))
                  ],
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
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        )),
                    Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: Color.fromARGB(255, 156, 183, 182),
                            blurRadius: 5.0,
                            spreadRadius: 1.0,
                            offset: Offset(3, 3))
                      ]),
                      margin: EdgeInsets.only(
                          top: 120, left: 10, right: 10, bottom: 40),
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
                                      body: Container(
                                          child:
                                              ProgressTab(user, adventureDoc),
                                          color: Color.fromARGB(
                                              255, 226, 226, 225)),
                                    ),
                                    Scaffold(
                                      body: Container(
                                          child: PlayersTab(
                                            user,
                                            adventureDoc,
                                          ),
                                          color: Color.fromARGB(
                                              255, 226, 226, 225)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      top: 22,
                      child: Container(
                          child: Visibility(
                            visible: (adventureModel.editMode &
                                (adventureDoc["master"] == user["id"])),
                            child: GestureDetector(
                              onTap: () async {
                                final bool result = await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        margin: EdgeInsets.symmetric(vertical: 100,horizontal: 50),
                                        color: Colors.white,
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                FlatButton(onPressed: () => Navigator.of(context).pop(false),
                                                    child: const Text("CANCEL")
                                                ),

                                                FlatButton(
                                                  onPressed: () => Navigator.of(context).pop(true),
                                                  child: const Text("EDIT",style: TextStyle(color: Colors.green),),)
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                                if (result) {
                                  return result;
                                } else {
                                  return false;
                                }
                              },
                              child: Container(
                                child: Icon(Icons.mode_edit,size: 20,color: Colors.white,),
                              )
                            ),
                          )),
                    ),
                  ],
                ));
          },
        );
      },
    );
  }
}
