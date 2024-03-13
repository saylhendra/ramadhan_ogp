import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ramadhan_ogp/src/features/home/home_menu_widget.dart';
import 'package:ramadhan_ogp/src/features/sanlat/sanlat_registration_controller.dart';

import '../../core/app_theme.dart';
import '../sanlat/sanlat_registration_screen.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  static const String routeName = 'home-screen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var myGradient = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppTheme.pinkDown, AppTheme.yellowNapes, AppTheme.oldBrick],
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
      body: ref.watch(pesertaSanlatControllerProvider).when(
          data: (datas) {
            return ListView.builder(
                itemCount: datas.length,
                itemBuilder: (item, index) {
                  return Card(
                    child: ListTile(
                      // leading: CircleAvatar(
                      //   radius: 15.5.sp,
                      //   child: datas[index]['avatar'].length > 0 ? getImageBase64(datas[index]['avatar']) : const Icon(Icons.person),
                      // ),
                      title: IntrinsicHeight(
                        child: Row(
                          // direction: Axis.horizontal,
                          // crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            datas[index]['avatar'].length > 0 ? getImageBase64(datas[index]['avatar']) : const Icon(Icons.person),
                            VerticalDivider(),
                            Wrap(
                              direction: Axis.vertical,
                              crossAxisAlignment: WrapCrossAlignment.start,
                              children: [
                                Text(datas[index]['name'], style: TextStyle(fontSize: 16.0.sp)),
                                Text('Usia: ${datas[index]['age']} tahun', style: TextStyle(fontSize: 11.0.sp)),
                                Text('Alamat: Block ${datas[index]['remarks'] ?? '-'}', style: TextStyle(fontSize: 11.0.sp)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // subtitle: Wrap(
                      //   direction: Axis.vertical,
                      //   crossAxisAlignment: WrapCrossAlignment.start,
                      //   children: [
                      //     Text('Usia: ${datas[index]['age']} tahun'),
                      //     Text('Alamat: Block ${datas[index]['remarks'] ?? '-'}'),
                      //   ],
                      // ),
                    ),
                  );
                });
          },
          error: (e, s) => Text('Error $s'),
          loading: () => Center(child: CircularProgressIndicator())),
    );
  }

  Widget getImageBase64(data) {
    if (data != null) {
      var avatar = Container(
        width: 50.0.sp,
        height: 50.0.sp,
        constraints: BoxConstraints(minWidth: 50.0.sp, minHeight: 0.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0.sp),
            image: DecorationImage(
              image: MemoryImage(base64Decode(data)),
              fit: BoxFit.cover,
            )),
      );
      return avatar;
    } else {
      return Icon(Icons.person, size: 150.0.sp, color: Colors.grey);
    }
  }
}
