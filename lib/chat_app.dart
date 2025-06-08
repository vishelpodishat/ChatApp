import 'package:chat_app/core/di/di.dart';
import 'package:chat_app/core/routing/app_router.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = getIt<AppRouter>();
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => getIt<AuthBloc>()..add(CheckAuthStatus()))],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
        routerConfig: appRouter.config(),
      ),
    );
  }
}
