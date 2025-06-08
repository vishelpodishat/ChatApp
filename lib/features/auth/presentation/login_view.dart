import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:chat_app/core/di/di.dart';
import 'package:chat_app/core/routing/app_router.gr.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginViewPage();
  }
}

class LoginViewPage extends StatelessWidget {
  const LoginViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          context.router.replace(const HomeRoute());
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.chat_bubble_rounded, size: 120, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 32),
                  Text(
                    'Добро пожаловать в Chat App',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Общайтесь с друзьями в режиме реального времени',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  // if (Platform.isIOS && kDebugMode) ...[
                  //   // Mock sign-in button for iOS testing
                  //   ElevatedButton.icon(
                  //     onPressed:
                  //         state is AuthLoading
                  //             ? null
                  //             : () {
                  //               context.read<AuthBloc>().add(SignInWithGoogle());
                  //             },
                  //     icon:
                  //         state is AuthLoading
                  //             ? const SizedBox(
                  //               width: 20,
                  //               height: 20,
                  //               child: CircularProgressIndicator(
                  //                 strokeWidth: 2,
                  //                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  //               ),
                  //             )
                  //             : const Icon(Icons.person),
                  //     label: Text(state is AuthLoading ? 'Вход в систему...' : 'Войти как тестовый пользователь'),
                  //     style: ElevatedButton.styleFrom(
                  //       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  //     ),
                  //   ),
                  //   const SizedBox(height: 16),
                  //   Text(
                  //     'Используется тестовый режим для iOS',
                  //     style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.orange),
                  //     textAlign: TextAlign.center,
                  //   ),
                  // ] else ...[
                  // Regular Google Sign-In for Android
                  ElevatedButton.icon(
                    onPressed:
                        state is AuthLoading
                            ? null
                            : () {
                              context.read<AuthBloc>().add(SignInWithGoogle());
                            },
                    icon:
                        state is AuthLoading
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                            : Image.asset(
                              'assets/images/google_logo.png',
                              height: 24,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.login);
                              },
                            ),
                    label: Text(state is AuthLoading ? 'Вход в систему...' : 'Войти через Google'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
                // ],
              ),
            ),
          ),
        );
      },
    );
  }
}
