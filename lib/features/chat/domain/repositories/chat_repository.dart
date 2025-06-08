import 'package:chat_app/core/errors/error.dart';
import 'package:chat_app/features/auth/domain/entities/user_entity.dart';
import 'package:chat_app/features/chat/domain/entities/chat_entity.dart';
import 'package:chat_app/features/chat/domain/entities/message_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ChatRepository {
  Stream<List<ChatEntity>> getUserChats(String userId);
  Stream<List<MessageEntity>> getChatMessages(String chatId);
  Future<Either<Failure, void>> sendMessage({
    required String chatId,
    required String text,
    required String senderId,
    required String senderName,
    required String receiverId,
  });
  Future<Either<Failure, void>> markMessagesAsRead(String chatId, String userId);
  Future<Either<Failure, String>> createChat(String userId, String otherUserId);
  Stream<List<UserEntity>> getAllUsers();
}
