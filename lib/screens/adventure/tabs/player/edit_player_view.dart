import 'package:flutter/material.dart';
import 'package:rpg_assist_app/models/adventure_model.dart';
import 'package:scoped_model/scoped_model.dart';

class EditPlayerView extends StatefulWidget {
  final String _adventureId, _playerId;

  EditPlayerView(this._adventureId,this._playerId);

  @override
  _EditPlayerViewState createState() => _EditPlayerViewState(_adventureId,_playerId);
}

class _EditPlayerViewState extends State<EditPlayerView> {
  final String _adventureId, _playerId;
  int _selectedItemRace, _selectedItemClass, _selectedItemSex;
  List<String> _race = ["Darf","Elf","Human"];
  List<String> _class = ["Warrior","Archer","Mage"];
  List<String> _sex = ["Male","Female"];

  _EditPlayerViewState(this._adventureId,this._playerId);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AdventureModel>(
      builder: (context,child,adventureModel){
        return Scaffold(
          appBar: AppBar(
            title: Text("CHARACTER EDIT",style: TextStyle(color: Color.fromARGB(255, 234, 205, 125)),),
            centerTitle: true,
          ),
          body: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 34, 17, 51),
                      Color.fromARGB(255, 44, 100, 124),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              ListView(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 20,left: 20,right: 20,bottom: 100),
                    child: Column(
                      children: <Widget>[
                        Text("CHOOSE A RACE:",
                            style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 234, 205, 125))),
                        Container(
                          color: Colors.black26,
                          child: GridView.count(
                            physics: NeverScrollableScrollPhysics(),
                            childAspectRatio: 0.8,
                            shrinkWrap: true,
                            padding: EdgeInsets.all(0),
                            crossAxisCount: 3,
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
                                        setState(() {
                                          _selectedItemRace = index;
                                        });
                                      },
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: _selectedItemRace == index
                                                    ? Color.fromARGB(
                                                    255, 6, 223, 176)
                                                    : Colors.transparent),
                                            child: Container(
                                              margin: EdgeInsets.all(5),
                                              height: 70,
                                              width: 70,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: AssetImage("images/race$index.png"),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(_race[index],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 15, color:  _selectedItemRace == index
                                                  ? Color.fromARGB(
                                                  255, 6, 223, 176)
                                                  : Colors.white,)),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Text("CHOOSE A CLASS:",
                            style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 234, 205, 125))),
                        Container(
                          color: Colors.black26,
                          child: GridView.count(
                            physics: NeverScrollableScrollPhysics(),
                            childAspectRatio: 0.8,
                            shrinkWrap: true,
                            padding: EdgeInsets.all(0),
                            crossAxisCount: 3,
                            children: List.generate(3,(index){
                              return Center(
                                child: Container(
                                  child: Card(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      splashColor: Color.fromARGB(255, 234, 205, 125),
                                      onTap: () {
                                        setState(() {
                                          _selectedItemClass = index;
                                        });
                                      },
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: _selectedItemClass == index
                                                    ? Color.fromARGB(255, 234, 205, 125)
                                                    : Colors.transparent),
                                            child: Container(
                                              margin: EdgeInsets.all(5),
                                              height: 70,
                                              width: 70,
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  fit: BoxFit.contain,
                                                  image: AssetImage("images/class$index.png"),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Text(_class[index],
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 15, color: _selectedItemClass == index
                                                    ? Color.fromARGB(255, 234, 205, 125)
                                                    : Colors.white)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            ),
                          ),
                        ),
                        Text("CHOSSE A GENDER:",
                            style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 234, 205, 125))),
                        Container(
                          color: Colors.black26,
                          child: GridView.count(
                            physics: NeverScrollableScrollPhysics(),
                            childAspectRatio: 1.2,
                            shrinkWrap: true,
                            padding: EdgeInsets.all(0),
                            crossAxisCount: 2,
                            children: List.generate(2,(index){
                              return Center(
                                child: Container(
                                  child: Card(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      splashColor: Color.fromARGB(255, 234, 205, 125),
                                      onTap: () {
                                        setState(() {
                                          _selectedItemSex = index;
                                        });
                                      },
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: _selectedItemSex == index
                                                    ? Colors.deepPurple
                                                    : Colors.transparent),
                                            child: Container(
                                              margin: EdgeInsets.all(5),
                                              height: 60,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: AssetImage("images/sex$index.png"),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Text(_sex[index],
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 15, color: _selectedItemSex == index
                                                    ? Colors.deepPurple
                                                    : Colors.white)),
                                          ),
                                        ],
                                      ),
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
              Container(
                margin: EdgeInsets.symmetric(vertical: 20 ,horizontal: 20),
                alignment: Alignment.bottomCenter,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(
                              5.0),
                        ),
                        color: Color.fromARGB(
                            255, 6, 223, 176),
                        onPressed: () {
                          print("Race: ${_race[_selectedItemRace]} Class: ${_class[_selectedItemClass]} Sex: ${_sex[_selectedItemSex]}");

                          Map<String, dynamic> characterData = Map();
                          characterData["race"] = _race[_selectedItemRace];
                          characterData["class"] = _class[_selectedItemClass];
                          characterData["sex"] = _sex[_selectedItemSex];

                          adventureModel.updateCharacter(_adventureId, _playerId, characterData);

                          Navigator.pop(context);


                        },
                        child: Text("Submit"),
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
