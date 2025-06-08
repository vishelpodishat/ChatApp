import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String id;
  final String text;
  final String senderId;
  final String senderName;
  final String receiverId;
  final DateTime timestamp;
  final bool isRead;

  const MessageEntity({
    required this.id,
    required this.text,
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.timestamp,
    required this.isRead,
  });

  @override
  List<Object> get props => [id, text, senderId, senderName, receiverId, timestamp, isRead];
}
