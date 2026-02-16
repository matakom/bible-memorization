import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Screens
import '../../presentation/screens/splash_screen.dart';
import '../../presentation/screens/reader_screen.dart';
// import '../../presentation/screens/login_screen.dart';
// import '../../presentation/screens/practice_screen.dart';
// import '../../presentation/screens/stats_screen.dart';
// import '../../presentation/screens/social_screen.dart';
import '../../presentation/screens/settings_screen.dart';
// import '../../presentation/screens/friends_stats_screen.dart';
import '../../presentation/widgets/app_shell.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    // 1. Start directly in the app (Offline First)
    initialLocation: '/reader',
    debugLogDiagnostics: true,
    
    // 2. NO Refresh Listenable -> NO Infinite Loops
    // The router is now static and stable.

    routes: [
      GoRoute(
        path: '/splash', 
        builder: (context, state) => const SplashScreen()
      ),
      
      // The AppShell keeps the Bottom Navigation Bar persistent
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/reader', 
            builder: (context, state) => const ReaderScreen()
          ),
          
          /* // Uncomment these as you build them
          GoRoute(path: '/practice', builder: (context, state) => const PracticeScreen()),
          GoRoute(path: '/stats', builder: (context, state) => const StatsScreen()),
          GoRoute(path: '/social', builder: (context, state) => const SocialScreen(), routes: [
            GoRoute(
              path: ':friendId/:friendshipId',
              builder: (context, state) => FriendStatsScreen(
                friendId: state.pathParameters['friendId']!,
                friendshipId: state.pathParameters['friendshipId']!,
              ),
            ),
          ]),
          */
          GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
        ],
      ),
    ],
  );
});