import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ramadhan_ogp/src/core/utils.dart';
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
                  constraints: BoxConstraints(minWidth: 50.0, minHeight: 0.0), // min sizes for Material buttons
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
                      //   radius: 15.5,
                      //   child: datas[index]['avatar'].length > 0 ? getImageBase64(datas[index]['avatar']) : const Icon(Icons.person),
                      // ),
                      title: IntrinsicHeight(
                        child: Row(
                          // direction: Axis.horizontal,
                          // crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            getImageBase64(datas[index]['avatar']),
                            VerticalDivider(),
                            Wrap(
                              direction: Axis.vertical,
                              crossAxisAlignment: WrapCrossAlignment.start,
                              children: [
                                Text(datas[index]['name'], style: TextStyle(fontSize: 14.0)),
                                Text('Usia: ${datas[index]['age']} tahun', style: TextStyle(fontSize: 10.0)),
                                Text('Alamat: Block ${datas[index]['remarks'] ?? '-'}', style: TextStyle(fontSize: 10.0)),
                                Text('Mendaftar Pada: ${simpleDateTimeFormat(datas[index]['created_at'] ?? DateTime.now().toLocal().toString())}',
                                    style: TextStyle(fontSize: 10.0)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          },
          error: (e, s) => Text('Error $s'),
          loading: () => Center(child: CircularProgressIndicator())),
    );
  }

  Widget getImageBase64(data) {
    var avatar = Container(
      width: 50.0,
      height: 50.0,
      constraints: BoxConstraints(minWidth: 50.0, minHeight: 0.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          image: DecorationImage(
            image: data.length > 0 ? MemoryImage(base64Decode(data)) : Image.asset('assets/images/no_image.jpg').image,
            fit: BoxFit.cover,
          )),
    );
    return avatar;
  }
}
