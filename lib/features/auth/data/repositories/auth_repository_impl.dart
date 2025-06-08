import 'dart:io';

import 'package:chat_app/core/di/di.dart';
import 'package:chat_app/core/errors/error.dart';
import 'package:chat_app/core/notification/notification_service.dart';
import 'package:chat_app/features/auth/data/model/user_model.dart';
import 'package:chat_app/features/auth/domain/entities/user_entity.dart';
import 'package:chat_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl(this._firebaseAuth, this._googleSignIn, this._firestore);

  @override
  Stream<UserEntity?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) return null;

      return UserModel.fromFirestore(doc);
    });
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) return const Right(null);

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) return const Right(null);

      return Right(UserModel.fromFirestore(doc));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    // if (Platform.isIOS && kDebugMode) {
    //   return _mockSignIn();
    // }

    // FOR Prod
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return Left(AuthFailure('Google sign in cancelled'));
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) {
        return Left(AuthFailure('Failed to get user data'));
      }

      return _saveUserData(user);
    } catch (e) {
      print('Sign in error: $e');
      return Left(AuthFailure(e.toString()));
    }
  }

  // Mock sign in for iOS testing
  Future<Either<Failure, UserEntity>> _mockSignIn() async {
    try {
      print('Using mock sign-in for iOS testing...');

      // Sign in with a test account using email/password
      final userCredential = await _firebaseAuth.signInAnonymously();
      final user = userCredential.user;

      if (user == null) {
        return Left(AuthFailure('Mock sign in failed'));
      }

      // Create a mock user with test data
      final userModel = UserModel(
        uid: user.uid,
        email: 'testuser@example.com',
        displayName: 'Test User',
        photoUrl: null,
        lastSeen: DateTime.now(),
        isOnline: true,
        fcmToken: null,
      );

      await _firestore.collection('users').doc(user.uid).set(userModel.toMap(), SetOptions(merge: true));

      return Right(userModel);
    } catch (e) {
      print('Mock sign in error: $e');
      return Left(AuthFailure('Mock sign in failed: $e'));
    }
  }

  Future<Either<Failure, UserEntity>> _saveUserData(User user) async {
    try {
      String? fcmToken;
      try {
        final notificationService = getIt<NotificationService>();
        if (notificationService.isNotificationAvailable) {
          fcmToken = await notificationService.getToken();
        }
      } catch (e) {
        print('Could not get FCM token: $e');
      }

      final userModel = UserModel(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? 'User',
        photoUrl: user.photoURL,
        lastSeen: DateTime.now(),
        isOnline: true,
        fcmToken: fcmToken,
      );

      await _firestore.collection('users').doc(user.uid).set(userModel.toMap(), SetOptions(merge: true));

      return Right(userModel);
    } catch (e) {
      return Left(AuthFailure('Failed to save user data: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        await updateUserOnlineStatus(user.uid, false);
      }
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<void> updateFcmToken(String uid, String token) async {
    try {
      await _firestore.collection('users').doc(uid).update({'fcmToken': token});
    } catch (e) {
      print('Error updating FCM token: $e');
    }
  }

  @override
  Future<void> updateUserOnlineStatus(String uid, bool isOnline) async {
    try {
      await _firestore.collection('users').doc(uid).update({'isOnline': isOnline, 'lastSeen': FieldValue.serverTimestamp()});
    } catch (e) {
      print('Error updating user online status: $e');
    }
  }
}
