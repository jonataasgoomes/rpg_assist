import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rpg_assist_app/screens/adventure/tabs/player/edit_player_view.dart';
import 'package:rpg_assist_app/widgets/popup_menu.dart';
import 'package:scoped_model/scoped_model.dart';

class AdventureModel extends Model {
  DocumentReference _adventureReference,
      _sessionReference,
      _characterReference,
      _rollReference;
  bool isLoading = false;
  bool editMode = false;
  bool isDescending = false;
  bool statusSnackBar = true;

  Map<String, dynamic> adventureData;
  Map<String, dynamic> sessionData;

  void choiceAction(String choice) {
    if (choice == PopupMenuAdventure.Edit) {
      if (editMode == false) {
        editMode = true;
      } else {
        editMode = false;
      }
    } else if (choice == PopupMenuAdventure.Order) {
      if (isDescending == false) {
        isDescending = true;
      } else {
        isDescending = false;
      }
    }
  }



  /*------------------------------------------------------------------------------------------------------*/

  Future choiceActionAdventure(String choice, adventureId, playerId, userId,
      masterId, BuildContext context) async {



    if (choice == PopupMenuPlayer.EditPlayer) {
      playerCharacter(adventureId, playerId).then((characterDocument) {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.downToUp,
                child: EditPlayerView(adventureId, characterDocument)));
      });




    } else if (choice == PopupMenuPlayer.Leave) {
      final bool result = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("CONFIRM"),
              content: Text(
                  "Are you sure you wish kill this character to adventure?"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("CANCEL")),
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text(
                    "KILL",
                    style: TextStyle(color: Colors.red),
                  ),
                )
              ],
            );
          });
      if (result) {
        _removePlayerFromAdventure(adventureId, playerId, userId, masterId)
            .then((_) {
          Navigator.of(context).pop();
        });
      } else {
        return result;
      }



    } else if (choice == PopupMenuMaster.Master) {
      print("tranferencia do master");
      _changeMasterAdventure(adventureId, userId, masterId).then((a) {
        Navigator.pop(context);
      });



    } else if (choice == PopupMenuMaster.Remove) {
      final bool result = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("CONFIRM DEATH"),
              content: Text(
                  "Are you sure you wish kill this player character? This action will kill him!!"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("CANCEL")),
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text(
                    "KILL",
                    style: TextStyle(color: Colors.red),
                  ),
                )
              ],
            );
          });
      if (result) {
        _removePlayerFromAdventure(adventureId, playerId, userId, masterId)
            .then((_) {
        });
      } else {
        return result;
      }
    }
  }

  /*------------------------------------------------------------------------------------------------------*/


  Future<Null> updateAdventure (Map<String,dynamic> adventureData, String adventureId) async{

   Firestore.instance.collection("adventures").document(adventureId).updateData(adventureData);

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
    adventureData["summary"] = "";
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
    sessionData["status"] = 0;

    if (sessionData["date"] == null) sessionData["date"] = DateTime.now();

    _sessionReference = Firestore.instance
        .collection("adventures")
        .document(adventureId)
        .collection("sessions")
        .document();

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
        .collection("adventures")
        .document(adventureData["adventureId"])
        .collection("sessions")
        .where("adventure", isEqualTo: adventureData["adventureId"])
        .orderBy("date", descending: false)
        .snapshots();
  }

  Future<DocumentSnapshot> playerCharacter(String adventureId, playerId) {
    return Firestore.instance
        .collection("adventures")
        .document(adventureId)
        .collection("players")
        .document(playerId)
        .get();
  }

  playerCharacterStream(String adventureId, playerId) {
    return Firestore.instance
        .collection("adventures")
        .document(adventureId)
        .collection("players")
        .document(playerId)
        .snapshots();
  }

  rollsAdventure(String adventureId, String sessionId) {
    return Firestore.instance
        .collection("adventures")
        .document(adventureId)
        .collection("sessions")
        .document(sessionId)
        .collection("rolls")
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  Future<Null> rollDice(
      String adventureId, String sessionId, String userId,String characterId, int result) async {
    Map<String, dynamic> rollData = Map();
    rollData["timestamp"] = FieldValue.serverTimestamp();
    rollData["userId"] = userId;
    rollData["characterId"] = characterId;
    rollData["result"] = result;

    _rollReference = Firestore.instance
        .collection("adventures")
        .document(adventureId)
        .collection("sessions")
        .document(sessionId)
        .collection("rolls")
        .document();

    await _rollReference.setData(rollData);
  }

  Future<Null> addPlayersOnAdventure(
      {@required String adventureId, @required userId}) async {
    Map<String, dynamic> playerData = Map();

    playerData["userId"] = userId;
    
    playerData["status"] = 0;

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

    _characterReference = Firestore.instance
        .collection("adventures")
        .document(adventureId)
        .collection("players")
        .document();



    playerData["characterId"] = _characterReference.documentID;

    await Firestore.instance
        .collection("users")
        .document(userId)
        .collection("adventures")
        .document(adventureId)
        .setData(playerDataAdventure);

    await _characterReference.setData(playerData);
  }



  Future<Null> addPlayersOnAdventureMaster(
      {@required String adventureId, @required userId}) async {
    Map<String, dynamic> playerData = Map();

    playerData["userId"] = userId;

    playerData["status"] = 0;

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

    _characterReference = Firestore.instance
        .collection("adventures")
        .document(adventureId)
        .collection("players")
        .document(userId);



    playerData["characterId"] = _characterReference.documentID;

    await Firestore.instance
        .collection("users")
        .document(userId)
        .collection("adventures")
        .document(adventureId)
        .setData(playerDataAdventure);

    await _characterReference.setData(playerData);
  }





  Future<Null> updateCharacter(
      String adventureId, userId, Map<String, dynamic> characterData) async {
    await Firestore.instance
        .collection("adventures")
        .document(adventureId)
        .collection("players")
        .document(userId)
        .updateData(characterData);
  }

  adventuresPlayersLive({@required String adventureId}) {
    return Firestore.instance
        .collection("adventures")
        .document(adventureId)
        .collection("players").where("status", isEqualTo: 0)
        .snapshots();
  }

  Future<QuerySnapshot> adventuresPlayersList(
      {@required String adventureId}) async {
    return await Firestore.instance
        .collection("adventures")
        .document(adventureId)
        .collection("players")
        .getDocuments();
  }

  Future<Null> removeAllPlayersAdventure({@required String adventureId, @required masterId}) async {


    adventuresPlayersList(adventureId: adventureId).then((query) {

      query.documents.toList().forEach((document) async {

        await Firestore.instance
            .collection("users")
            .document(document["userId"])
            .collection("adventures")
            .document(adventureId)
            .delete();
      });

    });
    await Firestore.instance
        .collection("users")
        .document(masterId)
        .collection("adventures")
        .document(adventureId)
        .delete();
    await Firestore.instance
        .collection("adventures")
        .document(adventureId)
        .delete();
  }

  Future<Null> updateCharacterField(
      String statusField, value, adventureDoc, characterData) async {
    Map<String, dynamic> data = Map();
    data[statusField] = value;
    await Firestore.instance
        .collection("adventures")
        .document(adventureDoc)
        .collection("players")
        .document(characterData)
        .updateData(data);
  }



  /*Busca todos os characters do player na aventura*/
  Future<QuerySnapshot> allPlayerCharacter(String adventureId, String userId)async{
    return await Firestore.instance.collection("adventures").document(adventureId).collection("players")
        .where("userId", isEqualTo: userId)
        .where("status", isEqualTo: 0)
        .getDocuments();

  }



  Future<Null> _removePlayerFromAdventure(
      String adventureId, playerId, userId, masterId) async {
      Map<String,dynamic> data = Map();
      data["status"] = 1;

    await Firestore.instance
        .collection("adventures")
        .document(adventureId)
        .collection("players")
        .document(playerId)
        .updateData(data);
  }

  Future<Null> removeAdventureFromUser(
      String adventureId, userId) async {
    await Firestore.instance
        .collection("users")
        .document(userId)
        .collection("adventures")
        .document(adventureId)
        .delete();
  }
  Future<Null> removeSessionAdventure(String adventureId, String sessionId) async{

    await Firestore.instance.collection("adventures").document(adventureId).collection("sessions").document(sessionId).delete();

  }

  Future<Null> changeSessionStatus(sessionStatus,sessionId,adventureId)async{
    Map<String,dynamic> data = Map();

    data["status"] = sessionStatus;

    await Firestore.instance.collection("adventures").document(adventureId).collection("sessions").document(sessionId).updateData(data);

  }



  Future<Null> _changeMasterAdventure(
      String adventureId, playerId, masterId) async {
    Map<String, dynamic> data = Map();
    data["master"] = playerId;


    addPlayersOnAdventureMaster(adventureId: adventureId, userId: masterId);

    await Firestore.instance
        .collection("adventures")
        .document(adventureId)
        .updateData(data);
  }
}
