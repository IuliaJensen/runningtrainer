import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  final String location;

  const MainShell({super.key, required this.child, required this.location});

  int get _currentIndex {
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/training')) return 1;
    if (location.startsWith('/coach')) return 2;
    if (location.startsWith('/progress')) return 3;
    if (location.startsWith('/settings')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final str = context.watch<UserProvider>().str;
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: const Color(0xFF222222),
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) {
            const routes = ['/home', '/training', '/coach', '/progress', '/settings'];
            context.go(routes[i]);
          },
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home, color: primary),
              label: str('nav_home'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.fitness_center_outlined),
              activeIcon: Icon(Icons.fitness_center, color: primary),
              label: str('nav_training'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.chat_bubble_outline),
              activeIcon: Icon(Icons.chat_bubble, color: primary),
              label: str('nav_coach'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart, color: primary),
              label: str('nav_progress'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings, color: primary),
              label: str('nav_settings'),
            ),
          ],
        ),
      ),
    );
  }
}
