import 'package:flutter/material.dart';
import 'package:chatku/chat/view/chat_view.dart';

class ChatRoomSelectionScreen extends StatelessWidget {
  final List<String> users = ['User 1', 'User 2', 'User 3'];

  ChatRoomSelectionScreen({super.key}); // Replace with actual user data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Chat'),
        backgroundColor: const Color(0xFF097792),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(users[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(receiverId: users[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
