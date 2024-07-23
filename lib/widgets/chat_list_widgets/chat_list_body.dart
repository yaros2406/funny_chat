import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:funny_chat/ui/constants/app_numbers.dart';
import 'package:funny_chat/widgets/chat_list_widgets/%D1%81hat_item.dart';
import 'package:go_router/go_router.dart';
import '../../blocs/chat_list_bloc.dart';
import '../../repositories/chat_list_repository.dart';
import '../../ui/constants/app_strings.dart';
import '../../ui/helpers/datetime_manager.dart';

class ChatListBody extends StatelessWidget {
  final String userId;
  final String searchQuery;

  const ChatListBody({super.key, required this.userId, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatListBloc, ChatListState>(
      builder: (context, state) {
        if (state is ChatListLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ChatListLoaded) {
          var usersMap = state.chatUsersWithLastMessage['users'] ?? {};
          var chatRoomsMap = state.chatUsersWithLastMessage['chatRooms'] ?? {};

          if (usersMap.isEmpty) {
            return const Center(child: Text(AppStrings.emptyContactList));
          }

          var filteredUsers = usersMap.entries.where((entry) {
            var userData = entry.value as Map<dynamic, dynamic>;
            var userName = userData[AppStrings.name] as String? ?? '';
            return userName.toLowerCase().contains(searchQuery.toLowerCase()) && entry.key != userId;
          }).toList();

          if (filteredUsers.isEmpty) {
            return const Center(child: Text(AppStrings.emptyFilters));
          }

          return ListView.builder(
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              var userEntry = filteredUsers[index];
              var userData = userEntry.value as Map<dynamic, dynamic>;
              var userName = userData[AppStrings.name] ?? AppStrings.noName;
              var userAvatar = userData[AppStrings.avatar] ?? AppStrings.url;
              var otherUserId = userEntry.key;
              var emptyMessageList = AppStrings.emptyMessageList;
              var chatDoc;

              chatRoomsMap.forEach((key, value) {
                var chatData = value as Map<dynamic, dynamic>;
                if (chatData[AppStrings.chatUsers][otherUserId] == true) {
                  chatDoc = {AppStrings.id: key, ...chatData};
                }
              });

              if (chatDoc == null) {
                return ChatItem(
                  name: userName,
                  avatar: userAvatar,
                  lastMessage: emptyMessageList,
                  time: '',
                  senderId: '',
                  isCurrentUser: false,
                  isLast: index == filteredUsers.length - AppNumbers.limitSingle,
                  onTap: () async {
                    var newChatRoomRef = await RepositoryProvider.of<ChatListRepository>(context).createChatRoom(userId, otherUserId);
                    if(context.mounted){
                      context.go('${AppStrings.chatParamScreenPath}/${newChatRoomRef.key}', extra: {AppStrings.userId: userId});
                    }
                  },
                );
              }

              var chatId = chatDoc[AppStrings.id];

              return FutureBuilder<DatabaseEvent>(
                future: RepositoryProvider.of<ChatListRepository>(context).getLastMessageOnce(chatId),
                builder: (context, messageSnapshot) {
                  if (messageSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!messageSnapshot.hasData || messageSnapshot.data!.snapshot.value == null) {
                    return ChatItem(
                      name: userName,
                      avatar: userAvatar,
                      lastMessage: emptyMessageList,
                      time: '',
                      senderId: '',
                      isCurrentUser: false,
                      isLast: index == filteredUsers.length - 1,
                      onTap: () {
                        context.go('${AppStrings.chatParamScreenPath}/$chatId', extra: {AppStrings.userId: userId});
                      },
                    );
                  }

                  var lastMessageMap = messageSnapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                  var lastMessageData = lastMessageMap.entries.first.value as Map<dynamic, dynamic>;

                  var lastMessage = lastMessageData[AppStrings.text]?.toString() ?? emptyMessageList;
                  var timestamp = lastMessageData[AppStrings.timeStamp] is int
                      ? lastMessageData[AppStrings.timeStamp]
                      : int.tryParse(lastMessageData[AppStrings.timeStamp]?.toString() ?? AppStrings.zero) ?? AppNumbers.zeroInt;
                  var senderId = lastMessageData[AppStrings.sender]?.toString() ?? '';

                  return ChatItem(
                    name: userName,
                    avatar: userAvatar,
                    lastMessage: lastMessage,
                    time: DateTimeManager.formatTimestamp(timestamp),
                    senderId: senderId,
                    isCurrentUser: senderId == userId,
                    isLast: index == filteredUsers.length - AppNumbers.limitSingle,
                    onTap: () {
                      context.go('${AppStrings.chatParamScreenPath}/$chatId', extra: {AppStrings.userId: userId});
                    },
                  );
                },
              );
            },
          );
        } else if (state is ChatListFailure) {
          return const Center(child: Text(AppStrings.errorMessageLoading));
        } else {
          return const Center(child: Text(AppStrings.unknownError));
        }
      },
    );
  }
}
