import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:funny_chat/ui/helpers/theme.dart';
import 'package:funny_chat/ui/helpers/user_status_manager.dart';
import 'di/di_setup.dart';
import 'navigation/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  UserStatusManager().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DISetup(
      child: MaterialApp.router(
        theme: FunnyChatTheme.lightTheme,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
