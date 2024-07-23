import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebasePaths {
  static DatabaseReference get databaseRef => FirebaseDatabase.instance.ref();
  static DatabaseReference getChatMessagesPath(String chatId) {
    return FirebaseDatabase.instance.ref().child('chat_rooms/$chatId/messages');
  }

  static DatabaseReference getChatPartnerIdPath(String chatId) {
    return FirebaseDatabase.instance.ref().child('chat_rooms/$chatId');
  }

  static DatabaseReference getChatPartnerNamePath(String partnerId) {
    return FirebaseDatabase.instance.ref().child('chat_users/$partnerId');
  }

  static DatabaseReference getChatPartnerStatusPath(String partnerId) {
    return FirebaseDatabase.instance.ref().child('status/$partnerId');
  }

  static DatabaseReference getMessageIdPath(String chatId, String messageId) {
    return FirebaseDatabase.instance.ref().child('chat_rooms/$chatId/messages/$messageId');
  }

  static DatabaseReference get statusRef => FirebaseDatabase.instance.ref().child('status');

  static DatabaseReference get connectRef => FirebaseDatabase.instance.ref().child('.info/connected');

  static Reference getUploadReference(String fileName) {
    return FirebaseStorage.instance.ref().child('uploads/$fileName');
  }
}
