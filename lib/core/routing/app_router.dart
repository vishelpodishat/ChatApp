import 'package:auto_route/auto_route.dart';
import 'package:chat_app/core/routing/app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  final bool isOldUser;

  AppRouter({this.isOldUser = false});

  @override
  RouteType get defaultRouteType => RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: LoginView.page),
    AutoRoute(
      page: HomeRoute.page,
      path: '/home',
      children: [AutoRoute(page: ChatsRoute.page, path: 'chats', initial: true), AutoRoute(page: UsersRoute.page, path: 'users')],
    ),
    AutoRoute(page: ChatRoute.page, path: '/chat/:chatId'),
  ];

  @override
  List<AutoRouteGuard> get guards => [];
}
