import 'package:funny_chat/ui/screens/register_screen.dart';
import 'package:funny_chat/ui/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';
import '../ui/constants/app_strings.dart';
import '../ui/screens/auth_screen.dart';
import '../ui/screens/chat_list_screen.dart';
import '../ui/screens/chat_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: AppStrings.authScreenPath,
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: AppStrings.registerScreenPath,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: AppStrings.chatListScreenPath,
      builder: (context, state) {
        final userId = state.extra as String?;
        return ChatListScreen(userId: userId!);
      },
    ),
    GoRoute(
      path: AppStrings.chatScreenPath,
      builder: (context, state) {
        final chatId = state.pathParameters[AppStrings.chatId]!;
        final extra = state.extra as Map<String, dynamic>;
        final userId = extra[AppStrings.userId] as String;
        return ChatScreen(chatId: chatId, userId: userId);
      },
    ),
  ],
);
