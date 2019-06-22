import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'character_card.dart';
import 'combat.dart';
import 'messages.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class PlayerScreen extends StatefulWidget {
  final DocumentSnapshot adventureDoc, userPlayerData, playerData;
  final Map<String, dynamic> userLogged;

  PlayerScreen(
      this.adventureDoc, this.userPlayerData, this.userLogged, this.playerData);

  @override
  _PlayerScreenState createState() =>
      _PlayerScreenState(adventureDoc, userPlayerData, userLogged, playerData);
}

class _PlayerScreenState extends State<PlayerScreen> {
  final DocumentSnapshot adventureDoc, userPlayerData, playerData;
  final Map<String, dynamic> userLogged;

  _PlayerScreenState(
      this.adventureDoc, this.userPlayerData, this.userLogged, this.playerData);

  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 34, 17, 51),
          title: Image.asset(
            "images/logo.png",
            height: 20,
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Color.fromARGB(255, 234, 205, 125)),
          actions: <Widget>[PopupMenuButton(itemBuilder: (_) {})],
        ),
        body: _buildBody());
  }

  _buildBody() {
    return Stack(
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
        _buildPageView(),
        _buildCircleIndicator(),
      ],
    );
  }

  _buildPageView() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (int index) {
            _currentPageNotifier.value = index;
          },
          children: <Widget>[
            CharacterCard(adventureDoc, userPlayerData, userLogged, playerData),
            Combat(adventureDoc, userLogged),
            Messages(),
          ],
        ),
      ),
    );
  }

  _buildCircleIndicator() {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: CirclePageIndicator(
          dotColor: Colors.white,
          selectedDotColor: Color.fromARGB(255, 6, 223, 176),
          itemCount: 3,
          currentPageNotifier: _currentPageNotifier,
        ),
      ),
    );
  }
}
