import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:funny_chat/repositories/chat_repository.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:funny_chat/ui/constants/app_strings.dart';
import 'package:permission_handler/permission_handler.dart';
import '../ui/constants/firebase_paths.dart';

part 'events/chat_event.dart';
part 'state/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;
  final String userId;
  final String chatId;
  final ScrollController scrollController = ScrollController();
  final TextEditingController messageController = TextEditingController();
  StreamSubscription<DatabaseEvent>? _chatMessagesSubscription;
  File? selectedFile;
  bool isRecordingAudio = false;
  String? partnerId;

  ChatBloc({required this.chatRepository, required this.userId, required this.chatId}) : super(ChatInitial()) {
    on<LoadChatMessages>(_onLoadChatMessages);
    on<SendMessage>(_onSendMessage);
    on<PickFile>(_onPickFile);
    on<ResetFileSelection>(_onResetFileSelection);
    on<StartRecordingAudio>(_onStartRecordingAudio);
    on<StopRecordingAudio>(_onStopRecordingAudio);
    on<LoadChatPartnerId>(_onLoadChatPartnerId);

    add(LoadChatPartnerId());
    _startListeningToMessages();
  }

  void _startListeningToMessages() {
    _chatMessagesSubscription = chatRepository.getChatMessagesStream(chatId).listen((event) {
      add(LoadChatMessages());
    });
  }

  @override
  Future<void> close() {
    _chatMessagesSubscription?.cancel();
    return super.close();
  }

  Future<void> _onLoadChatMessages(LoadChatMessages event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      DatabaseEvent messagesEvent = await chatRepository.getChatMessages(chatId);
      var messagesMap = Map<String, dynamic>.from(messagesEvent.snapshot.value as Map<dynamic, dynamic>);
      List<Map<String, dynamic>> messages = messagesMap.entries.map((e) {
        var messageData = e.value as Map<dynamic, dynamic>;
        var message = Map<String, dynamic>.from(messageData);
        message[AppStrings.key] = e.key;
        return message;
      }).toList();
      emit(ChatLoaded(messages));
    } catch (error) {
      emit(ChatFailure(error.toString()));
    }
  }

  Future<void> _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
    if (event.text.trim().isEmpty && selectedFile == null) return;

    String? fileUrl;
    if (selectedFile != null) {
      String fileName = selectedFile!.path.split('/').last;
      try {
        UploadTask uploadTask = FirebasePaths.getUploadReference(fileName).putFile(selectedFile!);
        TaskSnapshot snapshot = await uploadTask;
        fileUrl = await snapshot.ref.getDownloadURL();
      } catch (e) {
        if (kDebugMode) {
          print('Error uploading file: $e');
        }
      }
    }

    Map<String, dynamic> message = {
      AppStrings.text: event.text,
      AppStrings.fileUrl: fileUrl,
      AppStrings.fileType: fileUrl != null ? AppStrings.file : null,
      AppStrings.sender: userId,
      AppStrings.timeStamp: DateTime.now().millisecondsSinceEpoch,
      AppStrings.read: false,
    };

    await chatRepository.sendMessage(chatId, message);

    messageController.clear();
    selectedFile = null;
    isRecordingAudio = false;

    final updatedMessages = await chatRepository.getChatMessages(chatId);
    var messagesMap = Map<String, dynamic>.from(updatedMessages.snapshot.value as Map<dynamic, dynamic>);
    List<Map<String, dynamic>> messages = messagesMap.entries.map((e) {
      var messageData = e.value as Map<dynamic, dynamic>;
      var message = Map<String, dynamic>.from(messageData);
      message[AppStrings.key] = e.key;
      return message;
    }).toList();
    emit(MessageSentState(messages));
  }

  Future<void> _onPickFile(PickFile event, Emitter<ChatState> emit) async {
    if (await Permission.storage.request().isGranted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null && result.files.single.path != null) {
        selectedFile = File(result.files.single.path!);
        add(LoadChatMessages());
      }
    } else {
      if (kDebugMode) {
        print('Storage permission denied');
      }
    }
  }

  void _onResetFileSelection(ResetFileSelection event, Emitter<ChatState> emit) {
    selectedFile = null;
    add(LoadChatMessages());
  }

  void _onStartRecordingAudio(StartRecordingAudio event, Emitter<ChatState> emit) {
     isRecordingAudio = true;
     add(LoadChatMessages());
   }

  void _onStopRecordingAudio(StopRecordingAudio event, Emitter<ChatState> emit) {
    isRecordingAudio = false;
    emit(ChatLoaded([]));
  }

  Future<void> _onLoadChatPartnerId(LoadChatPartnerId event, Emitter<ChatState> emit) async {
    partnerId = await chatRepository.getChatPartnerId(chatId, userId);
    add(LoadChatMessages());
  }

  Future<String> getChatPartnerName() async {
    partnerId ??= await chatRepository.getChatPartnerId(chatId, userId);
    return await chatRepository.getChatPartnerName(partnerId!);
  }

  Stream<DatabaseEvent> getChatPartnerStatusStream() {
    if (partnerId == null) {
      throw Exception('Чат не найден');
    }
    return chatRepository.getChatPartnerStatusStream(partnerId!);
  }
}
