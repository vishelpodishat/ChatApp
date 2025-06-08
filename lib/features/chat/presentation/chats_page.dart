import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/core/routing/app_router.gr.dart';
import 'package:chat_app/features/chat/chat_list_bloc/chat_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

@RoutePage()
class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatListBloc, ChatListState>(
      builder: (context, state) {
        if (state is ChatListLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ChatListLoaded) {
          if (state.chats.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text('No chats yet', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey[600])),
                  const SizedBox(height: 8),
                  Text(
                    'Start a conversation from the Users tab',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: state.chats.length,
            itemBuilder: (context, index) {
              final chat = state.chats[index];
              final lastMessage = chat.lastMessage;
              final formattedTime = lastMessage != null ? _formatTime(lastMessage.timestamp) : '';

              return ListTile(
                onTap: () {
                  context.router.push(ChatRoute(chatId: chat.id, otherUser: chat.otherUser));
                },
                leading: Stack(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.grey[300],
                      backgroundImage:
                          chat.otherUser.photoUrl != null ? CachedNetworkImageProvider(chat.otherUser.photoUrl!) : null,
                      child:
                          chat.otherUser.photoUrl == null
                              ? Text(
                                chat.otherUser.displayName[0].toUpperCase(),
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              )
                              : null,
                    ),
                    if (chat.otherUser.isOnline)
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
                title: Text(chat.otherUser.displayName, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle:
                    lastMessage != null
                        ? Text(
                          lastMessage.text,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: chat.unreadCount > 0 ? Theme.of(context).textTheme.bodyMedium?.color : Colors.grey[600],
                            fontWeight: chat.unreadCount > 0 ? FontWeight.w500 : FontWeight.normal,
                          ),
                        )
                        : Text('Start a conversation', style: TextStyle(color: Colors.grey[500], fontStyle: FontStyle.italic)),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (lastMessage != null)
                      Text(
                        formattedTime,
                        style: TextStyle(
                          fontSize: 12,
                          color: chat.unreadCount > 0 ? Theme.of(context).colorScheme.primary : Colors.grey[600],
                        ),
                      ),
                    if (chat.unreadCount > 0) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          chat.unreadCount.toString(),
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        } else if (state is ChatListError) {
          return Center(child: Text('Error: ${state.message}', style: const TextStyle(color: Colors.red)));
        }
        return const SizedBox();
      },
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      return DateFormat('HH:mm').format(timestamp);
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE').format(timestamp);
    } else {
      return DateFormat('dd/MM/yyyy').format(timestamp);
    }
  }
}
