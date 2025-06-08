import 'package:chat_app/core/notification/notification_service.dart';
import 'package:chat_app/core/routing/app_router.dart';
import 'package:chat_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:chat_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chat_app/features/chat/chat_bloc/chat_bloc.dart';
import 'package:chat_app/features/chat/chat_list_bloc/chat_list_bloc.dart';
import 'package:chat_app/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:chat_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:chat_app/features/chat/user_bloc/users_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Firebase Services
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  getIt.registerLazySingleton<FirebaseMessaging>(() => FirebaseMessaging.instance);
  getIt.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);
  getIt.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn());

  // Services
  getIt.registerLazySingleton<NotificationService>(() => NotificationService(getIt<FirebaseMessaging>()));

  // Router
  getIt.registerLazySingleton<AppRouter>(() => AppRouter());

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<FirebaseAuth>(), getIt<GoogleSignIn>(), getIt<FirebaseFirestore>()),
  );

  getIt.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(getIt<FirebaseFirestore>(), getIt<FirebaseMessaging>()));

  // Blocs
  getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt<AuthRepository>()));

  getIt.registerFactory<ChatListBloc>(() => ChatListBloc(getIt<ChatRepository>()));

  getIt.registerFactory<ChatBloc>(() => ChatBloc(getIt<ChatRepository>()));

  getIt.registerFactory<UsersBloc>(() => UsersBloc(getIt<ChatRepository>()));
}
