part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignInWithGoogle extends AuthEvent {}

class SignOut extends AuthEvent {}

class CheckAuthStatus extends AuthEvent {}
