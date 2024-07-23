import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:funny_chat/ui/constants/firebase_paths.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_strings.dart';

class UserStatusManager {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _statusRef = FirebasePaths.statusRef;
  final online = AppStrings.online;
  final offline = AppStrings.offline;
  final userStatus = AppStrings.status;
  final lastChanged = AppStrings.lastChanged;
  String? _userKey;

  void initialize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userKey = prefs.getString(AppStrings.userKey);

    if (_userKey != null) {
      _setUserStatus(_userKey!, online);
    }

    _auth.userChanges().listen((User? user) {
      if (_userKey != null) {
        _setUserStatus(_userKey!, online);
        _auth.idTokenChanges().listen((User? user) {
          if (_userKey != null) {
            _setUserStatus(_userKey!, online);
          }
        });

        FirebasePaths.connectRef.onValue.listen((event) {
          final connected = event.snapshot.value as bool? ?? false;
          if (connected) {
            _statusRef.child(_userKey!).onDisconnect().set({
              userStatus: offline,
              lastChanged: ServerValue.timestamp,
            }).then((_) {
              _setUserStatus(_userKey!, online);
            });
          }
        });
      }
    });

    _auth.idTokenChanges().listen((User? user) {
      if (user == null && _userKey != null) {
        _setUserStatus(_userKey!, offline);
      }
    });
  }

  void _setUserStatus(String userKey, String status) {
    if (userKey.isNotEmpty) {
      _statusRef.child(userKey).set({
        userStatus: status,
        lastChanged: ServerValue.timestamp,
      });
    }
  }
}
