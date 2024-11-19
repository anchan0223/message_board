import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String boardId; // Board ID passed from the MessageBoardsScreen
  final String boardName; // Board Name passed from the MessageBoardsScreen

  ChatScreen({required this.boardId, required this.boardName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
  }

  // Send message method
  Future<void> _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      try {
        final timestamp = FieldValue.serverTimestamp();
        await FirebaseFirestore.instance
            .collection('boards')
            .doc(widget.boardId)
            .collection('messages')
            .add({
          'username': _currentUser?.displayName ?? 'Anonymous',
          'message': _messageController.text,
          'timestamp': timestamp,
        });

        _messageController.clear();
      } catch (e) {
        print('Error sending message: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.boardName),
      ),
      body: Column(
        children: [
          // Message List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('boards')
                  .doc(widget.boardId)
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(), // Real-time updates
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No messages yet.'));
                }

                final messages = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final username = message['username'];
                    final text = message['message'];
                    final timestamp = message['timestamp']?.toDate();
                    final formattedTime =
                    timestamp != null ? '${timestamp.hour}:${timestamp.minute}' : '';

                    return ListTile(
                      title: Text(username),
                      subtitle: Text(text),
                      trailing: Text(formattedTime),
                    );
                  },
                );
              },
            ),
          ),
          // Input Field and Send Button
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
