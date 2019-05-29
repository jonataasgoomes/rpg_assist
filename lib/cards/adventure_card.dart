import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rpg_assist_app/screens/adventure/adventure_screen.dart';

class AdventureCard extends StatefulWidget {
  final DocumentSnapshot adventureDoc;
  final Map<String,dynamic> user;
  AdventureCard(this.adventureDoc, this.user);

  @override
  _AdventureCardState createState() => _AdventureCardState(adventureDoc,user);
}

class _AdventureCardState extends State<AdventureCard> {
  final DocumentSnapshot adventureDoc;
  final Map<String,dynamic> user;

  _AdventureCardState(this.adventureDoc, this.user);

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
                        "images/adventure" + adventureDoc["photoNumber"] + ".png"),
                    fit: BoxFit.cover)),
    ),
            Container(
              margin: EdgeInsets.only(top: 5),
              height: 150,
                child: Material(
                    color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                              builder: (context)=> AdventureScreen(adventureDoc,user)));
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 40, top: 20,right: 40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Text(
                                adventureDoc["title"] != null ? adventureDoc["title"]: "adventure without title" ,
                                style: TextStyle(
                                  fontFamily: "IndieFlower",
                                  color: Colors.white,
                                  fontSize: 25,
                                ),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              Text(adventureDoc["nextSession"] != null ? "Next session: "+DateFormat.Md().format(adventureDoc["nextSession"]):"",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              LinearProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                backgroundColor: Colors.transparent,
                                value: adventureDoc['progress'] != null ? adventureDoc['progress']/100 : 0,
                              )
                            ],
                          ),
                        )
                      ),
                )
            )
      ],
    );
  }
}


