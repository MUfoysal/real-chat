
import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/chat_message.dart';

class ChatRepository {
  ChatRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _chats =>
      _firestore.collection('chats');

  String conversationId(String firstUid, String secondUid) {
    if (firstUid == secondUid) {
      throw ArgumentError('Cannot create a chat with yourself.');
    }

    final sortedUids = [firstUid, secondUid]..sort();

    return '${sortedUids[0]}_${sortedUids[1]}';
  }

  Future<String> createOrGetConversation({
    required String currentUid,
    required String otherUid,
  }) async {
    final id = conversationId(currentUid, otherUid);
    final chatRef = _chats.doc(id);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(chatRef);

      if (!snapshot.exists) {
        final participants = [currentUid, otherUid]..sort();

        transaction.set(chatRef, {
          'participants': participants,
          'createdAt': FieldValue.serverTimestamp(),
          'lastMessage': '',
          'lastMessageAt': FieldValue.serverTimestamp(),
        });
      } else {
        final data = snapshot.data();

        if (data == null ||
            data['participants'] is! List ||
            !(data['participants'] as List).contains(currentUid) ||
            !(data['participants'] as List).contains(otherUid)) {
          throw StateError('Invalid conversation participants.');
        }
      }
    });

    return id;
  }

  
  Stream<QuerySnapshot<Map<String, dynamic>>> conversationsStream(
    String currentUid,
  ) {
    return _chats
        .where('participants', arrayContains: currentUid)
        .snapshots();
  }

  Stream<List<ChatMessage>> messagesStream(String chatId) {
    return _chats
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(ChatMessage.fromFirestore)
              .toList(),
        );
  }

  Future<void> sendMessage({
    required String chatId,
    required String senderUid,
    required String text,
  }) async {
    final messageText = text.trim();

    if (messageText.isEmpty) {
      return;
    }

    final chatRef = _chats.doc(chatId);
    final messageRef = chatRef.collection('messages').doc();

    await _firestore.runTransaction((transaction) async {
      final chatSnapshot = await transaction.get(chatRef);

      if (!chatSnapshot.exists) {
        throw StateError('Conversation does not exist.');
      }

      final data = chatSnapshot.data();

      if (data == null || data['participants'] is! List) {
        throw StateError('Invalid conversation data.');
      }

      final participants = List<String>.from(
        data['participants'] as List,
      );

      if (!participants.contains(senderUid)) {
        throw StateError('Sender is not a conversation participant.');
      }

      transaction.set(messageRef, {
        'senderId': senderUid,
        'text': messageText,
        'createdAt': FieldValue.serverTimestamp(),
      });

      transaction.update(chatRef, {
        'lastMessage': messageText,
        'lastMessageAt': FieldValue.serverTimestamp(),
      });
    });
  }
}
