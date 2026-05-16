import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/schedule')) return 0;
    if (location.startsWith('/standings')) return 1;
    if (location.startsWith('/drivers')) return 2;
    if (location.startsWith('/stats')) return 3;
    if (location.startsWith('/news')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex(context),
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/schedule');
              break;
            case 1:
              context.go('/standings');
              break;
            case 2:
              context.go('/drivers');
              break;
            case 3:
              context.go('/stats');
              break;
            case 4:
              context.go('/news');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Standings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: 'My Drivers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'News',
          ),
        ],
      ),
    );
  }
}
