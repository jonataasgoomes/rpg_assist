import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:rpg_assist_app/models/adventure_model.dart';
import 'package:rpg_assist_app/models/user_model.dart';
import 'package:rpg_assist_app/screens/adventure/adventure_card.dart';
import 'package:rpg_assist_app/screens/adventure/new_adventure_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class HomeFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
    return ScopedModelDescendant<UserModel>(
        builder: (context, child, userModel) {
      return Scaffold(
        floatingActionButton: Container(
            width: 80.0,
            height: 80.0,
            child: FloatingActionButton(
              backgroundColor: Colors.transparent,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NewAdventureScreen()));
              },
              child: Container(
                child: Image.asset("images/new_adventure.png"),
              ),
            )),
        body: Stack(
          children: <Widget>[
            _buildBodyBack(),
            ScopedModelDescendant<AdventureModel>(
              builder: (context, child, adventureModel) {
                return StreamBuilder<QuerySnapshot>(
                  stream:
                      adventureModel.adventureCardsId(userModel.userData["id"]),
                  builder: (context, adventureSnapshot) {
                    switch (adventureSnapshot.connectionState) {
                      case ConnectionState.none:
                        return Container(
                          child: Text("Check you connection status"),
                        );
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
                        if (adventureSnapshot.data.documents.isEmpty) {
                          return Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(top: 120),
                                    child: Text(
                                      "Register an adventure!",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "IndieFlower",
                                          color: Color.fromARGB(
                                              255, 234, 205, 125),
                                          fontSize: 20),
                                      textAlign: TextAlign.center,
                                    )),
                              ],
                            ),
                          );
                        } else if (adventureSnapshot.hasError) {
                          Container(
                              child: Text(
                            'Error to loading: ${adventureSnapshot.error}',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ));
                        } else {
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount:
                                  adventureSnapshot.data.documents.length,
                              itemBuilder: (context, index) {
                                return FutureBuilder<DocumentSnapshot>(
                                  future: adventureModel.adventuresCard(adventureSnapshot.data.documents[index]["adventureId"]),
                                  builder: (context, adventureCard) {
                                    switch(adventureCard.connectionState){
                                      case ConnectionState.waiting:
                                        return Container();
                                      default:
                                        if(adventureCard.hasError){
                                          Text("Error");
                                        }
                                        else{



                                          return AdventureCard(adventureCard.data,userModel.userData);
                                        }
                                    }
                                  },
                                );
                              });
                        }
                    }
                  },
                );
              },
            )
          ],
        ),
      );
    });
  }
}
