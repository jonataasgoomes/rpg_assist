import 'package:rpg_assist_app/screens/home_screen.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserModel extends Model {
  final GoogleSignIn _gSignIn = new GoogleSignIn();
  final googleSignIn = GoogleSignIn();
  Map<String, dynamic> userData = Map();
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  FirebaseUser firebaseUser;
  String userId;

  void signOutGoogle() {

    firebaseUser = null;
    userData = Map();

    print('Signed out');


    this.userId = "";


    _gSignIn.signOut();
    _auth.signOut();

    isLoading = false;
    notifyListeners();
  }

//login com o google
  Future<Null> signInGoogle(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    GoogleSignInAccount googleSignInAccount = _gSignIn.currentUser;

    if (googleSignInAccount == null) {
      googleSignInAccount = await _gSignIn.signInSilently();
    }
    if (await _auth.currentUser() != null) {
      firebaseUser = await _auth.currentUser();
      userId = firebaseUser.uid;

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      googleSignInAccount = await _gSignIn.signIn();
      print("Fazendo login com firebase");
      GoogleSignInAuthentication authentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: authentication.accessToken,
          idToken: authentication.idToken);

      firebaseUser = await _auth.signInWithCredential(credential).then((user) async {
        firebaseUser = user;
        this.userId = user.uid;

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen()));

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
          isLoading = false;
          notifyListeners();
        }
        isLoading = false;
        notifyListeners();
      }).catchError((e) {
        isLoading = false;
        notifyListeners();
      });
    }
  }

  //registro do usuário no firebase
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
      firebaseUser = user;
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

//usuário logado?
  bool isLoggedIn() {
    return firebaseUser != null;
  }

  //login com facebook
  void signInFacebook() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 10));

    isLoading = false;
    notifyListeners();
  }

  //login usando credenciais do firebase : email e senha
  void signIn() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 3));

    isLoading = false;
    notifyListeners();
  }

  //recuperação de senha
  void recoverPass() {}

//salvar usuário no bando.
  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    print("SALVANDO");
    await Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .setData(userData);
  }
}
