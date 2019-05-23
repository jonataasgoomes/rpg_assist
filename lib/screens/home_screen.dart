import 'package:flutter/material.dart';
import 'package:rpg_assist_app/tabs/home_tab.dart';
import 'package:rpg_assist_app/screens/adventure/new_adventure_screen.dart';
import 'package:rpg_assist_app/widgets/custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();


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
                onPressed: (){
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context)=>NewAdventureScreen()));
                },
                child: Container(
                  child: Image.asset("images/new_adventure.png"),
                ),
              )
          ),
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
