import 'dart:async';

import 'package:chat_app/features/chat/domain/entities/chat_entity.dart';
import 'package:chat_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'chat_list_event.dart';
part 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final ChatRepository _chatRepository;
  StreamSubscription<List<ChatEntity>>? _chatsSubscription;

  ChatListBloc(this._chatRepository) : super(ChatListInitial()) {
    on<LoadChats>(_onLoadChats);
    on<ChatsUpdated>(_onChatsUpdated);
    on<ChatListErrorE>(_onChatListError);
  }

  Future<void> _onLoadChats(LoadChats event, Emitter<ChatListState> emit) async {
    emit(ChatListLoading());

    await _chatsSubscription?.cancel();

    _chatsSubscription = _chatRepository
        .getUserChats(event.userId)
        .listen(
          (chats) {
            add(ChatsUpdated(chats));
          },
          onError: (error) {
            print('ChatListBloc error: $error');
            add(ChatListErrorE(error.toString()));
          },
        );
  }

  void _onChatsUpdated(ChatsUpdated event, Emitter<ChatListState> emit) {
    emit(ChatListLoaded(event.chats));
  }

  void _onChatListError(ChatListErrorE event, Emitter<ChatListState> emit) {
    emit(ChatListError(event.error));
  }

  @override
  Future<void> close() {
    _chatsSubscription?.cancel();
    return super.close();
  }
}
