import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rpg_assist_app/models/adventure_model.dart';
import 'package:scoped_model/scoped_model.dart';

class EditPlayerView extends StatefulWidget {
  final String _adventureId;
  final DocumentSnapshot _playerCharacter;

  EditPlayerView(this._adventureId, this._playerCharacter);

  @override
  _EditPlayerViewState createState() =>
      _EditPlayerViewState(_adventureId, _playerCharacter);
}

class _EditPlayerViewState extends State<EditPlayerView> {
  final String _adventureId;
  final DocumentSnapshot _playerCharacter;
  int _selectedItemRace, _selectedItemClass, _selectedItemSex;
  List<String> _race = ["Dwarf", "Elf", "Human"];
  List<String> _class = ["Warrior", "Archer", "Mage"];
  List<String> _sex = ["Male", "Female"];
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey  = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  _EditPlayerViewState(this._adventureId, this._playerCharacter);

  @override
  void initState() {
    _loadCharacter();
    super.initState();
  }


  @override
  void dispose() {
    _nameController.dispose();


    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AdventureModel>(
      builder: (context, child, adventureModel) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(
              "CHARACTER EDIT",
              style: TextStyle(color: Color.fromARGB(255, 234, 205, 125)),
            ),
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
                    margin: EdgeInsets.only(
                        left: 20, right: 20),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "CHOSSE A NAME:",
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 234, 205, 125),
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Card(
                            color: Colors.black12,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: TextFormField(
                                style: TextStyle(color: Colors.white, fontSize: 20),
                                controller: _nameController,
                                autofocus: false,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter a character name',
                                    hintStyle: TextStyle(color: Colors.white)
                                ),
                                validator: (value){
                                  if(value.length > 6){
                                    return 'Maximum size is 6';
                                  }else if (value.isEmpty){
                                    return 'Enter a character name';
                                  }else
                                    return null;
                                },
                              ),
                            ),
                          ),
                        ),
                        Text(
                          "CHOOSE A RACE:",
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 234, 205, 125),
                          ),
                        ),
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
                                      splashColor:
                                          Color.fromARGB(255, 6, 223, 176),
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
                                                color:
                                                    _selectedItemRace == index
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
                                                  image: AssetImage(
                                                      "images/race$index.png"),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            _race[index],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: _selectedItemRace == index
                                                  ? Color.fromARGB(
                                                      255, 6, 223, 176)
                                                  : Colors.white,
                                            ),
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
                        Text(
                          "CHOOSE A CLASS:",
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 234, 205, 125),
                          ),
                        ),
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
                                  child: Container(
                                    child: Card(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        splashColor:
                                            Color.fromARGB(255, 234, 205, 125),
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
                                                  color: _selectedItemClass ==
                                                          index
                                                      ? Color.fromARGB(
                                                          255, 234, 205, 125)
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
                                                    image: AssetImage(
                                                        "images/class$index.png"),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              child: Text(
                                                _class[index],
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: _selectedItemClass ==
                                                            index
                                                        ? Color.fromARGB(
                                                            255, 234, 205, 125)
                                                        : Colors.white),
                                              ),
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
                        Text(
                          "CHOSSE A GENDER:",
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 234, 205, 125),
                          ),
                        ),
                        Container(
                          color: Colors.black26,
                          child: GridView.count(
                            physics: NeverScrollableScrollPhysics(),
                            childAspectRatio: 1.2,
                            shrinkWrap: true,
                            padding: EdgeInsets.all(0),
                            crossAxisCount: 2,
                            children: List.generate(
                              2,
                              (index) {
                                return Center(
                                  child: Container(
                                    child: Card(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        splashColor:
                                            Color.fromARGB(255, 234, 205, 125),
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
                                                  color:
                                                      _selectedItemSex == index
                                                          ? Colors.red
                                                          : Colors.transparent),
                                              child: Container(
                                                margin: EdgeInsets.all(5),
                                                height: 60,
                                                width: 60,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: AssetImage(
                                                        "images/sex$index.png"),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              child: Text(
                                                _sex[index],
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: _selectedItemSex ==
                                                            index
                                                        ? Colors.red
                                                        : Colors.white),
                                              ),
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
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  color: Color.fromARGB(255, 6, 223, 176),
                                  onPressed: () {

                                    if (_formKey.currentState.validate()) {

                                      final snackBar = SnackBar(content: Text('Processing Data'));
                                      _scaffoldKey.currentState.showSnackBar(snackBar);

                                      print("Race: ${_race[_selectedItemRace]} Class: ${_class[_selectedItemClass]} Sex: ${_sex[_selectedItemSex]}");
                                      print("RaceNumber $_selectedItemRace, ClassNumber:$_selectedItemClass, SexNumber: $_selectedItemSex");

                                      Map<String, dynamic> characterData = Map();

                                      characterData["name"] = _nameController.text;

                                      characterData["raceNumber"] = _selectedItemRace;
                                      characterData["classNumber"] = _selectedItemClass;
                                      characterData["sexNumber"] = _selectedItemSex;
                                      characterData["race"] = _race[_selectedItemRace];
                                      characterData["class"] = _class[_selectedItemClass];
                                      characterData["sex"] = _sex[_selectedItemSex];

                                      adventureModel.updateCharacter(_adventureId,_playerCharacter["userId"], characterData);


                                      Navigator.pop(context);

                                    }

                                  },
                                  child: Text("Submit"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

            ],
          ),
        );
      },
    );
  }

  _loadCharacter() {
    _nameController.text = _playerCharacter["name"];
    if ((_playerCharacter["raceNumber"] != 404 &&
        _playerCharacter["classNumber"] != 404 &&
        _playerCharacter["sexNumber"] != 404)) {
      _selectedItemRace = _playerCharacter["raceNumber"];
      _selectedItemClass = _playerCharacter["classNumber"];
      _selectedItemSex = _playerCharacter["sexNumber"];
    } else {
      return null;
    }
  }
}
