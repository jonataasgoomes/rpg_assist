import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rpg_assist_app/widgets/popup_menu.dart';
import 'package:scoped_model/scoped_model.dart';

class AdventureModel extends Model {
  DocumentReference _adventureReference, _sessionReference, _characterReference;
  bool isLoading = false;
  bool editMode = false;
  bool isDescending = false;

  Map<String, dynamic> adventureData;
  Map<String, dynamic> sessionData;

  void choiceAction(String choice) {
    if (choice == PopupMenu.Edit) {
      if (editMode == false) {
        editMode = true;
      } else {
        editMode = false;
      }
    } else if (choice == PopupMenu.Order) {
      if (isDescending == false) {
        isDescending = true;
      } else {
        isDescending = false;
      }
    }
  }

  Future<Null> registerAdventure(
      {@required Map<String, dynamic> adventureData,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail,
      @required String userId}) async {
    this.adventureData = adventureData;
    Map<String, dynamic> playerDataAdventure = Map();

    Random seed = Random();
    const int MAX_VALUE = 4;
    int photoNumber = seed.nextInt(MAX_VALUE);

    isLoading = true;
    notifyListeners();

    adventureData["master"] = userId;
    adventureData["progress"] = null;
    adventureData["nextSession"] = null;
    adventureData["photoNumber"] = photoNumber.toString();
    adventureData["timestamp"] = FieldValue.serverTimestamp();

    _adventureReference =
        Firestore.instance.collection("adventures").document();

    adventureData["adventureId"] = _adventureReference.documentID;

    await _adventureReference.setData(adventureData).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });

    onSuccess();
    isLoading = false;
    notifyListeners();

    playerDataAdventure["adventureId"] = adventureData["adventureId"];
    playerDataAdventure["timestamp"] = adventureData["timestamp"];

    await Firestore.instance
        .collection("users")
        .document(userId)
        .collection("adventures")
        .document()
        .setData(playerDataAdventure);
  }

  Future<Null> registerSession(
      {@required Map<String, dynamic> sessionData,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail,
      @required String adventureId}) async {
    this.sessionData = sessionData;

    isLoading = true;
    notifyListeners();
    sessionData["adventure"] = adventureId;
    sessionData["timestamp"] = FieldValue.serverTimestamp();

    if (sessionData["date"] == null) sessionData["date"] = DateTime.now();

    _sessionReference = Firestore.instance.collection("sessions").document();

    sessionData["sessionId"] = _sessionReference.documentID;

    await _sessionReference.setData(sessionData).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });

    onSuccess();
    isLoading = false;
    notifyListeners();
  }

  adventureCardsId(String userId) {
    return Firestore.instance
        .collection("users")
        .document(userId)
        .collection("adventures")
        .orderBy("timestamp", descending: isDescending)
        .snapshots();
  }

  //Busca todos os cards em que o usuário é mestre
  Future<DocumentSnapshot> adventuresCard(String adventureId) async {
    return await Firestore.instance
        .collection("adventures")
        .document(adventureId)
        .get();
  }

  //Busca quem é o mestre da aventura;
  Future<QuerySnapshot> masterAdventure(adventureData) async {
    return await Firestore.instance
        .collection("users")
        .where("id", isEqualTo: adventureData["master"])
        .getDocuments();
  }

  //Busca todas as sessions de uma aventura
  sessionsAdventure(adventureData) {
    return Firestore.instance
        .collection("sessions")
        .where("adventure", isEqualTo: adventureData["adventureId"])
        .snapshots();
  }

  Future<DocumentSnapshot>playerCharacter(String adventureId,playerId) {
    return Firestore.instance
        .collection("adventures")
        .document(adventureId)
        .collection("players")
        .document(playerId)
        .get();
  }
  playerCharacterStream(String adventureId,playerId) {
    return Firestore.instance
        .collection("adventures")
        .document(adventureId)
        .collection("players")
        .document(playerId)
        .snapshots();
  }

  rollsAdventure(String adventureId) {
    return Firestore.instance
        .collection("adventures")
        .document(adventureId)
        .collection("rolls").orderBy("timestamp",descending: true)
        .snapshots();
  }

  Future<Null> rollDice(String adventureId, String userId, int result) async {
    Map<String, dynamic> rollData = Map();

    rollData["userId"] = userId;
    rollData["result"] = result;
    rollData["timestamp"] = FieldValue.serverTimestamp();

    await Firestore.instance
        .collection("adventures")
        .document(adventureId)
        .collection("rolls")
        .document()
        .setData(rollData);
  }

  Future<Null> addPlayersOnAdventure(
      {@required String adventureId, @required userId}) async {
    Map<String, dynamic> playerData = Map();

    playerData["userId"] = userId;

    playerData["hp"] = 0;
    playerData["xp"] = 0;
    playerData["level"] = 0;

    playerData["name"] = "";
    playerData["race"] = "";
    playerData["class"] = "";
    playerData["sex"] = "";

    playerData["str"] = 0;
    playerData["dex"] = 0;
    playerData["int"] = 0;
    playerData["cha"] = 0;
    playerData["con"] = 0;
    playerData["wis"] = 0;



    Map<String, dynamic> playerDataAdventure = Map();
    playerDataAdventure["adventureId"] = adventureId;
    playerDataAdventure["timestamp"] = FieldValue.serverTimestamp();

    _characterReference = Firestore.instance.collection("adventures").document(adventureId).collection("players").document();
    playerData["characterId"] = _characterReference.documentID;


    await Firestore.instance
        .collection("users")
        .document(userId)
        .collection("adventures")
        .document()
        .setData(playerDataAdventure);

    await _characterReference
        .setData(playerData);
  }

  adventuresPlayers({@required String adventureId}) {
    return Firestore.instance
        .collection("adventures")
        .document(adventureId)
        .collection("players")
        .snapshots();
  }

  Future<Null> updateCharacterField(String statusField, value, adventureDoc, characterData) async {

    Map<String,dynamic> data = Map();
    data[statusField] = value;
    await Firestore.instance.collection("adventures").document(adventureDoc).collection("players").document(characterData).updateData(data);


  }
}
