import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ramadhan_ogp/src/features/absensi/presentation/absensi_screen.dart';
import 'package:ramadhan_ogp/src/features/groups/presentation/grouping_screen.dart';
import 'package:ramadhan_ogp/src/features/groups/presentation/peserta_based_usia_screen.dart';
import 'package:ramadhan_ogp/src/features/home/presentation/home_screen.dart';
import 'package:ramadhan_ogp/src/features/kuis/presentation/kelompok_kuis_screen.dart';
import 'package:ramadhan_ogp/src/features/sanlat/sanlat_registration_screen.dart';

import '../../../../core/app_theme.dart';
import '../../../peserta/presentation/peserta_dan_ortu_screen.dart';

class HomeMenuWidget extends HookConsumerWidget {
  const HomeMenuWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: ListView(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppTheme.blackPerl, AppTheme.plantation],
                  ),
                ),
                child: const Text(
                  'Perumahan Orchid Green Park',
                  style: TextStyle(fontFamily: 'NotoKufiArabic', fontSize: 22, color: AppTheme.pinkDown, height: 1.0),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Image(image: AssetImage('assets/images/ramadhan_kareem.png'), width: 145.0),
                      Positioned(right: -10, top: 10, child: Image(image: AssetImage('assets/images/moon.png'), width: 60.0)),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10.0,
                      left: 10.0,
                      right: 10.0,
                      bottom: 15.0,
                    ),
                    child: Image.asset('assets/images/maar_logo.png', height: 80, width: 80),
                  ),
                ],
              ),
            ],
          ),
          ListTile(
            title: const Text('Home', style: TextStyle(fontFamily: 'NotoKufiArabic')),
            onTap: () {
              context.pushReplacementNamed(HomeScreen.routeName);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Daftar Pesantren Kilat', style: TextStyle(fontFamily: 'NotoKufiArabic')),
            onTap: () {
              context.pushNamed(SanlatRegistrationScreen.routeName);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Peserta Kuis', style: TextStyle(fontFamily: 'NotoKufiArabic')),
            onTap: () {
              context.goNamed(KelompokKuisScreen.routeName);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Peserta Berdasarkan Usia', style: TextStyle(fontFamily: 'NotoKufiArabic')),
            onTap: () {
              context.pushNamed(PesertaBasedUsiaScreen.routeName);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Grouping', style: TextStyle(fontFamily: 'NotoKufiArabic')),
            onTap: () {
              context.goNamed(GroupingScreen.routeName);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Absensi Cluster A'),
            onTap: () {
              context.goNamed(AbsensiScreen.routeName, extra: 'a');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Absensi Cluster B'),
            onTap: () {
              context.goNamed(AbsensiScreen.routeName, extra: 'b');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Absensi Cluster C'),
            onTap: () {
              context.goNamed(AbsensiScreen.routeName, extra: 'c');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Peserta Orang Tua', style: TextStyle(fontFamily: 'NotoKufiArabic')),
            onTap: () {
              context.pushNamed(PesertaDanOrtuScreen.routeName);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Kontak Panitia', style: TextStyle(fontFamily: 'NotoKufiArabic')),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
