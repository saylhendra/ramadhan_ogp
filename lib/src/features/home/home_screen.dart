import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ramadhan_ogp/src/features/home/home_menu_widget.dart';

import '../../core/app_theme.dart';
import '../sanlat/sanlat_registration_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String routeName = 'home-screen';

  @override
  Widget build(BuildContext context) {
    var myGradient = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppTheme.pinkDown,
        AppTheme.yellowNapes,
        AppTheme.oldBrick,
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orchid Green Park"),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0),
            child: TextButton(
              onPressed: () {
                context.pushNamed(SanlatRegistrationScreen.routeName);
              },
              child: Ink(
                decoration: BoxDecoration(
                  gradient: myGradient,
                  borderRadius: BorderRadius.all(Radius.circular(80.0)),
                ),
                child: Container(
                  height: 40.0,
                  constraints: BoxConstraints(minWidth: 50.0.sp, minHeight: 0.0), // min sizes for Material buttons
                  alignment: Alignment.center,
                  child: const Text(
                    'Daftar Sanlat',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
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
