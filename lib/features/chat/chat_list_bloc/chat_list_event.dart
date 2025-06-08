part of 'chat_list_bloc.dart';

abstract class ChatListEvent extends Equatable {
  const ChatListEvent();

  @override
  List<Object> get props => [];
}

class LoadChats extends ChatListEvent {
  final String userId;

  const LoadChats(this.userId);

  @override
  List<Object> get props => [userId];
}

class ChatsUpdated extends ChatListEvent {
  final List<ChatEntity> chats;

  const ChatsUpdated(this.chats);

  @override
  List<Object> get props => [chats];
}

class ChatListErrorE extends ChatListEvent {
  final String error;
  const ChatListErrorE(this.error);
  @override
  List<Object> get props => [error];
}

class ChatListErrorState extends ChatListState {
  final String error;
  const ChatListErrorState(this.error);
  @override
  List<Object> get props => [error];
}
