import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserModel extends Model {
  final GoogleSignIn _gSignIn = GoogleSignIn();
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;

  Map<String, dynamic> userData = Map();

  bool isLoading = false;

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _loadCurrentUser();
  }

  void signOutGoogle() async {

    await _gSignIn.signOut();
    await _auth.signOut();

    firebaseUser = null;
    userData = Map();

    print('Signed out');

    isLoading = false;
    notifyListeners();
  }

//login com o google
  Future<Null> signInGoogle(
      {@required context,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {

    isLoading = true;
    notifyListeners();

    GoogleSignInAccount user = _gSignIn.currentUser;

    if (user == null) {
      user = await _gSignIn.signInSilently();
    }
    if (user == null) {
      user = await _gSignIn.signIn();
    }
    if(await _auth.currentUser() != null){
      isLoading = false;
      notifyListeners();
      await _loadCurrentUser();
    }
    if (await _auth.currentUser() == null) {
      GoogleSignInAuthentication authentication = await user.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: authentication.accessToken,
          idToken: authentication.idToken);

      firebaseUser =
          await _auth.signInWithCredential(credential).then((user) async {
        firebaseUser = user;

        await _loadCurrentUser();

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

          await _loadCurrentUser();

          onSuccess();

          isLoading = false;

          notifyListeners();
        }
        onSuccess();
        await _loadCurrentUser();
        isLoading = false;
        notifyListeners();
      }).catchError((e) {
        onFail();
        isLoading = false;
        notifyListeners();
      });
    }else{
      onSuccess();
      isLoading = false;
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

      userData['id'] = firebaseUser.uid;
      userData['isEmailVerified'] = firebaseUser.isEmailVerified;
      userData['photoUrl'] = firebaseUser.photoUrl;
      userData['providerId'] = firebaseUser.providerId;
      userData['isAnonymous'] = firebaseUser.isAnonymous;

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
  void signIn(
      {@required String email,
      @required String password,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();

    _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((user) async {

      firebaseUser = user;

      await _loadCurrentUser();

      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  //recuperação de senha
  void recoverPass() {}

//salvar usuário no bando.
  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .setData(userData);
  }

  // recuperando dados usuário
  Future<Null> _loadCurrentUser() async {
    if (firebaseUser == null) firebaseUser = await _auth.currentUser();
    if (firebaseUser != null) {
      if (userData["id"] == null) {
        DocumentSnapshot docUser = await Firestore.instance
            .collection("users")
            .document(firebaseUser.uid)
            .get();

        userData = docUser.data;
      }
    }

    notifyListeners();
  }
}
