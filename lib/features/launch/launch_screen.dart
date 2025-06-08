import 'package:auto_route/auto_route.dart';
import 'package:chat_app/core/routing/app_router.gr.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          context.router.replace(const HomeRoute());
        } else if (state is Unauthenticated) {
          context.router.replace(const LoginView());
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.chat_bubble_rounded, size: 100, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 24),
              Text(
                'Chat App',
                style: Theme.of(
                  context,
                ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 48),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
