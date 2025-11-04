import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  const AppShell(this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (int index) {
          _onItemTapped(index, context);
        },
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book),
            label: 'Reader',
          ),
          NavigationDestination(
            icon: Icon(Icons.stacked_bar_chart),
            selectedIcon: Icon(Icons.stacked_bar_chart),
            label: 'Stats',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center_outlined),
            selectedIcon: Icon(Icons.fitness_center),
            label: 'Practice',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Social',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  // Maps the route path to the tab index
  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    if (location == '/reader') {
      return 0;
    }
    if (location == '/stats') {
      return 1;
    }
    if (location == '/practice') {
      return 2;
    }
    if (location == '/social') {
      return 3;
    }
    if (location == '/settings') {
      return 4;
    }
    // Default to /practice
    return 2;
  }

  // Navigates to the correct route when a tab is tapped
  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/reader');
        break;
      case 1:
        GoRouter.of(context).go('/stats');
        break;
      case 2:
        GoRouter.of(context).go('/practice');
        break;
      case 3:
        GoRouter.of(context).go('/social');
        break;
      case 4:
        GoRouter.of(context).go('/settings');
        break;
    }
  }
}
