import 'package:flutter/material.dart';
import 'package:rpg_assist_app/screens/splash_screen.dart';
import 'package:scoped_model/scoped_model.dart';

import 'models/adventure_model.dart';
import 'models/user_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModel(
          model: AdventureModel(),
          child: MaterialApp(
            theme: ThemeData(
              accentColor: Color.fromARGB(255, 34, 17, 51),
              fontFamily: 'FiraSans'
            ),
            title: 'RPG Assistant',
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
          ),)
    );
  }
}
