part of '../chat_list_bloc.dart';

abstract class ChatListEvent extends Equatable {
  const ChatListEvent();

  @override
  List<Object> get props => [];
}

class LoadChatList extends ChatListEvent {
  final String userId;

  const LoadChatList(this.userId);

  @override
  List<Object> get props => [userId];
}

class UpdateSearchQuery extends ChatListEvent {
  final String userId;
  final String query;

  const UpdateSearchQuery(this.userId, this.query);

  @override
  List<Object> get props => [userId, query];
}

class ChatListUpdated extends ChatListEvent {
  final String userId;

  const ChatListUpdated(this.userId);

  @override
  List<Object> get props => [userId];
}
