 part of '../chat_list_bloc.dart';

 abstract class ChatListState extends Equatable {
   const ChatListState();

   @override
   List<Object?> get props => [];
 }

 class ChatListLoading extends ChatListState {}

 class ChatListLoaded extends ChatListState {
   final Map<String, dynamic> chatUsersWithLastMessage;

   const ChatListLoaded({required this.chatUsersWithLastMessage});

   @override
   List<Object?> get props => [chatUsersWithLastMessage];
 }

 class ChatListFailure extends ChatListState {
   final String error;

   const ChatListFailure({required this.error});

   @override
   List<Object?> get props => [error];
 }
