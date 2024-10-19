import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:namer_app/models/user.dart';
import 'dart:io';

const String USER_COLLECTION = 'Users';

class UserDatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  late final CollectionReference _usersRef;

  UserDatabaseService() {
    _usersRef = _firestore.collection(USER_COLLECTION).withConverter<MyUser>(
            fromFirestore: (snapshots, _) => MyUser.fromJson(
                  snapshots.data()!,
                ),
            toFirestore: (myuser, _) => myuser.toJson());
  }

  Stream<List<MyUser>> getUsers() {
    return _usersRef.snapshots().map(
      (querySnapshot) => querySnapshot.docs.map(
        (doc) => doc.data() as MyUser,
      ).toList(),
    );
  }

  Future<void> addUser(MyUser user) async {
    try {
      await _usersRef.add(user);
    } catch (error) {
      throw Exception('Failed to add user: $error');
    }
  }

  Future<String> uploadProfileImage(File imageFile) async {
    try {
      // Crie uma referência para a imagem de perfil no Firebase Storage
      Reference ref = _storage.ref().child('profile_images/${DateTime.now().millisecondsSinceEpoch}');

      // Faça upload do arquivo de imagem para o Firebase Storage
      await ref.putFile(imageFile);

      // Obtenha a URL de download da imagem enviada
      String imageUrl = await ref.getDownloadURL();

      return imageUrl;
    } catch (error) {
      throw Exception('Failed to upload profile image: $error');
    }
  }

  Future<void> updateUserProfile(MyUser user) async {
  try {
    // Update user profile data in Firestore based on email
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore.collection('Users').where('email', isEqualTo: user.email).get();
    if (querySnapshot.docs.isNotEmpty) {
      // Update the user profile if found
      await _firestore.collection('users').doc(querySnapshot.docs.first.id).update(user.toJson());
    } else {
      throw Exception('User not found');
    }
  } catch (error) {
    throw Exception('Failed to update user profile: $error');
  }
  }

  Future<MyUser> getUserByEmail(String email) async {
  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore.collection('Users').where('email', isEqualTo: email).get();
    if (querySnapshot.docs.isNotEmpty) {
      // Convertendo os dados do documento para um objeto MyUser
      return MyUser.fromJson(querySnapshot.docs.first.data());
    } else {
      throw Exception('User not found');
    }
  } catch (error) {
    throw Exception('Failed to get user by email: $error');
  }
}

Future<void> updateUserProfileWithImage(String email, String imageUrl) async {
  try {
    // Obter o documento do usuário com base no email
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firestore.collection('users').where('email', isEqualTo: email).get();

    if (querySnapshot.docs.isNotEmpty) {
      // Atualizar o perfil do usuário com a nova imagem
      String userId = querySnapshot.docs.first.id;
      await _firestore.collection('users').doc(userId).update({'profileImage': imageUrl});
    } else {
      throw Exception('User not found');
    }
  } catch (error) {
    throw Exception('Failed to update user profile: $error');
  }
}

}
