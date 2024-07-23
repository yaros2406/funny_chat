import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:funny_chat/blocs/chat_bloc.dart';
import 'package:funny_chat/repositories/chat_repository.dart';
import 'package:funny_chat/ui/constants/app_strings.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/chat_widgets/avatar.dart';
import '../../widgets/chat_widgets/chat_body.dart';
import 'package:funny_chat/ui/constants/app_numbers.dart';

class ChatScreen extends StatefulWidget {
  final String userId;
  final String chatId;

  const ChatScreen({super.key, required this.userId, required this.chatId});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  late ChatBloc chatBloc;

  @override
  void initState() {
    super.initState();
    chatBloc = ChatBloc(
      chatRepository: RepositoryProvider.of<ChatRepository>(context),
      userId: widget.userId,
      chatId: widget.chatId,
    );
    chatBloc.add(LoadChatMessages());
    chatBloc.add(LoadChatPartnerId());
  }

  @override
  void dispose() {
    chatBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double padding = AppNumbers.verticalPadding;
    const double avatarSize = AppNumbers.avatarSize;
    const double elementSpacing = AppNumbers.edgeInsetsPadding;
    const double symmetricMargin = AppNumbers.symmetricMargin;

    return BlocProvider.value(
      value: chatBloc,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(AppNumbers.appBarChatHeight),
          child: AppBar(
            flexibleSpace: Padding(
              padding: const EdgeInsets.fromLTRB(padding, symmetricMargin, padding, symmetricMargin),
              child: Center(
                child: Row(
                  children: [
                    Container(
                      width: avatarSize,
                      height: avatarSize,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppNumbers.avatarBorderRadius),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                        onPressed: () {
                          context.go(AppStrings.chatListScreenPath, extra: widget.userId);
                        },
                      ),
                    ),
                    const SizedBox(width: elementSpacing),
                    FutureBuilder<String>(
                      future: chatBloc.getChatPartnerName(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text(AppStrings.loading, style: Theme.of(context).textTheme.bodyMedium);
                        }

                        String name = snapshot.data!;
                        var offline = AppStrings.friendOffline;
                        var userStatus = AppStrings.status;

                        return SizedBox(
                          width: AppNumbers.nameAndStatusWidth,
                          height: AppNumbers.nameAndStatusHeight,
                          child: Row(
                            children: [
                              Avatar(name: name),
                              const SizedBox(width: padding),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    name,
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  StreamBuilder<DatabaseEvent>(
                                    stream: chatBloc.getChatPartnerStatusStream(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
                                        return Text(
                                          offline,
                                          style: Theme.of(context).textTheme.bodySmall,
                                        );
                                      }
                                      var userData = Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map<dynamic, dynamic>);
                                      String status = userData.containsKey(userStatus) ? userData[userStatus] : 'offline';
                                      bool isOnline = status == 'online';

                                      return Text(
                                        isOnline ? AppStrings.friendOnline : offline,
                                        style: isOnline
                                            ? Theme.of(context).textTheme.titleSmall
                                            : Theme.of(context).textTheme.bodySmall,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(AppNumbers.dividerHeight),
              child: Container(
                color: Theme.of(context).colorScheme.secondary,
                height: AppNumbers.dividerHeight,
              ),
            ),
          ),
        ),
        body: ChatBody(userId: widget.userId, chatId: widget.chatId),
      ),
    );
  }
}
