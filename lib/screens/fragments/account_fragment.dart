import 'package:flutter/material.dart';
import 'package:rpg_assist_app/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class AccountFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget _buildBodyBack() => Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 34, 17, 51),
              Color.fromARGB(255, 44, 100, 124)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
        );

    return ScopedModelDescendant<UserModel>(
      builder: (contex, child, userModel) {
        return Stack(
          children: <Widget>[
            _buildBodyBack(),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        padding: EdgeInsets.only(
                            top: 30, bottom: 1),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.all(15),
                                child: Column(
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        width: 80.0,
                                        height: 80.0,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: userModel.userData[
                                                          "photoUrl"] !=
                                                      null
                                                  ? NetworkImage(userModel
                                                      .userData["photoUrl"])
                                                  : AssetImage(
                                                      "images/rpg_icon.png"),
                                            )),
                                      ),
                                    ),
                                    SizedBox(height: 20,),
                                    Text(
                                        userModel.userData["name"] != null
                                            ? userModel.userData["name"]
                                            : "",
                                        style: TextStyle(color: Colors.white))
                                  ],
                                ),
                              ),
                              Container(
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text("Friends: ",
                                            style:
                                                TextStyle(color: Colors.white,
                                                fontSize: 15)),
                                        Text("12",
                                            style:
                                                TextStyle(color: Colors.white,
                                                    fontSize: 15)),
                                        SizedBox(
                                          width: 25,
                                        ),
                                        Text("Adventures: ",
                                            style:
                                                TextStyle(color: Colors.white,
                                                    fontSize: 15)),
                                        Text("5",
                                            style:
                                                TextStyle(color: Colors.white,
                                                    fontSize: 15)),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      width: 200,
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        color: Color.fromARGB(255, 6, 223, 176),
                                        onPressed: () {},
                                        child: Text("EDIT PROFILE"),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(
                              userModel.userData["masterTitle"] != null
                                  ? userModel.userData["masterTitle"]
                                  : "",
                              maxLines: 2,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
