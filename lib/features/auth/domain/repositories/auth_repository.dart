import 'package:chat_app/core/errors/error.dart';
import 'package:chat_app/features/auth/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signInWithGoogle();
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, UserEntity?>> getCurrentUser();
  Stream<UserEntity?> get authStateChanges;
  Future<void> updateUserOnlineStatus(String uid, bool isOnline);
  Future<void> updateFcmToken(String uid, String token);
}
