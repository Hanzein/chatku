part of 'chat_bloc.dart';

// Events
abstract class ChatEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadMessages extends ChatEvent {
  final String receiverId;
  LoadMessages(this.receiverId);
  @override
  List<Object> get props => [receiverId];
}

class LoadInitialMessages extends ChatEvent {
  final List<Message> messages;
  LoadInitialMessages(this.messages);
  @override
  List<Object> get props => [messages];
}

class SendMessage extends ChatEvent {
  final Message message;
  SendMessage(this.message);
  @override
  List<Object> get props => [message];
}

class ReceiveMessage extends ChatEvent {
  final Message message;
  ReceiveMessage(this.message);
  @override
  List<Object> get props => [message];
}
