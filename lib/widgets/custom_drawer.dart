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
                      children: <Widget>[
                        DrawerTile(
                            Icons.view_list, "Adventures", pageController, 0),
                        DrawerTile(
                            Icons.library_books, "Books", pageController, 1),
                        DrawerTile(
                            Icons.person_outline, "Account", pageController, 2),
                        DrawerTile(Icons.notifications, "Notifications",
                            pageController, 3),
                        DrawerTile(
                            Icons.settings, "Settings", pageController, 4),
                        Container(
                            alignment: Alignment.centerLeft,
                            child: FlatButton.icon(
                              icon: Icon(
                                FontAwesomeIcons.signOutAlt,
                                color: Color.fromARGB(255, 198, 54, 81),
                              ),
                              label: Text(
                                "Sign Out",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Color.fromARGB(255, 198, 54, 81),
                                ),
                              ),
                              //`Text` to display
                              onPressed: () {
                                model.signOutGoogle();
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            LoginScreen()));
                              },
                            )),
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
