import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<SendMessage>(_onSendMessage);
  }

  void _onSendMessage(SendMessage event, Emitter<ChatState> emit) {
    emit(ChatLoading());
    try {
      final currentState = state;
      if (currentState is ChatLoaded) {
        final updatedMessages = List<Message>.from(currentState.messages)
          ..add(Message(text: event.message, sender: 'User'));
        emit(ChatLoaded(updatedMessages));
      } else {
        emit(ChatLoaded([Message(text: event.message, sender: 'User')]));
      }
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }
}

// Model
class Message {
  final String text;
  final String sender;

  Message({required this.text, required this.sender});
}
