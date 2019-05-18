import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdventureCard extends StatefulWidget {
  final DocumentSnapshot document;

  AdventureCard(this.document);

  @override
  _AdventureCardState createState() => _AdventureCardState(document);
}

class _AdventureCardState extends State<AdventureCard> {
  final DocumentSnapshot document;

  _AdventureCardState(this.document);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(5),
            height: 150,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        "images/adventure" + document["photoNumber"] + ".png"),
                    fit: BoxFit.cover)),
    ),
            Container(
              margin: EdgeInsets.all(5),
              height: 150,
                child: Material(
                    color: Colors.transparent,
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          margin: EdgeInsets.only(left: 20, top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Text(
                                widget.document["title"],
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
                                DateFormat.yMMMd()
                                    .format(widget.document["nextSession"]),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Slider(
                                  activeColor: Colors.white,
                                  onChanged: (_) {},
                                  max: 100.0,
                                  min: 0.0,
                                  value: (widget.document["progress"].toDouble()))
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
