import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/home/home_screen.dart';
import '../features/starter/splash_screen.dart';

final GoRouter routerController = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: SplashScreen.routeName,
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
      routes: [
        // GoRoute(
        //   path: 'menu-screen',
        //   name: MenuScreen.routeName,
        //   builder: (context, state) {
        //     return MenuScreen();
        //   },
        // ),
        GoRoute(
          path: 'home-screen',
          name: HomeScreen.routeName,
          builder: (context, state) {
            return const HomeScreen();
          },
        ),
      ],
    ),
  ],
);
