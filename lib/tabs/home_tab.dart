import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:rpg_assist_app/models/user_model.dart';
import 'package:rpg_assist_app/tiles/adventure_card.dart';
import 'package:scoped_model/scoped_model.dart';



class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  @override
  Widget build(BuildContext context) {
    Widget _buildBodyBack() => Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 34, 17, 51),
              Color.fromARGB(255, 82, 40, 123)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )),
    );
    return ScopedModelDescendant<UserModel>(
        builder: (context,child,model){
        return Stack(
          children: <Widget>[
            _buildBodyBack(),
            CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
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
                    titlePadding: EdgeInsets.all(50),
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
                FutureBuilder<QuerySnapshot>(
                  future: Firestore.instance
                      .collection("adventures").where("master",isEqualTo: model.userId)
                      .orderBy("nextSession")
                      .getDocuments(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return SliverToBoxAdapter(
                          child: Container(
                            margin: EdgeInsets.only(top: 150),
                            width: 100,
                            height: 100,
                            alignment: Alignment.center,
                            child: FlareActor("assets/Dice_Loading.flr",
                                animation: "loading"),

                          )
                      );
                    }if(snapshot.data.documents.length == 0) {
                      print(snapshot.data.documents.length);

                      return SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(top: 120),
                                child: Text("Register an adventure!",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "IndieFlower",
                                      color: Color.fromARGB(255, 234, 205, 125),
                                      fontSize: 20
                                  ),
                                  textAlign: TextAlign.center,
                                )
                            ),
                          ],
                        ),

                    );

                    }else{

                      print(snapshot.data.documents.length);
                      return SliverList(
                          delegate: SliverChildBuilderDelegate((context, index) {
                            return AdventureCard(snapshot.data.documents[index], index);
                          }, childCount: snapshot.data.documents.length)
                      );
                    }
                  },
                )
              ],
            ),
          ],
        );
    }

    );
  }
}
