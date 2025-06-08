part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class LoadMessages extends ChatEvent {
  final String chatId;

  const LoadMessages(this.chatId);

  @override
  List<Object> get props => [chatId];
}

class MessagesUpdated extends ChatEvent {
  final List<MessageEntity> messages;

  const MessagesUpdated(this.messages);

  @override
  List<Object> get props => [messages];
}

class SendMessage extends ChatEvent {
  final String chatId;
  final String text;
  final String senderId;
  final String senderName;
  final String receiverId;

  const SendMessage({
    required this.chatId,
    required this.text,
    required this.senderId,
    required this.senderName,
    required this.receiverId,
  });

  @override
  List<Object> get props => [chatId, text, senderId, senderName, receiverId];
}

class MarkMessagesAsRead extends ChatEvent {
  final String chatId;
  final String userId;

  const MarkMessagesAsRead(this.chatId, this.userId);

  @override
  List<Object> get props => [chatId, userId];
}
