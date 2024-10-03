part of 'chat_bloc.dart';

// Events
abstract class ChatEvent {}

class LoadMessages extends ChatEvent {
  final String receiverId;

  LoadMessages(this.receiverId);
}

class SendMessage extends ChatEvent {
  final String receiverId;
  final String message;

  SendMessage(this.receiverId, this.message);
}
