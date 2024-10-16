import 'package:flutter/material.dart';
import 'package:chatku/chat/view/chat_view.dart';
import 'package:chatku/chatroom/view/chat_new_screen.dart';

class ChatRoomSelectionScreen extends StatelessWidget {
  final List<Map<String, String>> users = [
    {'name': 'Title', 'subtitle': 'Subtitle'},
    {'name': 'Alex', 'subtitle': 'Ada cerita apa hari ini?'},
    {'name': 'Farhan', 'subtitle': 'Ada cerita apa hari ini?'},
    {'name': 'Jiddan', 'subtitle': 'Ada cerita apa hari ini?'},
    {'name': 'Jono', 'subtitle': 'Subtitle'},
    {'name': 'Jona', 'subtitle': 'Ada cerita apa hari ini?'},
    {'name': 'Alfred', 'subtitle': 'Ada cerita apa hari ini?'},
    {'name': 'Budi', 'subtitle': 'Ada cerita apa hari ini?'},
    {'name': 'Olim', 'subtitle': 'Ada cerita apa hari ini?'},
  ];

  ChatRoomSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Room', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF4A86F7),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(users[index]['name']!),
              subtitle: Text(users[index]['subtitle']!),
              trailing:
                  const Text('19:00', style: TextStyle(color: Colors.grey)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      receiverId: users[index]['name']!,
                      receiverName: '',
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new chat functionality
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => const ChatNewSelectionScreen()),
          );
        },
        backgroundColor: const Color(0xFF4A86F7),
        child: const Icon(Icons.add),
      ),
    );
  }
}
