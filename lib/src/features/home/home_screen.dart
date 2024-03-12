import 'package:flutter/material.dart';
import 'package:ramadhan_ogp/src/features/home/home_menu_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String routeName = 'home-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orchid Green Park"),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0),
            child: Row(
              children: [
                FilledButton(onPressed: () {}, child: Text('Daftar Sanlat')),
              ],
            ),
          ),
        ],
      ),
      drawer: HomeMenuWidget(),
      body: const Center(
        child: Text(
          '﷽\nSelamat Datang di Orchid Green Park Ramadhan Kareem\n\n',
          style: TextStyle(
            fontFamily: 'NotoKufiArabic',
            fontSize: 24,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
