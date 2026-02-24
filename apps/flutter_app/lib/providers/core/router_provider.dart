import 'package:flutter_app/presentation/screens/friends_stats_screen.dart';
import 'package:flutter_app/presentation/screens/practice_shell_screen.dart';
import 'package:flutter_app/presentation/screens/settings_screen.dart';
import 'package:flutter_app/presentation/screens/login_screen.dart';
import 'package:flutter_app/presentation/screens/practice_screen.dart';
import 'package:flutter_app/presentation/screens/reader_screen.dart';
import 'package:flutter_app/presentation/screens/social_screen.dart';
import 'package:flutter_app/presentation/screens/splash_screen.dart';
import 'package:flutter_app/presentation/screens/stats_screen.dart';
import 'package:flutter_app/presentation/widgets/app_shell.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final goRouterProvider = Provider<GoRouter>((ref) {

  return GoRouter(
    initialLocation: '/practice',

    routes: <RouteBase>[
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/practice_shell',
        builder: (context, state) => const PracticeShellScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child),
        routes: [
          GoRoute(
            path: '/reader',
            builder: (context, state) => const ReaderScreen(),
          ),
          GoRoute(
            path: '/stats',
            builder: (context, state) => const StatsScreen(),
          ),
          GoRoute(
            path: '/practice',
            builder: (context, state) => const PracticeScreen(),
          ),
          GoRoute(
            path: '/social',
            builder: (context, state) => const SocialScreen(),
            routes: [
              GoRoute(
                path: ':friendId/:friendshipId',
                builder: (context, state) {
                  final friendId = state.pathParameters['friendId']!;
                  final friendshipId = state.pathParameters['friendshipId']!;
                  return FriendStatsScreen(
                    friendId: friendId,
                    friendshipId: friendshipId,
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
});