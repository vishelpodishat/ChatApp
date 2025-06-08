import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/core/di/di.dart';
import 'package:chat_app/features/auth/domain/entities/user_entity.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chat_app/features/chat/chat_bloc/chat_bloc.dart';
import 'package:chat_app/features/chat/widgets/message_bubble.dart';
import 'package:chat_app/features/chat/widgets/message_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

@RoutePage()
class ChatPage extends StatefulWidget {
  final String chatId;
  final UserEntity otherUser;

  const ChatPage({super.key, required this.chatId, required this.otherUser});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final ChatBloc _chatBloc;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _chatBloc = getIt<ChatBloc>()..add(LoadMessages(widget.chatId));

    final currentUser = (context.read<AuthBloc>().state as Authenticated).user;
    _chatBloc.add(MarkMessagesAsRead(widget.chatId, currentUser.uid));
  }

  @override
  void dispose() {
    _chatBloc.close();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = (context.read<AuthBloc>().state as Authenticated).user;

    return BlocProvider.value(
      value: _chatBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[300],
                backgroundImage:
                    widget.otherUser.photoUrl != null ? CachedNetworkImageProvider(widget.otherUser.photoUrl!) : null,
                child:
                    widget.otherUser.photoUrl == null
                        ? Text(
                          widget.otherUser.displayName[0].toUpperCase(),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        )
                        : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.otherUser.displayName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    if (widget.otherUser.isOnline)
                      const Text('Онлайн', style: TextStyle(fontSize: 12, color: Colors.green))
                    else
                      Text(
                        'Последний раз видели ${_formatLastSeen(widget.otherUser.lastSeen)}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ChatLoaded) {
                    if (state.messages.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'Пока нет сообщений',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Отправьте сообщение, чтобы начать разговор',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      padding: const EdgeInsets.all(16),
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final message = state.messages[index];
                        final isMe = message.senderId == currentUser.uid;
                        final showDate =
                            index == state.messages.length - 1 ||
                            !_isSameDay(message.timestamp, state.messages[index + 1].timestamp);

                        return Column(
                          children: [
                            if (showDate)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                child: Text(
                                  _formatDate(message.timestamp),
                                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                ),
                              ),
                            MessageBubble(message: message, isMe: isMe),
                          ],
                        );
                      },
                    );
                  } else if (state is ChatError) {
                    return Center(child: Text('Error: ${state.message}', style: const TextStyle(color: Colors.red)));
                  }
                  return const SizedBox();
                },
              ),
            ),
            MessageInput(
              controller: _messageController,
              onSend: (text) {
                if (text.trim().isNotEmpty) {
                  _chatBloc.add(
                    SendMessage(
                      chatId: widget.chatId,
                      text: text,
                      senderId: currentUser.uid,
                      senderName: currentUser.displayName,
                      receiverId: widget.otherUser.uid,
                    ),
                  );
                  _messageController.clear();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatLastSeen(DateTime lastSeen) {
    final now = DateTime.now();
    final difference = now.difference(lastSeen);

    if (difference.inMinutes < 1) {
      return 'прямо сейчас';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}минут назад';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}час назад';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}дней назад';
    } else {
      return DateFormat('dd/MM/yyyy').format(lastSeen);
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return 'Сегодня';
    } else if (messageDate == yesterday) {
      return 'Вчера';
    } else {
      return DateFormat('MMMM d, yyyy').format(date);
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }
}
