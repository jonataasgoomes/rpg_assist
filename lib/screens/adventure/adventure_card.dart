import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rpg_assist_app/models/adventure_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:page_transition/page_transition.dart';

import 'adventure_screen.dart';

class AdventureCard extends StatefulWidget {
  final DocumentSnapshot adventureDoc;
  final Map<String, dynamic> user;
  final GlobalKey<ScaffoldState> _scaffoldKeyAdventure;


  AdventureCard(this.adventureDoc, this.user,this._scaffoldKeyAdventure);

  @override
  _AdventureCardState createState() => _AdventureCardState(adventureDoc, user,_scaffoldKeyAdventure);
}

class _AdventureCardState extends State<AdventureCard> {
  final DocumentSnapshot adventureDoc;
  final Map<String, dynamic> user;
  final GlobalKey<ScaffoldState> _scaffoldKeyAdventure;
  _AdventureCardState(this.adventureDoc, this.user,this._scaffoldKeyAdventure);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 5),
          height: 150,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                      "images/adventure" + adventureDoc["photoNumber"] +
                          ".png"),
                  fit: BoxFit.cover)),
        ),
        Container(
            margin: EdgeInsets.only(top: 5),
            height: 150,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                  onTap: () {
                  //  Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdventureScreen(adventureDoc, user)));
                    Navigator.push(context, PageTransition(child:  AdventureScreen(adventureDoc, user), type: PageTransitionType.rightToLeft));
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 40, top: 20, right: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          adventureDoc["title"] != null
                              ? adventureDoc["title"]
                              : "adventure without title",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          maxLines: 1,
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Text(adventureDoc["nextSession"] != null
                            ? "Next session: " +
                            DateFormat.Md().format(adventureDoc["nextSession"])
                            : "",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        LinearProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white),
                          backgroundColor: Colors.transparent,
                          value: adventureDoc['progress'] != null
                              ? adventureDoc['progress'] / 100
                              : 0,
                        )
                      ],
                    ),
                  )
              ),
            )
        ),
        ScopedModelDescendant<AdventureModel>(
          builder: (context,child,adventureModel){
            return Positioned(
              right: 20,
              top: 25,
              child: Container(
                  height: 30,
                  child: Visibility(
                    visible: (adventureModel.editMode & (adventureDoc["master"] == user["id"])),
                    child: GestureDetector(
                      onTap: () async {
                          final bool result = await showDialog(
                              context: context,
                              builder: (context){
                                return AlertDialog(
                                  title: Text("confirm delete".toUpperCase()),
                                  content: Text("Are you sure you wish to delete this adventure? this is irreversible! And all data will be erased "),
                                  actions: <Widget>[
                                    FlatButton(onPressed: () => Navigator.of(context).pop(false),
                                        child: const Text("CANCEL")
                                    ),

                                    FlatButton(
                                      onPressed: () => Navigator.of(context).pop(true),
                                      child: const Text("DELETE",style: TextStyle(color: Colors.red),),)
                                  ],
                                );
                              }
                          );
                          if (result){
                            adventureModel.removeAllPlayersAdventure(adventureId: adventureDoc["adventureId"], masterId: adventureDoc["master"]).then((e){
                              _scaffoldKeyAdventure.currentState.showSnackBar(SnackBar(content: Text("Successfully removed")));
                            });
                          }else{
                            return result;
                          }


                      },
                      child: Image.asset("images/btn_delete.png"),
                    ),
                  )
              ),
            );
          },
        ),
        ScopedModelDescendant<AdventureModel>(
          builder: (context,child,adventureModel){
            return Positioned(
              right: 20,
              top: 25,
              child: Container(
                  height: 30,
                  child: Visibility(
                    visible: (adventureModel.editMode & (adventureDoc["master"] != user["id"])),
                    child: GestureDetector(
                      onTap: () async {
                        final bool result = await showDialog(
                            context: context,
                            builder: (context){
                              return AlertDialog(
                                title: Text("confirm delete".toUpperCase()),
                                content: Text("Are you sure you wish to leave this adventure? If you want to go back, talk to the master."),
                                actions: <Widget>[
                                  FlatButton(onPressed: () => Navigator.of(context).pop(false),
                                      child: const Text("CANCEL")
                                  ),

                                  FlatButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: const Text("DELETE",style: TextStyle(color: Colors.red),),)
                                ],
                              );
                            }
                        );
                        if (result){
                          adventureModel.removeAdventureFromUser(adventureDoc["adventureId"], user["id"]).then((e){
                            _scaffoldKeyAdventure.currentState.showSnackBar(SnackBar(content: Text("Successfully removed")));
                          });
                        }else{
                          return result;
                        }

                      },
                      child: Icon(Icons.close),
                    ),
                  )
              ),
            );
          },
        ),
      ],
    );
  }
}


