import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class AdventureModel extends Model {
  bool isLoading = false;

  Map<String, dynamic> adventureData;

  Future<Null> registerAdventure(
      {@required Map<String, dynamic> adventureData,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail,
      @required String id}) async {

    this.adventureData = adventureData;

    Random seed = Random();
    const int MAX_VALUE = 4;
    int photoNumber = seed.nextInt(MAX_VALUE);

    isLoading = true;
    notifyListeners();

    adventureData["master"] = id;
    adventureData["progress"] = null;
    adventureData["nextSession"] = null;
    adventureData["photoNumber"] = photoNumber.toString();
    adventureData["timestamp"] = FieldValue.serverTimestamp();

    await Firestore.instance
        .collection("adventures").add(adventureData)
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
}
