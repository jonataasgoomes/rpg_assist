import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rpg_assist_app/screens/adventure/tabs/player/edit_player_view.dart';
import 'package:rpg_assist_app/widgets/popup_menu.dart';
import 'package:scoped_model/scoped_model.dart';

class AdventureModel extends Model {
  DocumentReference _adventureReference, _sessionReference, _characterReference;
  bool isLoading = false;
  bool editMode = false;
  bool isDescending = false;
  bool statusSnackBar = true;

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

  void choiceActionAdventure(String choice, adventureId, playerId, userId, masterId, BuildContext context) {
    if (choice == PopupMenuPlayer.EditPlayer) {
      playerCharacter(adventureId, playerId).then((characterDocument){

        Navigator.push(context, PageTransition(type: PageTransitionType.downToUp, child: EditPlayerView(adventureId,characterDocument)));

      });

      print("editar player");
    } else if (choice == PopupMenuPlayer.Leave) {
      print("Sair da aventura: $adventureId, o player: $playerId");
      _removePlayerFromAdventure(adventureId, playerId, userId,masterId).then( (_){
        Navigator.of(context).pop();
      });
    }else if(choice == PopupMenuMaster.Master){
      print("tranferencia do master");
      _changeMasterAdventure(adventureId, playerId,masterId).then((a){
            print(a);
      });

    }else if(choice == PopupMenuMaster.Remove){
      print("Remover da aventura: $adventureId, o player: $playerId ");
      _removePlayerFromAdventure(adventureId, playerId, userId,masterId);
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
        .document(playerDataAdventure["adventureId"])
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

    _sessionReference = Firestore.instance.collection("adventures").document(adventureId).collection("sessions").document();

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
        .collection("adventures").document(adventureData["adventureId"]).collection("sessions")
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

  rollsAdventure(String adventureId,String sessionId) {
    return Firestore.instance
        .collection("adventures")
        .document(adventureId).collection("sessions").document(sessionId)
        .collection("rolls").orderBy("timestamp",descending: true)
        .snapshots();
  }

  Future<Null> rollDice(String adventureId,String sessionId, String userId, int result) async {
    Map<String, dynamic> rollData = Map();

    rollData["userId"] = userId;
    rollData["result"] = result;
    rollData["timestamp"] = FieldValue.serverTimestamp();

    await Firestore.instance
        .collection("adventures")
        .document(adventureId).collection("sessions").document(sessionId)
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


    //Maneira que eu achei para verificar atributos do player na tela de edição
    playerData["raceNumber"] = 404;
    playerData["classNumber"] = 404;
    playerData["sexNumber"] = 404;

    playerData["str"] = 0;
    playerData["dex"] = 0;
    playerData["int"] = 0;
    playerData["cha"] = 0;
    playerData["con"] = 0;
    playerData["wis"] = 0;



    Map<String, dynamic> playerDataAdventure = Map();
    playerDataAdventure["adventureId"] = adventureId;
    playerDataAdventure["timestamp"] = FieldValue.serverTimestamp();

    _characterReference = Firestore.instance.collection("adventures").document(adventureId).collection("players").document(userId);
    playerData["characterId"] = _characterReference.documentID;


    await Firestore.instance
        .collection("users")
        .document(userId)
        .collection("adventures")
        .document(adventureId)
        .setData(playerDataAdventure);

    await _characterReference
        .setData(playerData);
  }

  Future<Null> updateCharacter(String adventureId,userId, Map<String,dynamic> characterData) async {

    await Firestore.instance.collection("adventures").document(adventureId).collection("players").document(userId).updateData(characterData);


  }

  adventuresPlayers({@required String adventureId}) {
    return Firestore.instance
        .collection("adventures")
        .document(adventureId)
        .collection("players")
        .snapshots();
  }

  Future<QuerySnapshot> adventuresPlayersList({@required String adventureId})async {
    return await Firestore.instance
        .collection("adventures")
        .document(adventureId)
        .collection("players")
        .getDocuments();
  }

  Future<Null> removeAllPlayersAdventure({@required String adventureId, @required masterId})async{
    adventuresPlayersList(adventureId: adventureId).then((query){
      query.documents.toList().forEach((document)async{
        await Firestore.instance.collection("users").document(document["userId"]).collection("adventures").document(adventureId).delete();
      });
    });
    await Firestore.instance.collection("users").document(masterId).collection("adventures").document(adventureId).delete();
    await Firestore.instance.collection("adventures").document(adventureId).delete();


  }

  Future<Null> updateCharacterField(String statusField, value, adventureDoc, characterData) async {

    Map<String,dynamic> data = Map();
    data[statusField] = value;
    await Firestore.instance.collection("adventures").document(adventureDoc).collection("players").document(characterData).updateData(data);


  }

  Future<Null>_removePlayerFromAdventure(String adventureId, playerId, userId, masterId) async {

    await Firestore.instance.collection("adventures").document(adventureId).collection("players").document(playerId).delete();
    if(playerId != masterId){
      _removeAdventureFromUser(adventureId, playerId, userId);
    }


  }

  Future<Null>_removeAdventureFromUser(String adventureId, playerId, userId) async {

    await Firestore.instance.collection("users").document(userId).collection("adventures").document(adventureId).delete();

  }

  Future<Null>_changeMasterAdventure (String adventureId,playerId,masterId) async {

    Map<String, dynamic> data = Map();
    data["master"] = playerId;

    await Firestore.instance.collection("adventures").document(adventureId).updateData(data);

  }

}
