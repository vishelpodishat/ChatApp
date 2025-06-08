import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;
  final DateTime lastSeen;
  final bool isOnline;
  final String? fcmToken;

  const UserEntity({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
    required this.lastSeen,
    required this.isOnline,
    this.fcmToken,
  });

  @override
  List<Object?> get props => [uid, email, displayName, photoUrl, lastSeen, isOnline, fcmToken];
}
