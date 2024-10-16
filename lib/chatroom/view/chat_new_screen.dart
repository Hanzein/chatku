import 'package:flutter/material.dart';
import 'package:chatku/chat/view/chat_view.dart';

class ChatNewSelectionScreen extends StatefulWidget {
  const ChatNewSelectionScreen({super.key});

  @override
  State<ChatNewSelectionScreen> createState() => _ChatNewSelectionScreenState();
}

class _ChatNewSelectionScreenState extends State<ChatNewSelectionScreen> {
  final List<Map<String, String>> allUsers = [
    {'name': 'Imelda Alexis Jovita', 'subtitle': 'Pelajar sejak Juni 2024'},
    {'name': 'Alex Daro Zaeli', 'subtitle': 'Pelajar sejak Juli 2021'},
    {'name': 'Akbar Suherman', 'subtitle': 'Pelajar sejak Agustus 2024'},
    {'name': 'Heical Mudarto', 'subtitle': 'Pelajar sejak April 2024'},
    {'name': 'Jonathan Liandi', 'subtitle': 'Pelajar sejak Mei 2024'},
    {'name': 'Roger Simanjuntak', 'subtitle': 'Pelajar sejak Oktober 2024'},
    {'name': 'Jiddan Mubarok', 'subtitle': 'Pelajar sejak Desember 2024'},
    {'name': 'Sultan Jumanta', 'subtitle': 'Pelajar sejak Februari 2024'},
    {'name': 'Louis Kennedy', 'subtitle': 'Pelajar sejak Juni 2024'},
  ];

  List<Map<String, String>> filteredUsers = [];
  String? selectedUser;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredUsers = allUsers;
  }

  void searchUsers(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredUsers = allUsers;
      } else {
        filteredUsers = allUsers
            .where((user) =>
                user['name']!.toLowerCase().contains(query.toLowerCase()))
            .take(5)
            .toList();
      }
    });
  }

  navigateToChatScreen(
      BuildContext context, String receiverId, String receiverName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ChatScreen(receiverId: receiverId, receiverName: receiverName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Start New Chat',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4A86F7),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Ketik nama teman sesama studi kamu dan pencarian akan menampilkan maksimal 5 pelajar dengan kata kunci yang kamu masukkan.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Ketik nama teman kamu disini',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: searchUsers,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      child: Icon(Icons.person, color: Colors.grey[600]),
                    ),
                    title: Text(filteredUsers[index]['name']!),
                    subtitle: Text(filteredUsers[index]['subtitle']!),
                    trailing: Radio<String>(
                      value: filteredUsers[index]['name']!,
                      groupValue: selectedUser,
                      onChanged: (value) {
                        setState(() {
                          selectedUser = value;
                        });
                        navigateToChatScreen(
                            context,
                            filteredUsers[index]['name']!,
                            filteredUsers[index]['name']!);
                      },
                    ),
                    onTap: () {
                      setState(() {
                        selectedUser = filteredUsers[index]['name'];
                      });
                     navigateToChatScreen(
                          context,
                          filteredUsers[index]['name']!,
                          filteredUsers[index]['name']!);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
