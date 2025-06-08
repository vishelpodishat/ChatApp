import 'package:auto_route/auto_route.dart';
import 'package:chat_app/core/di/di.dart';
import 'package:chat_app/core/routing/app_router.gr.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chat_app/features/chat/chat_list_bloc/chat_list_bloc.dart';
import 'package:chat_app/features/chat/user_bloc/users_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            print('AuthState: $state'); // Debug log

            switch (state) {
              case Authenticated(:final user):
                print('User authenticated: ${user.uid}, ${user.displayName}'); // Debug log

                return MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) {
                        print('Creating ChatListBloc for user: ${user.uid}'); // Debug log
                        return getIt<ChatListBloc>()..add(LoadChats(user.uid));
                      },
                    ),
                    BlocProvider(
                      create: (context) {
                        print('Creating UsersBloc'); // Debug log
                        return getIt<UsersBloc>()..add(LoadUsers());
                      },
                    ),
                  ],
                  child: Scaffold(
                    appBar: AppBar(
                      title: Text(tabsRouter.activeIndex == 0 ? 'Chats' : 'Users'),
                      actions: [
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'logout') {
                              context.read<AuthBloc>().add(SignOut());
                            }
                          },
                          itemBuilder:
                              (context) => [
                                const PopupMenuItem(
                                  value: 'logout',
                                  child: Row(
                                    children: [Icon(Icons.logout, color: Colors.red), SizedBox(width: 8), Text('Logout')],
                                  ),
                                ),
                              ],
                        ),
                      ],
                    ),
                    body: child,
                    bottomNavigationBar: NavigationBar(
                      selectedIndex: tabsRouter.activeIndex,
                      onDestinationSelected: tabsRouter.setActiveIndex,
                      destinations: const [
                        NavigationDestination(
                          icon: Icon(Icons.chat_bubble_outline),
                          selectedIcon: Icon(Icons.chat_bubble),
                          label: 'Chats',
                        ),
                        NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: 'Users'),
                      ],
                    ),
                  ),
                );
              case Unauthenticated():
                print('User unauthenticated, redirecting to login'); // Debug log
                context.router.replace(const LoginView());
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              default:
                print('Unknown auth state: $state'); // Debug log
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }
          },
        );
      },
    );
  }
}
