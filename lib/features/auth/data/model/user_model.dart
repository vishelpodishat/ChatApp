import 'package:chat_app/features/auth/domain/entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.email,
    required super.displayName,
    super.photoUrl,
    required super.lastSeen,
    required super.isOnline,
    super.fcmToken,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      photoUrl: data['photoUrl'] as String?,
      lastSeen: data['lastSeen'] != null ? (data['lastSeen'] as Timestamp).toDate() : DateTime.now(),
      isOnline: data['isOnline'] ?? false,
      fcmToken: data['fcmToken'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      'email': email,
      'displayName': displayName,
      'lastSeen': Timestamp.fromDate(lastSeen),
      'isOnline': isOnline,
    };

    if (photoUrl != null) {
      map['photoUrl'] = photoUrl!;
    }
    if (fcmToken != null) {
      map['fcmToken'] = fcmToken!;
    }

    return map;
  }
}
