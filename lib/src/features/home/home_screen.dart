import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String routeName = 'home-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("﷽",
            style: TextStyle(
              fontFamily: 'NotoKufiArabic',
            )),
      ),
      body: const Center(
        child: Text(
          '﷽\nWelcome to Home Screen',
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
