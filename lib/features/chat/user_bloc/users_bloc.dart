import 'dart:async';

import 'package:chat_app/features/auth/domain/entities/user_entity.dart';
import 'package:chat_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final ChatRepository _chatRepository;
  StreamSubscription<List<UserEntity>>? _usersSubscription;

  UsersBloc(this._chatRepository) : super(UsersInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<UsersUpdated>(_onUsersUpdated);
  }

  Future<void> _onLoadUsers(LoadUsers event, Emitter<UsersState> emit) async {
    emit(UsersLoading());

    await _usersSubscription?.cancel();
    _usersSubscription = _chatRepository.getAllUsers().listen((users) {
      add(UsersUpdated(users));
    });
  }

  void _onUsersUpdated(UsersUpdated event, Emitter<UsersState> emit) {
    emit(UsersLoaded(event.users));
  }

  Future<String?> createChat(String userId, String otherUserId) async {
    final result = await _chatRepository.createChat(userId, otherUserId);
    return result.fold((failure) => null, (chatId) => chatId);
  }

  @override
  Future<void> close() {
    _usersSubscription?.cancel();
    return super.close();
  }
}
