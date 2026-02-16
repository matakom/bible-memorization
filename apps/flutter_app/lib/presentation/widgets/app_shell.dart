import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatefulWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  /// Maps the current route to a Tab Index (0-4)
  int _calculateSelectedIndex(BuildContext context) {
    // GoRouterState needs to be accessed carefully inside build
    final String location = GoRouterState.of(context).uri.toString();
    
    if (location.startsWith('/reader')) return 0;
    if (location.startsWith('/stats')) return 1;
    if (location.startsWith('/practice')) return 2;
    if (location.startsWith('/social')) return 3;
    if (location.startsWith('/settings')) return 4;
    
    return 2; // Default: Practice Screen
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/reader');
        break;
      case 1:
        context.go('/stats');
        break;
      case 2:
        context.go('/practice');
        break;
      case 3:
        context.go('/social');
        break;
      case 4:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (idx) => _onItemTapped(idx, context),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.menu_book_rounded),
            label: 'Bible',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Stats',
          ),
          NavigationDestination(
            icon: Icon(Icons.play_circle_fill, size: 30), 
            label: 'Practice',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_rounded),
            label: 'Social',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}