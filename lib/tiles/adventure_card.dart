import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:intl/intl.dart';

class AdventureCard extends StatelessWidget {
  DocumentSnapshot document;

  AdventureCard(this.document);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(5.0),
        height: 150,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(document["picture"]), fit: BoxFit.cover)),
        padding: EdgeInsets.all(10.0),
        child: Container(
            padding: EdgeInsets.only(left: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  document["title"],
                  style: TextStyle(
                    fontFamily: "IndieFlower",
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                Text(
                  DateFormat.yMMMd().format(document["nextSession"]),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                Slider(
                    max: 100.0,
                    min: 0.0,
                    value: (document["progress"].toDouble()))
              ],
            )));
  }
}
