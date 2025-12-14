import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:health_passport/config/routes.dart';
import 'package:health_passport/ui/home/home.dart';
import 'package:health_passport/ui/health/my_health.dart';
import 'package:health_passport/ui/profile/profile.dart';
import 'package:health_passport/ui/web/shares_content.dart';
import 'package:health_passport/ui/web/shares_login.dart';
import 'package:health_passport/ui/web/web_report_preview.dart';

GoRouter router() => GoRouter(
  initialLocation: Routes.home,
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return _ScaffoldWithBottomNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: Routes.home,
          builder: (context, state) => const HomePageScreen(),
        ),
        GoRoute(
          path: Routes.profile,
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: Routes.myHealth,
          builder: (context, state) => const MyHealthScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/shares',
      builder: (context, state) => const SharesLoginScreen(),
      routes: [
        GoRoute(
          path: ':pin',
          builder: (context, state) {
            final pin = state.pathParameters['pin']!;
            return SharesContentScreen(pin: pin);
          },
          routes: [
            GoRoute(
              path: 'preview/:reportId',
              builder: (context, state) {
                final pin = state.pathParameters['pin']!;
                final reportId = state.pathParameters['reportId']!;
                return WebReportPreviewScreen(pin: pin, reportId: reportId);
              },
            ),
          ],
        ),
      ],
    ),
  ],
);

class _ScaffoldWithBottomNavBar extends StatefulWidget {
  final Widget child;
  const _ScaffoldWithBottomNavBar({required this.child});

  @override
  State<_ScaffoldWithBottomNavBar> createState() =>
      _ScaffoldWithBottomNavBarState();
}

class _ScaffoldWithBottomNavBarState extends State<_ScaffoldWithBottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index, BuildContext context) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      context.go(Routes.home);
    } else if (index == 1) {
      context.go(Routes.myHealth);
    } else if (index == 2) {
      context.go(Routes.profile);
    }
  }

  // Determine index based on location to keep sync
  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith(Routes.profile)) {
      return 2;
    }
    if (location.startsWith(Routes.myHealth)) {
      return 1;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'My Health',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _calculateSelectedIndex(context),
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: (index) => _onItemTapped(index, context),
      ),
    );
  }
}
