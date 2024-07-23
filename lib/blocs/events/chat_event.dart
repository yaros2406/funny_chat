 part of '../chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class LoadChatMessages extends ChatEvent {}

class SendMessage extends ChatEvent {
  final String text;

  const SendMessage({required this.text});

  @override
  List<Object> get props => [text];
}

class PickFile extends ChatEvent {}

class ResetFileSelection extends ChatEvent {}

class StartRecordingAudio extends ChatEvent {}

class StopRecordingAudio extends ChatEvent {}

class LoadChatPartnerId extends ChatEvent {}

class NewMessageReceived extends ChatEvent {
  final Map<String, dynamic> message;

  const NewMessageReceived(this.message);

  @override
  List<Object> get props => [message];
}

class MessageSent extends ChatEvent {
  final List<Map<String, dynamic>> messages;

  const MessageSent(this.messages);

  @override
  List<Object> get props => [messages];
}
