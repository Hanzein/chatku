import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:chatku/chat/model/message.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
  }

  void _onLoadMessages(LoadMessages event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      // Here you would typically fetch messages for the specific receiverId
      // For now, we'll just emit some dummy data
      await Future.delayed(
          const Duration(seconds: 1)); // Simulate network delay
      emit(ChatLoaded([
        Message(sender: 'me', text: 'Hello!'),
        Message(sender: event.receiverId, text: 'Hi there!'),
      ]));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  void _onSendMessage(SendMessage event, Emitter<ChatState> emit) {
    if (state is ChatLoaded) {
      final currentMessages = (state as ChatLoaded).messages;
      emit(ChatLoaded([
        ...currentMessages,
        Message(sender: 'me', text: event.message),
      ]));
      // Here you would typically send the message to your backend or socket server
    }
  }
}
