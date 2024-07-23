import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../ui/constants/app_strings.dart';
import '../ui/constants/firebase_paths.dart';

class RegisterRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _databaseRef = FirebasePaths.databaseRef;

  Future<void> register(String username, String password) async {
    DataSnapshot userSnapshot = await _databaseRef
        .child(AppStrings.chatUsers)
        .orderByChild(AppStrings.name)
        .equalTo(username)
        .get();

    if (userSnapshot.value == null) {
      await _auth.signOut();

      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        UserCredential userCredential = await _auth.signInAnonymously();
        currentUser = userCredential.user;
      }

      await _databaseRef.child(AppStrings.chatUsers).child(currentUser!.uid).set({
        AppStrings.name: username,
        AppStrings.password: password,
        AppStrings.uid: currentUser.uid,
      });
    } else {
      throw Exception('The name is already taken');
    }
  }
}
