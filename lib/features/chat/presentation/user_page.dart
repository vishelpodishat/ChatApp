import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/core/routing/app_router.gr.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chat_app/features/chat/user_bloc/users_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = (context.read<AuthBloc>().state as Authenticated).user;

    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        if (state is UsersLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UsersLoaded) {
          final filteredUsers = state.users.where((user) => user.uid != currentUser.uid).toList();

          if (filteredUsers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text('Пользователей нет', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey[600])),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              final user = filteredUsers[index];

              return ListTile(
                onTap: () async {
                  final chatId = await context.read<UsersBloc>().createChat(currentUser.uid, user.uid);

                  if (chatId != null && context.mounted) {
                    await context.router.root.push(ChatRoute(chatId: chatId, otherUser: user));
                  }
                },
                leading: Stack(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: user.photoUrl != null ? CachedNetworkImageProvider(user.photoUrl!) : null,
                      child:
                          user.photoUrl == null
                              ? Text(
                                user.displayName[0].toUpperCase(),
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              )
                              : null,
                    ),
                    if (user.isOnline)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                title: Text(user.displayName, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(user.email, style: TextStyle(color: Colors.grey[600])),
                trailing: Icon(Icons.message_outlined, color: Theme.of(context).colorScheme.primary),
              );
            },
          );
        } else if (state is UsersError) {
          return Center(child: Text('Error: ${state.message}', style: const TextStyle(color: Colors.red)));
        }
        return const SizedBox();
      },
    );
  }
}
