import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Summary extends StatefulWidget {
  final DocumentSnapshot adventureDoc;
  Summary(this.adventureDoc);

  @override
  _SummaryState createState() => _SummaryState(adventureDoc);
}

class _SummaryState extends State<Summary> {
  final DocumentSnapshot adventureDoc;
  int seeMore = 6;

  _SummaryState(this.adventureDoc);
  @override
  Widget build(BuildContext context) {
    return             Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        adventureDoc["summary"] != ""
                            ? adventureDoc["summary"]
                            : "Add summary on this adventure ",
                        maxLines: seeMore,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              if (seeMore == 6) {
                seeMore = 20;
              } else {
                seeMore = 6;
              }
            });
          },
          child: Visibility(
            visible: adventureDoc["summary"].length >= 240,
            child: Row(
              children: <Widget>[
                Text(
                  seeMore <= 6 ? "see more" : "see less",
                  style: TextStyle(color: Color.fromARGB(255, 6, 223, 176)),
                ),
                Icon(
                  seeMore <= 6
                      ? Icons.arrow_drop_down
                      : Icons.arrow_drop_up,
                  color: Color.fromARGB(255, 6, 223, 176),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
