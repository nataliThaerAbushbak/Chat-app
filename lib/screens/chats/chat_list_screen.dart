import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../services/chat_service.dart';
import 'chat_screen.dart';

class ChatsListScreen extends StatelessWidget {
  const ChatsListScreen({super.key});

  String _getOtherUserId(String chatId, String myUid) {
    final parts = chatId.split('_');
    return parts[0] == myUid ? parts[1] : parts[0];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUser = AuthService().currentUser!;
    final chatService = ChatService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox Messages'),
      ),
      body: StreamBuilder<List<String>>(
        stream: chatService.getUserChats(currentUser.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
                child: Text('An error occurred loading your inbox.'));
          }

          final chatIds = snapshot.data ?? [];

          if (chatIds.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.forum_outlined, size: 72, color: Colors.grey[400]),
                  const SizedBox(height: 14),
                  Text(
                    'No conversions active yet',
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: chatIds.length,
            separatorBuilder: (_, __) =>
            const Divider(height: 1, indent: 76, color: Color(0xFFE2E8F0)),
            itemBuilder: (context, index) {
              final chatId = chatIds[index];
              final otherUserId = _getOtherUserId(chatId, currentUser.uid);

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(otherUserId)
                    .get(),
                builder: (context, userSnapshot) {
                  String otherUserName = 'User';
                  if (userSnapshot.hasData && userSnapshot.data!.exists) {
                    final userData =
                    userSnapshot.data!.data() as Map<String, dynamic>;
                    otherUserName = userData['name'] ?? 'User';
                  }

                  return ListTile(
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: CircleAvatar(
                      radius: 26,
                      backgroundColor: theme.colorScheme.primaryContainer,
                      foregroundColor: theme.colorScheme.onPrimaryContainer,
                      child: Text(
                        otherUserName.isNotEmpty
                            ? otherUserName[0].toUpperCase()
                            : 'U',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    title: Text(
                      otherUserName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF0F172A)),
                    ),
                    subtitle: const Text('Tap to continue chatting',
                        style:
                        TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                    trailing: const Icon(Icons.chevron_right_rounded,
                        color: Color(0xFF94A3B8)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                              chatId: chatId, otherUserName: otherUserName),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}