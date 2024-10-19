import 'package:firebase_auth/firebase_auth.dart';
import 'package:namer_app/models/user.dart'; // Certifique-se de que este caminho está correto
import 'package:namer_app/services/user_database_service.dart'; // Certifique-se de que este caminho está correto
import 'package:flutter/widgets.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  MyUser? _userFromFirebaseUser(User? user) {
    if (user == null) {
      return null;
    }

    return MyUser(
      name: user.displayName ?? '',
      email: user.email ?? '',
      profileImage: user.photoURL,
    );
  }

  Stream<MyUser?> get user {
    return _auth.authStateChanges().map((User? user) => _userFromFirebaseUser(user));
  }

  Future<MyUser?> signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<MyUser?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<MyUser?> registerWithEmailAndPassword(String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        // Adiciona o usuário à coleção do Firestore
        MyUser myUser = MyUser(name: name, email: email, profileImage: user.photoURL);
        await UserDatabaseService().addUser(myUser);
        return myUser;
      }
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  String getCurrentUserEmail() {
  try {
    User? user = _auth.currentUser;
    return user?.email ?? '';
  } catch (e) {
    print(e.toString());
    return ''; // Retorna uma string vazia se houver erro ao obter o email do usuário
  }
}

String getCurrentUserName() {
  try {
    User? user = _auth.currentUser;
    return user?.displayName ?? '';
  } catch (e) {
    print(e.toString());
    return ''; // Retorna uma string vazia se houver erro ao obter o email do usuário
  }
}

ImageProvider<Object> getCurrentUserProfileImage() {
    User? user = _auth.currentUser;
    if (user != null && user.photoURL != null) {
      // Retorna a imagem do perfil do usuário, se estiver disponível
      return NetworkImage(user.photoURL!);
    } else {
      // Retorna uma imagem de placeholder, se a imagem do perfil não estiver disponível
      return AssetImage('assets/images/placeholder_image.png');
    }
  }

}
