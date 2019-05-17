import 'package:flutter/material.dart';
import 'package:rpg_assist_app/tabs/home_tab.dart';
import 'package:rpg_assist_app/tabs/new_adventure_tab.dart';
import 'package:rpg_assist_app/widgets/custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _imageFloatingButton = "";
  final _pageController = PageController();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  VoidCallback _showNewAdventureBottomSheetCallBack;

  @override
  void initState() {
    super.initState();
    _imageFloatingButton = "new_adventure.png";
    _showNewAdventureBottomSheetCallBack = _showBottomSheet;
  }

  void _showBottomSheet() {
    setState(() {
      _imageFloatingButton = "exit_adventure.png";
      _showNewAdventureBottomSheetCallBack = _closeBottomSheet;
    });
    _scaffoldKey.currentState
        .showBottomSheet((context) {
          return NewAdventureTab();
        })
        .closed
        .whenComplete(() {
          setState(() {
            _imageFloatingButton = "new_adventure.png";
          });

          if (mounted) {
            _showNewAdventureBottomSheetCallBack = _showBottomSheet;
          }
        });
  }
  void _closeBottomSheet() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          key: _scaffoldKey,
          body: HomeTab(),
          drawer: CustomDrawer(_pageController),
          floatingActionButton: Container(
              width: 80.0,
              height: 80.0,
              child: FloatingActionButton(
                backgroundColor: Colors.transparent,
                onPressed: _showNewAdventureBottomSheetCallBack,
                child: Container(
                  child: Image.asset("images/$_imageFloatingButton"),
                ),
              )),
        ),
        Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Color.fromARGB(255, 234, 205, 125)),
            backgroundColor: Color.fromARGB(255, 34, 17, 51),
            title: const Text(
              "Books",
              style: TextStyle(
                  fontFamily: "IndieFlower",
                  color: Color.fromARGB(255, 234, 205, 125),
                  fontSize: 20.0),
            ),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: Container(
            color: Color.fromARGB(255, 34, 17, 51),
          ),
        ),
        Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Color.fromARGB(255, 234, 205, 125)),
            backgroundColor: Color.fromARGB(255, 34, 17, 51),
            title: const Text(
              "Account",
              style: TextStyle(
                  fontFamily: "IndieFlower",
                  color: Color.fromARGB(255, 234, 205, 125),
                  fontSize: 20.0),
            ),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: Container(
            color: Color.fromARGB(255, 34, 17, 51),
          ),
        ),
        Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Color.fromARGB(255, 234, 205, 125)),
            backgroundColor: Color.fromARGB(255, 34, 17, 51),
            title: const Text(
              "Notifications",
              style: TextStyle(
                  fontFamily: "IndieFlower",
                  color: Color.fromARGB(255, 234, 205, 125),
                  fontSize: 20.0),
            ),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: Container(
            color: Color.fromARGB(255, 34, 17, 51),
          ),
        ),
        Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Color.fromARGB(255, 234, 205, 125)),
            backgroundColor: Color.fromARGB(255, 34, 17, 51),
            title: const Text(
              "Settings",
              style: TextStyle(
                  fontFamily: "IndieFlower",
                  color: Color.fromARGB(255, 234, 205, 125),
                  fontSize: 20.0),
            ),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: Container(
            color: Color.fromARGB(255, 34, 17, 51),
          ),
        ),
      ],
    );
  }
}
