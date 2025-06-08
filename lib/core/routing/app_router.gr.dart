// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:chat_app/features/auth/domain/entities/user_entity.dart' as _i9;
import 'package:chat_app/features/auth/presentation/login_view.dart' as _i4;
import 'package:chat_app/features/chat/presentation/chat_page.dart' as _i1;
import 'package:chat_app/features/chat/presentation/chats_page.dart' as _i2;
import 'package:chat_app/features/chat/presentation/home_page.dart' as _i3;
import 'package:chat_app/features/chat/presentation/user_page.dart' as _i6;
import 'package:chat_app/features/launch/launch_screen.dart' as _i5;
import 'package:flutter/material.dart' as _i8;

/// generated route for
/// [_i1.ChatPage]
class ChatRoute extends _i7.PageRouteInfo<ChatRouteArgs> {
  ChatRoute({
    _i8.Key? key,
    required String chatId,
    required _i9.UserEntity otherUser,
    List<_i7.PageRouteInfo>? children,
  }) : super(
         ChatRoute.name,
         args: ChatRouteArgs(key: key, chatId: chatId, otherUser: otherUser),
         initialChildren: children,
       );

  static const String name = 'ChatRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChatRouteArgs>();
      return _i1.ChatPage(
        key: args.key,
        chatId: args.chatId,
        otherUser: args.otherUser,
      );
    },
  );
}

class ChatRouteArgs {
  const ChatRouteArgs({
    this.key,
    required this.chatId,
    required this.otherUser,
  });

  final _i8.Key? key;

  final String chatId;

  final _i9.UserEntity otherUser;

  @override
  String toString() {
    return 'ChatRouteArgs{key: $key, chatId: $chatId, otherUser: $otherUser}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ChatRouteArgs) return false;
    return key == other.key &&
        chatId == other.chatId &&
        otherUser == other.otherUser;
  }

  @override
  int get hashCode => key.hashCode ^ chatId.hashCode ^ otherUser.hashCode;
}

/// generated route for
/// [_i2.ChatsPage]
class ChatsRoute extends _i7.PageRouteInfo<void> {
  const ChatsRoute({List<_i7.PageRouteInfo>? children})
    : super(ChatsRoute.name, initialChildren: children);

  static const String name = 'ChatsRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i2.ChatsPage();
    },
  );
}

/// generated route for
/// [_i3.HomePage]
class HomeRoute extends _i7.PageRouteInfo<void> {
  const HomeRoute({List<_i7.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i3.HomePage();
    },
  );
}

/// generated route for
/// [_i4.LoginView]
class LoginView extends _i7.PageRouteInfo<void> {
  const LoginView({List<_i7.PageRouteInfo>? children})
    : super(LoginView.name, initialChildren: children);

  static const String name = 'LoginView';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i4.LoginView();
    },
  );
}

/// generated route for
/// [_i5.SplashPage]
class SplashRoute extends _i7.PageRouteInfo<void> {
  const SplashRoute({List<_i7.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i5.SplashPage();
    },
  );
}

/// generated route for
/// [_i6.UsersPage]
class UsersRoute extends _i7.PageRouteInfo<void> {
  const UsersRoute({List<_i7.PageRouteInfo>? children})
    : super(UsersRoute.name, initialChildren: children);

  static const String name = 'UsersRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i6.UsersPage();
    },
  );
}
