import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final AuthService _auth = AuthService();
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  late IO.Socket socket;

  @override
  void initState() {
    super.initState();
    connectToServer();
  }

  void connectToServer() async {
    User? user = _auth.getCurrentUser();
    if (user != null) {
      String? token = await user.getIdToken();
      socket = IO.io('http://localhost:3000', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
        'auth': {'token': token}
      });

      socket.connect();

      socket.onConnect((_) {
        print('Connected to server');
      });

      socket.on('new message', (data) {
        setState(() {
          _messages.add({
            'text': data['text'],
            'isMe': data['userId'] == user.uid,
          });
        });
      });
    }
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      final message = {
        'text': _messageController.text,
        'userId': _auth.getCurrentUser()?.uid,
      };
      socket.emit('new message', message);
      setState(() {
        _messages.add({
          'text': _messageController.text,
          'isMe': true,
        });
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        backgroundColor: Color(0xFF0096C7),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await _auth.signOut();
              // After signing out, the AuthWrapper will automatically navigate to LoginScreen
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment: message['isMe']
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: message['isMe']
                          ? Color(0xFF0096C7)
                          : Color(0xFFADE8F4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      message['text'],
                      style: TextStyle(
                        color: message['isMe'] ? Colors.white : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFADE8F4),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Kirim Pesan',
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
