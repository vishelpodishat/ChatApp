import 'package:chat_app/core/errors/error.dart';
import 'package:chat_app/features/auth/data/model/user_model.dart';
import 'package:chat_app/features/auth/domain/entities/user_entity.dart';
import 'package:chat_app/features/chat/data/models/message_model.dart';
import 'package:chat_app/features/chat/domain/entities/chat_entity.dart';
import 'package:chat_app/features/chat/domain/entities/message_entity.dart';
import 'package:chat_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ChatRepositoryImpl implements ChatRepository {
  final FirebaseFirestore _firestore;
  final FirebaseMessaging _messaging;

  ChatRepositoryImpl(this._firestore, this._messaging);

  String _getChatId(String userId1, String userId2) {
    return userId1.compareTo(userId2) < 0 ? '${userId1}_$userId2' : '${userId2}_$userId1';
  }

  @override
  Stream<List<ChatEntity>> getUserChats(String userId) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('lastActivity', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          final chats = <ChatEntity>[];

          for (final doc in snapshot.docs) {
            try {
              final data = doc.data();
              final participants = List<String>.from(data['participants'] ?? []);

              if (participants.length < 2) {
                continue;
              }

              final otherUserId = participants.firstWhere((id) => id != userId, orElse: () => '');

              if (otherUserId.isEmpty) {
                continue;
              }

              final userDoc = await _firestore.collection('users').doc(otherUserId).get();
              if (!userDoc.exists) {
                continue;
              }

              final otherUser = UserModel.fromFirestore(userDoc);

              MessageEntity? lastMessage;
              if (data['lastMessage'] != null && data['lastMessage'] is Map) {
                try {
                  final lastMessageData = data['lastMessage'] as Map<String, dynamic>;
                  lastMessage = MessageModel(
                    id: '',
                    text: lastMessageData['text'] ?? '',
                    senderId: lastMessageData['senderId'] ?? '',
                    senderName: lastMessageData['senderName'] ?? '',
                    receiverId: lastMessageData['receiverId'] ?? '',
                    timestamp:
                        lastMessageData['timestamp'] != null
                            ? (lastMessageData['timestamp'] as Timestamp).toDate()
                            : DateTime.now(),
                    isRead: lastMessageData['isRead'] ?? false,
                  );
                } catch (e) {
                  print('Error parsing last message: $e');
                }
              }

              final unreadCount = await _firestore
                  .collection('chats')
                  .doc(doc.id)
                  .collection('messages')
                  .where('receiverId', isEqualTo: userId)
                  .where('isRead', isEqualTo: false)
                  .get()
                  .then((snapshot) => snapshot.size);

              DateTime lastActivity;
              try {
                if (data['lastActivity'] != null && data['lastActivity'] is Timestamp) {
                  lastActivity = (data['lastActivity'] as Timestamp).toDate();
                } else {
                  lastActivity = DateTime.now();
                }
              } catch (e) {
                print('Error parsing lastActivity: $e');
                lastActivity = DateTime.now();
              }

              chats.add(
                ChatEntity(
                  id: doc.id,
                  otherUser: otherUser,
                  lastMessage: lastMessage,
                  unreadCount: unreadCount,
                  lastActivity: lastActivity,
                ),
              );
            } catch (e) {
              print('Error processing chat ${doc.id}: $e');
              continue;
            }
          }

          return chats;
        });
  }

  @override
  Stream<List<MessageEntity>> getChatMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) {
                    try {
                      return MessageModel.fromFirestore(doc);
                    } catch (e) {
                      print('Error parsing message ${doc.id}: $e');
                      return null;
                    }
                  })
                  .where((message) => message != null)
                  .cast<MessageEntity>()
                  .toList(),
        );
  }

  @override
  Future<Either<Failure, void>> sendMessage({
    required String chatId,
    required String text,
    required String senderId,
    required String senderName,
    required String receiverId,
  }) async {
    try {
      if (text.trim().isEmpty) {
        return Left(ServerFailure('Message cannot be empty'));
      }

      final timestamp = DateTime.now();
      final message = MessageModel(
        id: '',
        text: text.trim(),
        senderId: senderId,
        senderName: senderName,
        receiverId: receiverId,
        timestamp: timestamp,
        isRead: false,
      );

      final batch = _firestore.batch();

      final messageRef = _firestore.collection('chats').doc(chatId).collection('messages').doc();
      batch.set(messageRef, message.toMap());

      final chatRef = _firestore.collection('chats').doc(chatId);
      batch.update(chatRef, {'lastMessage': message.toMap(), 'lastActivity': Timestamp.fromDate(timestamp)});

      await batch.commit();

      try {
        await _sendNotification(receiverId, senderName, text);
      } catch (e) {
        print('Notification failed but message sent: $e');
      }

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<void> _sendNotification(String receiverId, String senderName, String message) async {
    try {
      final receiverDoc = await _firestore.collection('users').doc(receiverId).get();
      if (!receiverDoc.exists) return;

      final fcmToken = receiverDoc.data()?['fcmToken'];
      if (fcmToken == null || fcmToken.isEmpty) return;
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  @override
  Future<Either<Failure, void>> markMessagesAsRead(String chatId, String userId) async {
    try {
      final messages =
          await _firestore
              .collection('chats')
              .doc(chatId)
              .collection('messages')
              .where('receiverId', isEqualTo: userId)
              .where('isRead', isEqualTo: false)
              .get();

      if (messages.docs.isEmpty) {
        return const Right(null);
      }

      final batch = _firestore.batch();

      for (final doc in messages.docs) {
        batch.update(doc.reference, {'isRead': true});
      }

      await batch.commit();

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> createChat(String userId, String otherUserId) async {
    try {
      final chatId = _getChatId(userId, otherUserId);
      final chatRef = _firestore.collection('chats').doc(chatId);

      final chatDoc = await chatRef.get();
      if (!chatDoc.exists) {
        await chatRef.set({
          'participants': [userId, otherUserId],
          'createdAt': FieldValue.serverTimestamp(),
          'lastActivity': FieldValue.serverTimestamp(),
        });
      }

      return Right(chatId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<UserEntity>> getAllUsers() {
    return _firestore
        .collection('users')
        .orderBy('displayName')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) {
                    try {
                      return UserModel.fromFirestore(doc);
                    } catch (e) {
                      print('Error parsing user ${doc.id}: $e');
                      return null;
                    }
                  })
                  .where((user) => user != null)
                  .cast<UserEntity>()
                  .toList(),
        );
  }
}
