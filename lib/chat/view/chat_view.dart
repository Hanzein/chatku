import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatku/chat/bloc/chat_bloc.dart';
import 'package:chatku/chat/model/message.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatelessWidget {
  final String receiverId;

  const ChatScreen({super.key, required this.receiverId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc()..add(LoadMessages(receiverId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chat with $receiverId',
              style: const TextStyle(color: Colors.white)),
          backgroundColor: const Color(0xFF097792),
          centerTitle: true,
        ),
        body: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            return Column(
              children: [
                _ChatHeader(),
                Expanded(
                  child: _ChatMessages(state: state),
                ),
                _MessageInput(receiverId: receiverId),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ChatHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        DateFormat('dd MMM, yyyy\nHH:mm').format(DateTime.now()),
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey[600]),
      ),
    );
  }
}

class _ChatMessages extends StatelessWidget {
  final ChatState state;

  const _ChatMessages({required this.state});

  @override
  Widget build(BuildContext context) {
    return state.when(
      initial: () => const Center(child: Text('Start a new chat!')),
      loading: () => const Center(child: CircularProgressIndicator()),
      loaded: (messages) => ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return _ChatBubble(message: message);
        },
      ),
      error: (error) => Center(child: Text('Error: $error')),
    );
  }
}

// Extension to add when method to ChatState
extension ChatStateWhen on ChatState {
  T when<T>({
    required T Function() initial,
    required T Function() loading,
    required T Function(List<Message> messages) loaded,
    required T Function(String error) error,
  }) {
    if (this is ChatInitial) return initial();
    if (this is ChatLoading) return loading();
    if (this is ChatLoaded) return loaded((this as ChatLoaded).messages);
    if (this is ChatError) return error((this as ChatError).error);
    throw Exception('Unhandled state type');
  }
}

class _ChatBubble extends StatelessWidget {
  final Message message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.sender == 'me';
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: isMe
              ? const Color.fromARGB(65, 9, 119, 146)
              : const Color(0xFF097792),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          message.text,
          style: TextStyle(color: isMe ? Colors.black : Colors.white),
        ),
      ),
    );
  }
}

class _MessageInput extends StatefulWidget {
  final String receiverId;

  const _MessageInput({required this.receiverId});

  @override
  __MessageInputState createState() => __MessageInputState();
}

class __MessageInputState extends State<_MessageInput> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Kirim Pesan',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color.fromARGB(65, 9, 119, 146),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Color(0xFF097792)),
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                context
                    .read<ChatBloc>()
                    .add(SendMessage(widget.receiverId, _controller.text));
                _controller.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
