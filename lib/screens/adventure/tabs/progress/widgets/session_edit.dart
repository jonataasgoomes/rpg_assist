import 'package:flutter/material.dart';
import 'package:rpg_assist_app/models/adventure_model.dart';
import 'package:scoped_model/scoped_model.dart';


class SessionEdit extends StatefulWidget {
  String sessionId,adventureId;
  SessionEdit(this.sessionId,this.adventureId);
  @override
  _SessionEditState createState() => _SessionEditState(sessionId,adventureId);
}

class _SessionEditState extends State<SessionEdit> {
  String sessionId,adventureId;
  List<String> sessionStatusField = ["Close","Open","Finish"];

  _SessionEditState(this.sessionId,this.adventureId);


  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AdventureModel>(
      builder: (context,child,adventureModel){
        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "Select session status",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
              Container(
                child: GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  childAspectRatio: 2.5,
                  shrinkWrap: true,
                  crossAxisCount: 1,
                  children: <Widget>[
                    Center(
                      child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: List.generate(
                          3,
                              (index) {
                            return Center(
                              child: Card(
                                color: Colors.transparent,
                                child: InkWell(
                                  splashColor: Color.fromARGB(
                                      255, 6, 223, 176),
                                  onTap: () {
                                    adventureModel.changeSessionStatus(index, sessionId, adventureId).then((data){
                                      Navigator.pop(context);
                                    });

                                  },
                                  child: Column(
                                    mainAxisSize:
                                    MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                        margin:
                                        EdgeInsets.all(5),
                                        decoration:
                                        BoxDecoration(
                                            shape: BoxShape
                                                .circle,
                                            color: Colors.black38),
                                        child: Container(
                                          margin:
                                          EdgeInsets.all(
                                              5),
                                          height: 70,
                                          width: 70,
                                          decoration:
                                          BoxDecoration(
                                            shape: BoxShape
                                                .circle,
                                            image:
                                            DecorationImage(
                                              fit:
                                              BoxFit.fill,
                                              image: AssetImage(
                                                  "images/session_status$index.png"),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        sessionStatusField[index],
                                        textAlign:
                                        TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
