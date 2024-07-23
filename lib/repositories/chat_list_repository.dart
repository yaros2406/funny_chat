import 'package:firebase_database/firebase_database.dart';
import 'package:funny_chat/ui/constants/firebase_paths.dart';
import '../ui/constants/app_numbers.dart';
import '../ui/constants/app_strings.dart';

class ChatListRepository {
  final DatabaseReference _databaseRef = FirebasePaths.databaseRef;
  final chatRooms = AppStrings.chatRooms;
  final chatUsers = AppStrings.chatUsers;
  final timeStamp = AppStrings.timeStamp;
  final lastMessage = AppStrings.lastMessage;

  Future<Map<String, dynamic>> getChatUsersWithLastMessage(String userId) async {
    var usersSnapshot = await _databaseRef.child(AppStrings.chatUsers).once();
    var usersMap = usersSnapshot.snapshot.value as Map<dynamic, dynamic>? ?? {};

    var chatRoomsSnapshot = await _databaseRef
        .child(AppStrings.chatRooms)
        .orderByChild('${AppStrings.chatUsers}/$userId')
        .equalTo(true)
        .once();
    var chatRoomsMap = chatRoomsSnapshot.snapshot.value as Map<dynamic, dynamic>? ?? {};

    for (var chatRoomEntry in chatRoomsMap.entries) {
      var chatRoomId = chatRoomEntry.key;
      var lastMessageSnapshot = await FirebasePaths.getChatMessagesPath(chatRoomId)
          .orderByChild(AppStrings.timeStamp)
          .limitToLast(1)
          .once();
      var lastMessageMap = lastMessageSnapshot.snapshot.value as Map<dynamic, dynamic>?;

      if (lastMessageMap != null) {
        var lastMessageData = lastMessageMap.entries.first.value;
        chatRoomsMap[chatRoomId]['lastMessage'] = lastMessageData;
      }
    }

    return {
      'users': usersMap,
      'chatRooms': chatRoomsMap,
    };
  }

  Stream<DatabaseEvent> getChatRoomsStream() {
    return _databaseRef.child(AppStrings.chatRooms).onValue;
  }

  Future<DatabaseReference> createChatRoom(String userId, String otherUserId) async {
    var newChatRoomRef = _databaseRef.child(chatRooms).push();
    await newChatRoomRef.set({
      chatUsers: {
        userId: true,
        otherUserId: true,
      },
      lastMessage: '',
      timeStamp: DateTime.now().millisecondsSinceEpoch,
    });
    return newChatRoomRef;
  }

  Future<DatabaseEvent> getLastMessageOnce(String chatId) async {
    return await FirebasePaths.getChatMessagesPath(chatId)
        .orderByChild(timeStamp)
        .limitToLast(AppNumbers.limitSingle)
        .once();
  }
}
