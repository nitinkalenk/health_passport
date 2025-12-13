import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:health_passport/config/routes.dart';
import 'package:health_passport/shared/bottomnavbar.dart';
import 'package:health_passport/ui/home/home.dart';
import 'package:health_passport/ui/profile/profile.dart';

GoRouter router() => GoRouter(
  initialLocation: Routes.home,
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return Scaffold(
          body: SafeArea(child: child),
          bottomNavigationBar: const BottomNavBar(),
        );
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
      ],
    ),
  ],
);
