import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:rpg_assist_app/models/adventure_model.dart';
import 'package:rpg_assist_app/models/user_model.dart';
import 'package:rpg_assist_app/cards/adventure_card.dart';
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
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      return Scaffold(

        floatingActionButton: Container(
            width: 80.0,
            height: 80.0,
            child: FloatingActionButton(
              backgroundColor: Colors.transparent,
              onPressed: (){
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context)=>NewAdventureScreen()));
              },
              child: Container(
                child: Image.asset("images/new_adventure.png"),
              ),
            )
        ),

        body: Stack(
          children: <Widget>[
            _buildBodyBack(),
                ScopedModelDescendant<AdventureModel>(
                  builder: (context,child,adventureModel){
                    return FutureBuilder<QuerySnapshot>(
                        future: adventureModel.adventuresCards(model.userData["id"]),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              return Container(
                                  child: Text('Press button to start'));
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
                                  )
                              );
                            default:
                              if (snapshot.hasError)
                                return Container(
                                    child: Text(
                                      'Error to loading: ${snapshot.error}',
                                      style: TextStyle(color: Colors.white, fontSize: 20),
                                    )
                                );
                              else if (snapshot.data.documents.length == 0) {
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
                                                color:
                                                Color.fromARGB(255, 234, 205, 125),
                                                fontSize: 20),
                                            textAlign: TextAlign.center,
                                          )),
                                    ],
                                  ),
                                );
                              } else {
                                return ListView.builder(
                                    itemCount: snapshot.data.documents.length,
                                    itemBuilder: (context,index){
                                      return AdventureCard(snapshot.data.documents[index],model.userData);
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







