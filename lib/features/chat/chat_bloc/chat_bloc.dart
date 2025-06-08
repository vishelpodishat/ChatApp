import 'dart:async';

import 'package:chat_app/features/chat/domain/entities/message_entity.dart';
import 'package:chat_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;
  StreamSubscription<List<MessageEntity>>? _messagesSubscription;

  ChatBloc(this._chatRepository) : super(ChatInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<MessagesUpdated>(_onMessagesUpdated);
    on<SendMessage>(_onSendMessage);
    on<MarkMessagesAsRead>(_onMarkMessagesAsRead);
  }

  Future<void> _onLoadMessages(LoadMessages event, Emitter<ChatState> emit) async {
    emit(ChatLoading());

    await _messagesSubscription?.cancel();
    _messagesSubscription = _chatRepository
        .getChatMessages(event.chatId)
        .listen(
          (messages) {
            add(MessagesUpdated(messages));
          },
          onError: (error) {
            emit(ChatError(error.toString()));
          },
        );
  }

  void _onMessagesUpdated(MessagesUpdated event, Emitter<ChatState> emit) {
    emit(ChatLoaded(event.messages));
  }

  Future<void> _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
    final result = await _chatRepository.sendMessage(
      chatId: event.chatId,
      text: event.text,
      senderId: event.senderId,
      senderName: event.senderName,
      receiverId: event.receiverId,
    );

    result.fold((failure) => emit(ChatError(failure.message)), (_) => {});
  }

  Future<void> _onMarkMessagesAsRead(MarkMessagesAsRead event, Emitter<ChatState> emit) async {
    await _chatRepository.markMessagesAsRead(event.chatId, event.userId);
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
