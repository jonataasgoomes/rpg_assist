import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class AdventureModel extends Model {
  DocumentReference _adventureReference, _sessionReference;
  bool isLoading = false;

  Map<String, dynamic> adventureData;
  Map<String, dynamic> sessionData;

  Future<Null> registerAdventure(
      {@required Map<String, dynamic> adventureData,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail,
      @required String userId}) async {

    this.adventureData = adventureData;

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

    _adventureReference = Firestore.instance.collection("adventures").document();

    adventureData["adventureId"] = _adventureReference.documentID;

    await _adventureReference.setData(adventureData)
        .catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });

    onSuccess();
    isLoading = false;
    notifyListeners();
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

    if(sessionData["date"] == null) sessionData["date"] = DateTime.now();


    _sessionReference = Firestore.instance.collection("sessions").document();

    sessionData["sessionId"] = _sessionReference.documentID;

    await _sessionReference.setData(sessionData)
        .catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });

    onSuccess();
    isLoading = false;
    notifyListeners();
  }





  //Busca todos os cards em que o usuário é mestre
  Future<QuerySnapshot> adventuresCards(String id, {bool descending = true}) async {
    return await Firestore.instance
        .collection("adventures")
        .where("master", isEqualTo: id)
        .orderBy("timestamp",descending: descending)
        .getDocuments();
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
    return Firestore.instance.collection("sessions").where("adventure",isEqualTo: adventureData["adventureId"] ).snapshots();
}

  Future<Null>addPlayersOnAdventure({@required String adventureId, @required userId}) async{

    Map<String,dynamic> playerData = Map();
    playerData["userId"] = userId;

    await Firestore.instance
        .collection("adventures").document(adventureId)
        .collection("players").document().setData(playerData);

  }

  adventuresPlayers({@required String adventureId}){
    return Firestore.instance
        .collection("adventures").document(adventureId)
        .collection("players").snapshots();
  }
 

}
