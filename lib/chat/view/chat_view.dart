import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatku/chat/bloc/chat_bloc.dart';
import 'package:chatku/chat/model/message.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/socket_service.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName; // Add this line

  const ChatScreen({
    super.key,
    required this.receiverId,
    required this.receiverName, // Add this line
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late SocketService _socketService;

  @override
  void initState() {
    super.initState();
    _socketService = Provider.of<SocketService>(context, listen: false);
    _setupSocketListeners();
  }

  void _setupSocketListeners() {
    _socketService.onNewMessage((data) {
      context.read<ChatBloc>().add(ReceiveMessage(Message.fromJson(data)));
    });

    _socketService.onInitialMessages((data) {
      final messages = (data as List).map((m) => Message.fromJson(m)).toList();
      context.read<ChatBloc>().add(LoadInitialMessages(messages));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc()..add(LoadMessages(widget.receiverId)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF4A86F7), // WhatsApp green color
          leadingWidth: 25, // Adjust this value to fine-tune spacing
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(
                    'assets/default_avatar.png'), // Replace with actual image
                radius: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.receiverName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Online', // You can replace this with actual status
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.videocam, color: Colors.white),
              onPressed: () {/* Implement video call functionality */},
            ),
            IconButton(
              icon: const Icon(Icons.call, color: Colors.white),
              onPressed: () {/* Implement voice call functionality */},
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {/* Implement more options menu */},
            ),
          ],
        ),
        body: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            return Column(
              children: [
                _ChatHeader(),
                Expanded(
                  child: _ChatMessages(state: state),
                ),
                _MessageInput(receiverId: widget.receiverId),
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
              ? const Color.fromARGB(61, 57, 145, 245)
              : const Color.fromARGB(255, 135, 170, 236),
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

// ... (keep _ChatHeader and _ChatMessages as they are)

class _MessageInput extends StatefulWidget {
  final String receiverId;

  const _MessageInput({required this.receiverId});

  @override
  __MessageInputState createState() => __MessageInputState();
}

class __MessageInputState extends State<_MessageInput> {
  final _controller = TextEditingController();
  late SocketService _socketService;

  @override
  void initState() {
    super.initState();
    _socketService = Provider.of<SocketService>(context, listen: false);
  }

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
                fillColor: const Color.fromARGB(72, 53, 108, 247),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Color(0xFF4A86F7)),
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                final message = Message(
                  text: _controller.text,
                  sender: 'me', // Replace with actual sender ID
                  receiver: widget.receiverId,
                  timestamp: DateTime.now(),
                );
                _socketService.sendMessage(message.toJson());
                context.read<ChatBloc>().add(SendMessage(message));
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
