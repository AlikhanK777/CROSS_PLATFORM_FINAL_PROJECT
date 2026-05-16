import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/main_shell.dart';
import '../../presentation/screens/schedule_screen.dart';
import '../../presentation/screens/standings_screen.dart';
import '../../presentation/screens/drivers_screen.dart';
import '../../presentation/screens/news_screen.dart';
import '../../presentation/screens/stats_screen.dart';
import '../../presentation/screens/add_driver_screen.dart';
import '../../presentation/screens/news_detail_screen.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/schedule',
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/schedule',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ScheduleScreen(),
            ),
          ),
          GoRoute(
            path: '/standings',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: StandingsScreen(),
            ),
          ),
          GoRoute(
            path: '/drivers',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DriversScreen(),
            ),
          ),
          GoRoute(
            path: '/stats',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: StatsScreen(),
            ),
          ),
          GoRoute(
            path: '/news',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: NewsScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/drivers/add',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return AddDriverScreen(driver: extra?['driver']);
        },
      ),
      GoRoute(
        path: '/news/detail',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return NewsDetailScreen(
            title: extra['title'],
            url: extra['url'],
            imageUrl: extra['imageUrl'],
            publishedAt: extra['publishedAt'],
            description: extra['description'],
          );
        },
      ),
    ],
  );
}
