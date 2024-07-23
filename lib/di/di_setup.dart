import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth_bloc.dart';
import '../blocs/chat_bloc.dart';
import '../blocs/chat_list_bloc.dart';
import '../repositories/auth_repository.dart';
import '../repositories/chat_list_repository.dart';
import '../repositories/chat_repository.dart';

class DISetup extends StatelessWidget {
  final Widget child;

  const DISetup({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider<ChatListRepository>(
          create: (context) => ChatListRepository(),
        ),
        RepositoryProvider<ChatRepository>(
          create: (context) => ChatRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: RepositoryProvider.of<AuthRepository>(context),
            ),
          ),
          BlocProvider<ChatListBloc>(
            create: (context) => ChatListBloc(
              chatListRepository: RepositoryProvider.of<ChatListRepository>(context), userId: '',
            ),
          ),
          BlocProvider<ChatBloc>(
            create: (context) => ChatBloc(
              chatRepository: RepositoryProvider.of<ChatRepository>(context),
              userId: '',
              chatId: '',
            ),
          ),
        ],
        child: child,
      ),
    );
  }
}
