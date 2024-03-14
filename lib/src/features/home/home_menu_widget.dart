import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ramadhan_ogp/src/features/sanlat/sanlat_registration_screen.dart';

import '../../core/app_theme.dart';

class HomeMenuWidget extends HookConsumerWidget {
  const HomeMenuWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: const Text(
              'Ramadhan Perumahan Orchid Green Park\n\n',
              style: TextStyle(
                fontFamily: 'NotoKufiArabic',
                fontSize: 22,
                color: AppTheme.pinkDown,
              ),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppTheme.blackPerl, AppTheme.plantation],
              ),
            ),
          ),
          ListTile(
            title: const Text('Pesantren Kilat', style: TextStyle(fontFamily: 'NotoKufiArabic')),
            onTap: () {
              context.goNamed(SanlatRegistrationScreen.routeName);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Jadwal Takjil', style: TextStyle(fontFamily: 'NotoKufiArabic')),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text(
              'Kontak Panitia',
              style: TextStyle(
                fontFamily: 'NotoKufiArabic',
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
