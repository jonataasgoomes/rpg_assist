import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rpg_assist_app/models/adventure_model.dart';
import 'package:rpg_assist_app/models/user_model.dart';
import 'package:rpg_assist_app/tiles/drawer_tile.dart';
import 'package:rpg_assist_app/widgets/custom_navigation_drawer.dart';
import 'package:rpg_assist_app/widgets/popup_menu.dart';
import 'package:scoped_model/scoped_model.dart';
import 'fragments/account_fragment.dart';
import 'fragments/books_fragment.dart';
import 'fragments/home_fragment.dart';
import 'fragments/notifications_fragments.dart';
import 'fragments/settings_fragments.dart';

class InfoTile {
  String title;
  IconData icon;

  InfoTile(this.icon, this.title);
}

class HomeScreen extends StatefulWidget {
  final drawerItems = [
    InfoTile(Icons.view_list, "Adventures"),
    InfoTile(Icons.library_books, "Books"),
    InfoTile(Icons.person_outline, "Account"),
    InfoTile(Icons.notifications, "Notifications"),
    InfoTile(Icons.settings, "Settings"),
  ];

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return HomeFragment();
      case 1:
        return BooksFragment();
      case 2:
        return AccountFragment();
      case 3:
        return NotificationsFragment();
      case 4:
        return SettingsFragment();

      default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(DrawerTile(
          d.icon, d.title, () => _onSelectItem(i), i, _selectedDrawerIndex));
    }
    return ScopedModelDescendant<UserModel>(
      builder: (context,child,userModel){
        return ScopedModelDescendant<AdventureModel>(
          builder: (context, child, adventureModel) {
            return WillPopScope(
                child: Scaffold(
                  key: _scaffoldKey,
                  appBar: (AppBar(
                    actions: <Widget>[
                      PopupMenuButton<String>(onSelected: (String choice) {
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
                      })
                    ],
                    backgroundColor: Color.fromARGB(255, 34, 17, 51),
                    title: Image.asset(
                      "images/logo.png",
                      height: 20,
                    ),
                    centerTitle: true,
                    iconTheme: IconThemeData(color: Color.fromARGB(255, 234, 205, 125)),
                  )),
                  body: _getDrawerItemWidget(_selectedDrawerIndex),
                  drawer: CustomNavigationDrawer(drawerOptions),
                ),
                onWillPop: (){
                  return showDialog(context: context,
                      barrierDismissible: false,
                      builder: (context){
                        return AlertDialog(
                          title: Text("Confirm Exit"),
                          content: Text("Are you sure you want to exit?"),
                          actions: <Widget>[
                            FlatButton(onPressed: (){
                              Navigator.of(context).pop();
                            }, child: Text("NO"),
                            ),
                            FlatButton(onPressed: (){
                              SystemNavigator.pop();
                            }, child: Text("YES"),
                            ),
                          ],
                        );
                      }
                  );
                }
            );
          },
        );
      },
    );
  }

}
