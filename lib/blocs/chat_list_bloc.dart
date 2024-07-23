import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/chat_list_repository.dart';
part 'events/chat_list_event.dart';
part 'state/chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final ChatListRepository _chatListRepository;
  String searchQuery = '';
  final String userId;

  ChatListBloc({required ChatListRepository chatListRepository, required this.userId})
      : _chatListRepository = chatListRepository,
        super(ChatListLoading()) {
    on<LoadChatList>(_onLoadChatList);
    on<UpdateSearchQuery>(_onUpdateSearchQuery);
    on<ChatListUpdated>(_onChatListUpdated);

    _startListeningToMessages();
  }

  void _onLoadChatList(LoadChatList event, Emitter<ChatListState> emit) async {
    try {
      final chatUsersWithLastMessage = await _chatListRepository.getChatUsersWithLastMessage(event.userId);
      emit(ChatListLoaded(chatUsersWithLastMessage: chatUsersWithLastMessage));
    } catch (error) {
      emit(ChatListFailure(error: error.toString()));
    }
  }

  void _onUpdateSearchQuery(UpdateSearchQuery event, Emitter<ChatListState> emit) {
    searchQuery = event.query;
    add(LoadChatList(event.userId));
  }

  void _onChatListUpdated(ChatListUpdated event, Emitter<ChatListState> emit) {
    add(LoadChatList(event.userId));
  }

  void _startListeningToMessages() {
    _chatListRepository.getChatRoomsStream().listen((event) {
      add(ChatListUpdated(userId));
    });
  }
}
