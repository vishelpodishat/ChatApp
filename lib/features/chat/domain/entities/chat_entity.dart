import 'package:chat_app/features/auth/domain/entities/user_entity.dart';
import 'package:chat_app/features/chat/domain/entities/message_entity.dart';
import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable {
  final String id;
  final UserEntity otherUser;
  final MessageEntity? lastMessage;
  final int unreadCount;
  final DateTime lastActivity;

  const ChatEntity({
    required this.id,
    required this.otherUser,
    this.lastMessage,
    required this.unreadCount,
    required this.lastActivity,
  });

  @override
  List<Object?> get props => [id, otherUser, lastMessage, unreadCount, lastActivity];
}
