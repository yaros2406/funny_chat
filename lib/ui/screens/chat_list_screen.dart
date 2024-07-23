import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:funny_chat/blocs/chat_list_bloc.dart';
import 'package:funny_chat/repositories/chat_list_repository.dart';
import 'package:funny_chat/ui/constants/app_strings.dart';
import 'package:funny_chat/ui/constants/app_numbers.dart';
import '../../widgets/chat_list_widgets/chat_list_body.dart';
import '../../widgets/chat_list_widgets/search_text_field.dart';

class ChatListScreen extends StatefulWidget {
  final String userId;

  const ChatListScreen({super.key, required this.userId});

  @override
  ChatListScreenState createState() => ChatListScreenState();
}

class ChatListScreenState extends State<ChatListScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ChatListRepository(),
      child: BlocProvider<ChatListBloc>(
        create: (context) => ChatListBloc(
          chatListRepository: RepositoryProvider.of<ChatListRepository>(context),
          userId: widget.userId,
        )..add(LoadChatList(widget.userId)),
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(AppNumbers.appBarHeight),
            child: AppBar(
              elevation: AppNumbers.zero,
              flexibleSpace: Padding(
                padding: const EdgeInsets.only(
                  top: AppNumbers.paddingTop,
                  left: AppNumbers.paddingLeftRight,
                  right: AppNumbers.paddingLeftRight,
                  bottom: AppNumbers.paddingBottom,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.chatsLabel,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: AppNumbers.textHeight),
                    SearchTextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                        context.read<ChatListBloc>().add(UpdateSearchQuery(widget.userId, value));
                      },
                    ),
                    const SizedBox(height: AppNumbers.searchFieldSpacing),
                  ],
                ),
              ),
            ),
          ),
          body: ChatListBody(userId: widget.userId, searchQuery: searchQuery),
        ),
      ),
    );
  }
}
