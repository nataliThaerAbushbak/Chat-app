// ============================================================
// services/chat_service.dart
// Chat Service - Real-Time Messaging
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message.dart';

class ChatService {
  // Singleton instance
  static final ChatService _instance = ChatService._internal();

  // Private constructor
  ChatService._internal();

  // Factory constructor to return the same instance
  factory ChatService() => _instance;

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Reference to the products collection
  CollectionReference get _chatsRef => _db.collection('chats');

  // Generate a unique chatId by sorting UIDs //Cascade
  String getChatId(String uid1, String uid2) {
    List<String> ids = [uid1, uid2]..sort();
    return '${ids[0]}_${ids[1]}';
  }

  // Stream to fetch messages in real-time
  Stream<List<Message>> getMessages(String chatId) {
    return _chatsRef
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Message.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Send a message and update chat participants
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String senderName,
    required String text,
  }) async {
    final participants = chatId.split('_');

    // Create/Update chat document with participants and last message info
    await _chatsRef.doc(chatId).set({
      'participants': participants,
      'lastMessage': text,
      'lastMessageTime': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // Create message object
    Message message = Message(
      id: '',
      senderId: senderId,
      senderName: senderName,
      text: text,
      createdAt: FieldValue.serverTimestamp(),
    );

    // Add message to messages sub-collection
    await _chatsRef.doc(chatId).collection('messages').add(message.toMap());
  }

  // Fetch a list of chat IDs for the current user
  Stream<List<String>> getUserChats(String userId) {
    return _chatsRef
        .where('participants', arrayContains: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.id).toList();
    });
  }
}