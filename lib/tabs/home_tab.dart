import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:rpg_assist_app/models/adventure_model.dart';
import 'package:rpg_assist_app/models/user_model.dart';
import 'package:rpg_assist_app/cards/adventure_card.dart';
import 'package:scoped_model/scoped_model.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget _buildBodyBack() => Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 28, 64, 80),
              Color.fromARGB(255, 44, 100, 124)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )),
    );
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      return Stack(
        children: <Widget>[
          _buildBodyBack(),
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                actions: <Widget>[
                  PopupMenuButton(itemBuilder: (_){})
                ],
                backgroundColor: Color.fromARGB(255, 34, 17, 51),
                title: Image.asset(
                  "images/logo.png",
                  height: 20,
                ),
                centerTitle: true,
                iconTheme:
                IconThemeData(color: Color.fromARGB(255, 234, 205, 125)),
                floating: false,
                elevation: 0.0,
                pinned: true,
                expandedHeight: 150,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: EdgeInsets.all(60),
                  background: Image.asset(
                    "images/background_sliver_bar.png",
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    "Adventures",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "IndieFlower",
                      color: Color.fromARGB(255, 234, 205, 125),
                    ),
                  ),
                ),
              ),
              ScopedModelDescendant<AdventureModel>(
                builder: (context,child,adventureModel){
                  return FutureBuilder<QuerySnapshot>(
                    future: adventureModel.adventuresCards(model.userData["id"]),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return SliverToBoxAdapter(
                              child: Text('Press button to start'));
                        case ConnectionState.waiting:
                          return SliverToBoxAdapter(
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
                            return SliverToBoxAdapter(
                                child: Text(
                                  'Error to loading: ${snapshot.error}',
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                )
                            );
                          else if (snapshot.data.documents.length == 0) {
                            return SliverToBoxAdapter(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                            return SliverList(
                                delegate:
                                SliverChildBuilderDelegate((context, index) {
                                  return AdventureCard(snapshot.data.documents[index],model.userData);
                                }, childCount: snapshot.data.documents.length));
                          }
                      }
                    },
                  );
                },
              )
            ],
          ),
        ],
      );
    });
  }



}







