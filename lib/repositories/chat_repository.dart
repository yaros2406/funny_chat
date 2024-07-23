import 'package:firebase_database/firebase_database.dart';
import 'package:funny_chat/ui/constants/firebase_paths.dart';

import '../ui/constants/app_strings.dart';

class ChatRepository {
  Future<DatabaseEvent> getChatMessages(String chatId) async {
    return await FirebasePaths.getChatMessagesPath(chatId).orderByChild(AppStrings.timeStamp).once();
  }

  Stream<DatabaseEvent> getChatMessagesStream(String chatId) {
    return FirebasePaths.getChatMessagesPath(chatId).orderByChild(AppStrings.timeStamp).onValue;
  }

  Future<void> sendMessage(String chatId, Map<String, dynamic> message) async {
    var newMessageRef = FirebasePaths.getChatMessagesPath(chatId).push();
    await newMessageRef.set(message);
  }

  Future<String> getChatPartnerId(String chatId, String userId) async {
    DataSnapshot chatSnapshot = await FirebasePaths.getChatPartnerIdPath(chatId).get();
    var chatData = Map<String, dynamic>.from(chatSnapshot.value as Map<dynamic, dynamic>);
    List<String> participants = List<String>.from(chatData[AppStrings.chatUsers].keys);
    return participants.firstWhere((id) => id != userId);
  }

  Future<String> getChatPartnerName(String partnerId) async {
    DataSnapshot userSnapshot = await FirebasePaths.getChatPartnerNamePath(partnerId).get();
    var userData = Map<String, dynamic>.from(userSnapshot.value as Map<dynamic, dynamic>);
    return userData[AppStrings.name] ?? AppStrings.noName;
  }

  Stream<DatabaseEvent> getChatPartnerStatusStream(String partnerId) {
    return FirebasePaths.getChatPartnerStatusPath(partnerId).onValue;
  }

  Future<void> markMessageAsRead(String chatId, String messageId) async {
    await FirebasePaths.getMessageIdPath(chatId, messageId).update({AppStrings.read: true});
  }
}
