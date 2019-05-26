import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rpg_assist_app/models/user_model.dart';
import 'package:rpg_assist_app/screens/login/login_screen.dart';
import 'package:rpg_assist_app/tiles/drawer_tile.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomDrawer extends StatelessWidget {
  final PageController pageController;

  CustomDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        return Drawer(
          child: Stack(
            children: <Widget>[
              Container(
                color: Color.fromARGB(255, 34, 17, 51),
              ),
              ListView(
                children: <Widget>[
                  Container(
                    child: Image.asset(
                      "images/background_sliver_bar.png",
                      fit: BoxFit.cover,
                    ),
                    color: Color.fromARGB(255, 34, 17, 51),
                    height: 150,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 15),
                            child: InkWell(
                              onTap: (){
                                model.signOutGoogle();
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            LoginScreen()));
                              },
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    FontAwesomeIcons.signOutAlt,
                                    color: Color.fromARGB(255, 198, 54, 81),
                                  ),
                                  SizedBox(
                                    width: 35,
                                  ),
                                  Text(
                                    "Sign Out",
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Color.fromARGB(255, 198, 54, 81),
                                    ),
                                  ),
                                ],
                              ),
                            )
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
