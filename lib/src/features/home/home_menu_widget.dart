import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
              style: TextStyle(fontFamily: 'NotoKufiArabic', fontSize: 24),
            ),
            decoration: BoxDecoration(color: Colors.green),
          ),
          ListTile(
            title: const Text('Pesantren Kilat', style: TextStyle(fontFamily: 'NotoKufiArabic')),
            onTap: () {
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
