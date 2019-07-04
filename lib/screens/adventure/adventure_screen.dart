import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rpg_assist_app/models/adventure_model.dart';
import 'package:rpg_assist_app/models/user_model.dart';
import 'package:rpg_assist_app/screens/adventure/tabs/player/players_tab.dart';
import 'package:rpg_assist_app/screens/adventure/tabs/progress/progress_tab.dart';
import 'package:rpg_assist_app/widgets/popup_menu.dart';
import 'package:scoped_model/scoped_model.dart';

class AdventureScreen extends StatefulWidget {
  final DocumentSnapshot adventureDoc;
  final Map<String, dynamic> user;

  AdventureScreen(this.adventureDoc, this.user);

  @override
  _AdventureScreenState createState() =>
      _AdventureScreenState(adventureDoc, user);
}

class _AdventureScreenState extends State<AdventureScreen>
    with SingleTickerProviderStateMixin {
  final DocumentSnapshot adventureDoc;
  final Map<String, dynamic> user;
  static final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final _adventureTitleController = TextEditingController();
  final _adventureSummaryController = TextEditingController();
  _AdventureScreenState(this.adventureDoc, this.user);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AdventureModel>(
      builder: (context, child, adventureModel) {
        return ScopedModelDescendant<UserModel>(
          builder: (context, child, userModel) {
            return Scaffold(
                appBar: AppBar(
                  title: Image.asset(
                    "images/logo.png",
                    height: 20,
                  ),
                  centerTitle: true,
                  actions: <Widget>[
                    Visibility(
                        visible: adventureDoc["master"] == user["id"],
                        child: PopupMenuButton<String>(
                            onSelected: (String choice) {
                          userModel.choiceAction(choice);
                          setState(() {
                            adventureModel.choiceAction(choice);
                          });
                        }, itemBuilder: (context) {
                          return PopupMenu.choices.map((choice) {
                            return PopupMenuItem<String>(
                              value: choice,
                              child: Text(choice),
                            );
                          }).toList();
                        }))
                  ],
                ),
                body: Stack(
                  children: <Widget>[
                    Container(
                        constraints: BoxConstraints.expand(),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("images/adventure_start" +
                                    adventureDoc["photoNumber"] +
                                    ".png"),
                                fit: BoxFit.cover)),
                        child: Container(
                          margin: EdgeInsets.only(left: 40, top: 20, right: 40),
                          child: Text(
                            adventureDoc["title"],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        )),
                    Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: Color.fromARGB(255, 156, 183, 182),
                            blurRadius: 5.0,
                            spreadRadius: 1.0,
                            offset: Offset(3, 3))
                      ]),
                      margin: EdgeInsets.only(
                          top: 120, left: 10, right: 10, bottom: 40),
                      child: DefaultTabController(
                        length: 2,
                        child: Column(
                          children: <Widget>[
                            Container(
                              constraints: BoxConstraints.expand(height: 50),
                              child: TabBar(
                                labelColor: Colors.black,
                                tabs: <Widget>[
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text("PROGRESS"),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text("PLAYERS"),
                                  )
                                ],
                                indicator: ShapeDecoration(
                                    shape: BeveledRectangleBorder(),
                                    color: Color.fromARGB(255, 226, 226, 225)),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: TabBarView(
                                  children: <Widget>[
                                    Scaffold(
                                      body: Container(
                                          child:
                                              ProgressTab(user, adventureDoc),
                                          color: Color.fromARGB(
                                              255, 226, 226, 225)),
                                    ),
                                    Scaffold(
                                      body: Container(
                                          child: PlayersTab(
                                            user,
                                            adventureDoc,
                                          ),
                                          color: Color.fromARGB(
                                              255, 226, 226, 225)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      top: 22,
                      child: Container(
                          child: Visibility(
                            visible: (adventureModel.editMode &
                                (adventureDoc["master"] == user["id"])),
                            child: GestureDetector(
                              onTap: () {
                                 showDialog(
                                    context: context,
                                    builder: (context) {
                                      return ScopedModelDescendant<UserModel>(
                                        builder: (context,child,userModel){
                                          return Scaffold(
                                              appBar: AppBar(
                                                backgroundColor: Color.fromARGB(255, 34, 17, 51),
                                                title: Image.asset(
                                                  "images/logo.png",
                                                  height: 20,
                                                ),
                                                centerTitle: true,
                                                iconTheme: IconThemeData(color: Color.fromARGB(255, 234, 205, 125)),
                                              ),
                                              floatingActionButton: Container(
                                                width: 80.0,
                                                height: 80.0,
                                                child: FloatingActionButton(
                                                  backgroundColor: Color.fromRGBO(0, 226, 186, 1.0),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Container(
                                                    child: Icon(Icons.check),
                                                  ),
                                                ),
                                              ),
                                              floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
                                              body: Container(
                                                  color: Color.fromARGB(255, 20, 110, 111),
                                                  child: ScopedModelDescendant<AdventureModel>(
                                                    builder: (context,child,model){
                                                      return Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5), color: Colors.white),
                                                        margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                                                        child: ListView(
                                                          children: <Widget>[
                                                            Container(
                                                              margin: EdgeInsets.only(left: 20,right: 20,top: 50),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                                children: <Widget>[
                                                                  Text(
                                                                    "Edit adventure",
                                                                    style: TextStyle(
                                                                        color: Color.fromARGB(255, 84, 166, 145),
                                                                        fontSize: 20,
                                                                        fontWeight: FontWeight.bold),
                                                                  ),
                                                                  Form(
                                                                    key: _formKey,
                                                                    child: Column(
                                                                      children: <Widget>[
                                                                        Container(
                                                                          margin: EdgeInsets.only(left: 20, right: 20),
                                                                          child: TextFormField(
                                                                            controller: _adventureTitleController,
                                                                            style: TextStyle(),
                                                                            decoration: InputDecoration(
                                                                                labelText: "Name adventure",
                                                                                hintStyle: TextStyle(
                                                                                  fontSize: 15,
                                                                                ),
                                                                                contentPadding: EdgeInsets.only(
                                                                                    top: 30, right: 30, bottom: 10, left: 5)),
                                                                            validator: (text){
                                                                              if(text.isEmpty){
                                                                                return "enter the name of the adventure";
                                                                              }
                                                                            },
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          margin: EdgeInsets.only(left: 20, right: 20),
                                                                          child: TextFormField(
                                                                            controller: _adventureSummaryController,
                                                                            style: TextStyle(),
                                                                            decoration: InputDecoration(
                                                                                labelText: "Sumarry adventure",
                                                                                hintStyle: TextStyle(
                                                                                  fontSize: 15,
                                                                                ),
                                                                                contentPadding: EdgeInsets.only(
                                                                                    top: 30, right: 30, bottom: 10, left: 5)),
                                                                            validator: (text){
                                                                              if(text.isEmpty){
                                                                                return "enter the sumarry of the adventure";
                                                                              }
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),

                                                                  Container(
                                                                    margin: EdgeInsets.only(top: 20),
                                                                    child: RaisedButton(
                                                                      onPressed: () {
                                                                        if(_formKey.currentState.validate()){
                                                                          Map<String, dynamic> adventureData = {
                                                                            "title": _adventureTitleController.text,
                                                                            "summary": _adventureSummaryController.text,
                                                                          };

                                                                          model.updateAdventure(adventureData,adventureDoc["adventureId"]);

                                                                          print(adventureDoc["adventureId"]);

                                                                          Navigator.of(context).pop();
                                                                        }

                                                                      },
                                                                      color: Color.fromRGBO(0, 226, 186, 1.0),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: <Widget>[
                                                                          SizedBox(
                                                                            width: 10.0,
                                                                          ),
                                                                          Text(
                                                                            "Edit",
                                                                            style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 15.0,
                                                                              fontWeight: FontWeight.w500,
                                                                              letterSpacing: 1.0,
                                                                            ),
                                                                          ),
                                                                        ],
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
                                                  )
                                              )
                                          );
                                        },
                                      );
                                    });
                              },
                              child: Container(
                                child: Icon(Icons.mode_edit,size: 20,color: Colors.white,),
                              )
                            ),
                          )),
                    ),
                  ],
                ));
          },
        );
      },
    );
  }
}
