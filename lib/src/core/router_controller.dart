import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/home/home_screen.dart';
import '../features/sanlat/sanlat_registration_screen.dart';
import '../features/starter/splash_screen.dart';

final GoRouter routerController = GoRouter(
  routerNeglect: true,
  // initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: SplashScreen.routeName,
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
    ),
    GoRoute(
      path: '/portal-ramadhan-ogp',
      name: HomeScreen.routeName,
      pageBuilder: (context, state) {
        return NoTransitionPage(
          child: const HomeScreen(),
        );
      },
    ),
    GoRoute(
      path: '/sanlat-registration-screen',
      name: SanlatRegistrationScreen.routeName,
      pageBuilder: (context, state) {
        return NoTransitionPage(
          child: const SanlatRegistrationScreen(),
        );
      },
    ),
  ],
);
