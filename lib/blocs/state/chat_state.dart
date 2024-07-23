 part of '../chat_bloc.dart';

 abstract class ChatState extends Equatable {
   const ChatState();

   @override
   List<Object> get props => [];
 }

 class ChatInitial extends ChatState {}

 class ChatLoading extends ChatState {}

 class ChatLoaded extends ChatState {
   final List<Map<String, dynamic>> messages;

   const ChatLoaded(this.messages);

   @override
   List<Object> get props => [messages];
 }

 class MessageSentState extends ChatState {
   final List<Map<String, dynamic>> messages;

   const MessageSentState(this.messages);

   @override
   List<Object> get props => [messages];
 }

 class ChatFailure extends ChatState {
   final String error;

   const ChatFailure(this.error);

   @override
   List<Object> get props => [error];
 }
