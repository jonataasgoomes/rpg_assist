import 'package:flutter/material.dart';

class EditPlayerView extends StatefulWidget {
  @override
  _EditPlayerViewState createState() => _EditPlayerViewState();
}

class _EditPlayerViewState extends State<EditPlayerView> {
  int _selectedItemRace, _selectedItemClass;
  List<String> _race = ["Darf","Elf","Human"];
  List<String> _class = ["Warrior","Archer","Mage"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit info"),
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
          Container(
            margin: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Text("Choose a race:",
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                Container(
                  color: Colors.black26,
                  child: GridView.count(
                    childAspectRatio: 0.9,
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
                                print(_selectedItemRace);
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
                                      height: 55,
                                      width: 55,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: AssetImage("images/dwarf-helmet.png"),
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
                Text("Choose a class:",
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                Container(
                  color: Colors.black26,
                  child: GridView.count(
                    childAspectRatio: 0.9,
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
                                splashColor: Color.fromARGB(255, 234, 205, 125),
                                onTap: () {
                                  setState(() {
                                    _selectedItemClass = index;
                                  });
                                  print(_selectedItemClass);
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
                                        height: 55,
                                        width: 55,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: AssetImage("images/dwarf-helmet.png"),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
