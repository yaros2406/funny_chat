import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ui/constants/app_strings.dart';
import '../ui/constants/firebase_paths.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _databaseRef = FirebasePaths.databaseRef;

  Future<String> login(String username, String password) async {
    DatabaseReference usersRef = _databaseRef.child(AppStrings.chatUsers);
    DatabaseEvent userEvent = await usersRef.orderByChild(AppStrings.name).equalTo(username).once();

    if (userEvent.snapshot.exists) {
      Map<dynamic, dynamic> users = userEvent.snapshot.value as Map<dynamic, dynamic>;
      var userKey = users.keys.firstWhere((key) => users[key][AppStrings.password] == password, orElse: () => null);

      if (userKey != null) {
        UserCredential userCredential;

        if (_auth.currentUser == null) {
          userCredential = await _auth.signInAnonymously();
        } else {
          userCredential = await _auth.signInAnonymously();
        }

        await usersRef.child(userKey).update({
          AppStrings.uid: userCredential.user?.uid,
        });

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppStrings.userKey, userKey);

        return userKey;
      } else {
        throw Exception('Invalid username or password');
      }
    } else {
      throw Exception('Invalid username or password');
    }
  }

  Future<void> register(String username, String password) async {
    QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection(AppStrings.chatUsers)
        .where(AppStrings.name, isEqualTo: username)
        .get();

    if (userSnapshot.docs.isEmpty) {
      await _auth.signOut();
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        UserCredential userCredential = await _auth.signInAnonymously();
        currentUser = userCredential.user;
      }

      await FirebaseFirestore.instance.collection(AppStrings.chatUsers).doc(currentUser?.uid).set({
        AppStrings.name: username,
        AppStrings.password: password,
        AppStrings.uid: currentUser?.uid
      });
    } else {
      throw Exception('Username already taken');
    }
  }
}
