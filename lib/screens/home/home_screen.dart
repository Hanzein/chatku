import 'package:chatku/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:chatku/chatroom/view/chat_room_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../chat/services/chat_service.dart';
import '../auth/components/user_tile.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome, you are In !'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<SignInBloc>().add(const SignOutRequired());
            },
            icon: const Icon(Icons.login),
          )
        ],
      ),
      body: _buildUserList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ChatRoomSelectionScreen()),
          );
        },
        child: const Icon(Icons.chat),
      ),
    );
  }
  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUserStream(),
      builder: (context, snapshot) {
        // error
        if (snapshot.hasError) {
          return const Text("Error");
        }

        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        if (snapshot.data != null) {
          return Text(snapshot.data.toString());
        }

        // return list view
        return snapshot.hasData || snapshot.data!.isNotEmpty
            ? ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        )
            : const Center(
          child: Text('No data available'),
        );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    return UserTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatRoomSelectionScreen(
              ),
            ));
      },
      text: userData["email"],
    );
  }
}
