import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/screens/settings_screen.dart';
import 'package:flutter_app/presentation/screens/login_screen.dart';
import 'package:flutter_app/presentation/screens/practice_screen.dart';
import 'package:flutter_app/presentation/screens/reader_screen.dart';
import 'package:flutter_app/presentation/screens/social_screen.dart';
import 'package:flutter_app/presentation/screens/splash_screen.dart';
import 'package:flutter_app/presentation/screens/stats_screen.dart';
import 'package:flutter_app/presentation/widgets/app_shell.dart';
import 'package:flutter_app/providers/auth_provider.dart';
import 'package:flutter_app/providers/splash_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_app/utils/debugger.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  // Listenable watched by GoRouter
  final refreshListenable = ValueNotifier<int>(0);

  // Dispose old instance
  ref.onDispose(() => refreshListenable.dispose());

  // Watching the auth stream and updating the listenable
  // Triggers the redirect logic to re-run
  ref.listen(authStreamProvider, (_, __) {
    refreshListenable.value++;
  });

  final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: refreshListenable,
    navigatorKey: _rootNavigatorKey,
    redirect: (BuildContext context, GoRouterState state) {
      final authState = ref.read(authStreamProvider);
      final splashDone = ref.watch(splashDelayProvider).hasValue;
      final location = state.matchedLocation;

      // Prevents the app from flashing the login screen while it is checking for a cached user
      if (authState.isLoading || !splashDone) {
        return location == '/splash' ? null : '/splash';
      }

      final isLoggedIn = authState.hasValue && authState.value != null;
      final isGoingToLogin = location == '/login';
      final isGoingToSplash = location == '/splash';

      // Redirect to login page
      if (!isLoggedIn && !isGoingToLogin) {
        Debugger.log('not logged in');
        Debugger.log('redirecting to /login');
        return '/login';
      }

      // Redirect to practice
      if (isLoggedIn && (isGoingToLogin || isGoingToSplash)) {
        Debugger.log('logged in');
        Debugger.log('redirecting to /practice');

        return '/practice';
      }

      // Nothing needed
      return null;
    },

    routes: <RouteBase>[
      // Public routes
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: '/splash',
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreen();
        },
      ),

      // Protected routes
      ShellRoute(
        builder: (context, state, child) {
          return AppShell(child);
        },
        routes: [
          GoRoute(
            path: '/reader',
            builder: (BuildContext context, GoRouterState state) {
              return const ReaderScreen();
            },
          ),
          GoRoute(
            path: '/stats',
            builder: (BuildContext context, GoRouterState state) {
              return const StatsScreen();
            },
          ),
          GoRoute(
            path: '/practice',
            builder: (BuildContext context, GoRouterState state) {
              return const PracticeScreen();
            },
          ),
          GoRoute(
            path: '/social',
            builder: (BuildContext context, GoRouterState state) {
              return const SocialScreen();
            },
          ),
          GoRoute(
            path: '/settings',
            builder: (BuildContext context, GoRouterState state) {
              return const SettingsScreen();
            },
          ),
        ],
      ),
    ],
  );
});
