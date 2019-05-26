import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rpg_assist_app/models/user_model.dart';
import 'package:rpg_assist_app/screens/login/login_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomNavigationDrawer extends StatelessWidget {
  List<Widget> drawerOptions;

  CustomNavigationDrawer(this.drawerOptions);


  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, userModel) {
        return Drawer(
            child: Container(
          color: Color.fromARGB(255, 34, 17, 51),
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                decoration:
                    BoxDecoration(color: Color.fromARGB(255, 34, 17, 51)),
                currentAccountPicture: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: userModel.userData["photoUrl"] != null
                            ? NetworkImage(userModel.userData["photoUrl"])
                            : AssetImage("images/rpg_icon.png"),
                        fit: BoxFit.fill),
                  ),
                ),
                accountName: Text(userModel.userData["username"] != null
                    ? userModel.userData["username"]
                    : userModel.userData["name"] != null
                        ? userModel.userData["name"]
                        : ""),
                accountEmail: Text(userModel.userData["email"] != null
                    ? userModel.userData["email"]
                    : ""),
              ),
              Divider(
                color: Colors.black,
              ),
              Container(
                padding: EdgeInsets.only(left: 15.0),
                child: Column(
                  children: <Widget>[
                  Column(children: drawerOptions),
                    Container(
                        padding: EdgeInsets.only(top: 15),
                        child: InkWell(
                          onTap: () {
                            userModel.signOutGoogle();
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 15),
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
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ));
      },
    );
  }
}
