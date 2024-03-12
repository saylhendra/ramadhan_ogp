import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ramadhan_ogp/src/features/sanlat/sanlat_registration_screen.dart';

import '../features/home/home_screen.dart';
import '../features/starter/splash_screen.dart';

final GoRouter routerController = GoRouter(
  routerNeglect: true,
  routes: [
    GoRoute(
      path: '/',
      name: SplashScreen.routeName,
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
      routes: [
        GoRoute(
            path: 'home-screen',
            name: HomeScreen.routeName,
            builder: (context, state) {
              return const HomeScreen();
            },
            routes: [
              GoRoute(
                path: 'sanlat-registration-screen',
                name: SanlatRegistrationScreen.routeName,
                builder: (context, state) {
                  return const SanlatRegistrationScreen();
                },
              ),
            ]),
      ],
    ),
  ],
);
