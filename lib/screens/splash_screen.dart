import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:rpg_assist_app/screens/login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 18, 109, 110),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/background_min.png"), fit: BoxFit.cover)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 350,
                height: 250,
                child: FlareActor("assets/Sword_And_Shield.flr",
                    animation: "Cross Sword"),
              ),
              Container(
                padding: EdgeInsets.only(left: 10),
                width: 100,
                height: 100,
                child:
                    FlareActor("assets/Dice_Loading.flr", animation: "loading"),
              ),
              Padding(
                padding: EdgeInsets.only(top: 50),
                child: Image.asset("images/logo.png",
                    width: 80,
                    fit: BoxFit.fitWidth
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 4)).then((_) {

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()));
    });
  }
}
