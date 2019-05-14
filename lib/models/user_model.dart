import 'package:rpg_assist_app/screens/home_screen.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserModel extends Model {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _gSignIn = new GoogleSignIn();
  FirebaseUser _firebaseUser;

  final googleSignIn = GoogleSignIn();

  Map<String, dynamic> userData = Map();

  bool isLoading = false;

  void signOutGoogle() {
    _gSignIn.signOut();
    _auth.signOut();
    print('Signed out');
    isLoading = false;
  }

  Future<Null> signInGoogle(BuildContext context) async {

    GoogleSignInAccount googleSignInAccount = _gSignIn.currentUser;

    if (googleSignInAccount == null) {
      googleSignInAccount = await _gSignIn.signIn();
      if (googleSignInAccount != null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen()));
      }
      print("signINGOOGLE2");
    }
    if (await _auth.currentUser() != null) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      print("signFIREBASE");
      GoogleSignInAuthentication authentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: authentication.accessToken,
          idToken: authentication.idToken);

      _firebaseUser =
          await _auth.signInWithCredential(credential).then((user) async {
        _firebaseUser = user;

        print(user.displayName);

        if (_auth != null) {
          final QuerySnapshot result = await Firestore.instance
              .collection("users")
              .where("id", isEqualTo: user.uid)
              .getDocuments();
          final List<DocumentSnapshot> documents = result.documents;
          if (documents.length == 0) {
            Map<String, dynamic> userData = {
              "providerId": user.providerId,
              "id": user.uid,
              "name": user.displayName,
              "photoUrl": user.photoUrl,
              "email": user.email,
              "isAnonymous": user.isAnonymous,
              "isEmailVerified": user.isEmailVerified,
            };
            await _saveUserData(userData);
          }
        }
        isLoading = false;
        notifyListeners();
      }).catchError((e) {
        isLoading = false;
        notifyListeners();
      });
    }
  }

  void signUp(
      {@required Map<String, dynamic> userData,
      @required String password,
      @required VoidCallback onSucess,
      @required VoidCallback onFail}) {
    isLoading = true;
    notifyListeners();
    _auth
        .createUserWithEmailAndPassword(
            email: userData["email"], password: password)
        .then((user) async {
      _firebaseUser = user;
      await _saveUserData(userData);
      onSucess();
      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void signInFacebook() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 10));

    isLoading = false;
    notifyListeners();
  }

  void signIn() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 3));

    isLoading = false;
    notifyListeners();
  }

  void recoverPass() {}

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    print("SALVANDO");
    await Firestore.instance
        .collection("users")
        .document(_firebaseUser.uid)
        .setData(userData);
  }
}
