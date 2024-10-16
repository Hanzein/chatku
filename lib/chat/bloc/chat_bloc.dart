import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../model/message.dart';

part 'chat_event.dart';
part 'chat_state.dart';

// Bloc
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<LoadInitialMessages>(_onLoadInitialMessages);
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);
  }

  void _onLoadMessages(LoadMessages event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    // In a real app, you would load messages from a database or API here
    // For now, we'll just emit an empty list
    emit(ChatLoaded(const []));
  }

  void _onLoadInitialMessages(
      LoadInitialMessages event, Emitter<ChatState> emit) {
    emit(ChatLoaded(event.messages));
  }

  void _onSendMessage(SendMessage event, Emitter<ChatState> emit) {
    final currentState = state;
    if (currentState is ChatLoaded) {
      final updatedMessages = List<Message>.from(currentState.messages)
        ..add(event.message);
      emit(ChatLoaded(updatedMessages));
    }
  }

  void _onReceiveMessage(ReceiveMessage event, Emitter<ChatState> emit) {
    final currentState = state;
    if (currentState is ChatLoaded) {
      final updatedMessages = List<Message>.from(currentState.messages)
        ..add(event.message);
      emit(ChatLoaded(updatedMessages));
    }
  }
}
