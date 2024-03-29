import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ramadhan_ogp/src/features/absensi/presentation/absensi_screen.dart';
import 'package:ramadhan_ogp/src/features/groups/presentation/grouping_screen.dart';
import 'package:ramadhan_ogp/src/features/groups/presentation/peserta_based_usia_screen.dart';
import 'package:ramadhan_ogp/src/features/kuis/presentation/kelompok_kuis_screen.dart';
import 'package:ramadhan_ogp/src/features/peserta/presentation/peserta_dan_ortu_screen.dart';
import 'package:ramadhan_ogp/src/features/sanlat/sanlat_quiz_registration_screen.dart';

import '../features/home/presentation/home_screen.dart';
import '../features/sanlat/peserta_sanlat_detail_screen.dart';
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
      path: '/home-screen',
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
        routes: [
          GoRoute(
            path: 'peserta-sanlat-detail-screen',
            name: PesertaSanlatDetailScreen.routeName,
            pageBuilder: (context, state) {
              final peserta = state.extra as Map<String, dynamic>;
              return NoTransitionPage(
                child: PesertaSanlatDetailScreen(
                  peserta: peserta,
                ),
              );
            },
          ),
        ]),
    GoRoute(
      path: '/sanlat-quiz-registration-screen',
      name: SanlatQuizRegistrationScreen.routeName,
      pageBuilder: (context, state) {
        final peserta = state.extra as Map<String, dynamic>;
        return NoTransitionPage(
          child: SanlatQuizRegistrationScreen(
            peserta: peserta,
          ),
        );
      },
    ),
    GoRoute(
      path: '/kelompok-kuis-screen',
      name: KelompokKuisScreen.routeName,
      pageBuilder: (context, state) {
        // final peserta = state.extra as Map<String, dynamic>;
        return NoTransitionPage(
          child: KelompokKuisScreen(),
        );
      },
    ),
    GoRoute(
      path: '/peserta-based-usia',
      name: PesertaBasedUsiaScreen.routeName,
      pageBuilder: (context, state) {
        // final peserta = state.extra as Map<String, dynamic>;
        return NoTransitionPage(
          child: PesertaBasedUsiaScreen(),
        );
      },
    ),
    GoRoute(
      path: '/grouping-screen',
      name: GroupingScreen.routeName,
      pageBuilder: (context, state) {
        // final peserta = state.extra as Map<String, dynamic>;
        return NoTransitionPage(
          child: GroupingScreen(),
        );
      },
    ),
    GoRoute(
      path: '/absensi-screen',
      name: AbsensiScreen.routeName,
      pageBuilder: (context, state) {
        final clusterType = state.extra as String?;
        return NoTransitionPage(
          child: AbsensiScreen(
            clusterType: clusterType ?? 'a',
          ),
        );
      },
    ),
    GoRoute(
      path: '/peserta-dan-ortu-screen',
      name: PesertaDanOrtuScreen.routeName,
      pageBuilder: (context, state) {
        // final clusterType = state.extra as String?;
        return NoTransitionPage(
          child: PesertaDanOrtuScreen(),
        );
      },
    ),
  ],
);
