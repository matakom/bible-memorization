import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/screens/friends_stats_screen.dart';
import 'package:flutter_app/presentation/screens/settings_screen.dart';
import 'package:flutter_app/presentation/screens/login_screen.dart';
import 'package:flutter_app/presentation/screens/practice_screen.dart';
import 'package:flutter_app/presentation/screens/reader_screen.dart';
import 'package:flutter_app/presentation/screens/social_screen.dart';
import 'package:flutter_app/presentation/screens/splash_screen.dart';
import 'package:flutter_app/presentation/screens/stats_screen.dart';
import 'package:flutter_app/presentation/widgets/app_shell.dart';
import 'package:flutter_app/providers/auth_controller.dart';
import 'package:flutter_app/providers/auth_provider.dart';
import 'package:flutter_app/providers/settings/settings_loading_provider.dart';
import 'package:flutter_app/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStreamProvider);
  final userState = ref.watch(userDataProvider);
  final isManualLoginLoading = ref.watch(settingsLoadingProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (BuildContext context, GoRouterState state) {
      final location = state.matchedLocation;
      
      if (authState.isLoading) return '/splash';

      final isLoggedIn = authState.value != null;

      if (!isLoggedIn) {
        return (location == '/login') ? null : '/login';
      }

      if (userState.isLoading || isManualLoginLoading) {
        if (location == '/login') return null;
        return '/splash';
      }

      final hasUserData = userState.hasValue && userState.value != null;

      if (hasUserData) {
        if (location == '/login' || location == '/splash') {
          return '/practice';
        }
        return null;
      }

      if (userState.hasError) {
        return '/login';
      }

      return null;
    },

    routes: <RouteBase>[
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
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