import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatku/chat/bloc/chat_bloc.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chat'),
        ),
        body: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is ChatInitial) {
              return const Center(child: Text('Start a new chat!'));
            } else if (state is ChatLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ChatLoaded) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final message = state.messages[index];
                        return ListTile(
                          title: Text(message.text),
                          subtitle: Text(message.sender),
                        );
                      },
                    ),
                  ),
                  _MessageInput(),
                ],
              );
            } else if (state is ChatError) {
              return Center(child: Text('Error: ${state.error}'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _MessageInput extends StatefulWidget {
  @override
  __MessageInputState createState() => __MessageInputState();
}

class __MessageInputState extends State<_MessageInput> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Type a message',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                context.read<ChatBloc>().add(SendMessage(_controller.text));
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
