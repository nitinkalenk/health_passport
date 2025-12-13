import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:health_passport/config/routes.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.sports_esports_rounded),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Profile',
        ),
      ],
      currentIndex: _currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            _setCurrentIndex(0);
            GoRouter.of(context).go(Routes.home);
            break;
          case 1:
            _setCurrentIndex(1);
            GoRouter.of(context).go(Routes.profile);
        }
      },
    );
  }

  void _setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
