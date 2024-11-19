import 'package:flutter/material.dart';
import 'chat.dart';

class MessageBoardsScreen extends StatelessWidget {
  final List<Map<String, String>> boards = [
    {
      'id': 'techTalk', // Use unique IDs for each board
      'name': 'Tech Talk',
      'image': 'assets/tech_talk.png', // Replace with your image path
    },
    {
      'id': 'musicLovers',
      'name': 'Music Lovers',
      'image': 'assets/music_lovers.png', // Replace with your image path
    },
    {
      'id': 'gamingZone',
      'name': 'Gaming Zone',
      'image': 'assets/gaming_zone.png', // Replace with your image path
    },
    // Add more boards here as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Message Boards')),
      body: ListView.builder(
        itemCount: boards.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(boards[index]['image']!),
            ),
            title: Text(boards[index]['name']!),
            onTap: () {
              // Navigate to ChatScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    boardId: boards[index]['id']!,
                    boardName: boards[index]['name']!,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

