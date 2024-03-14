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
    // var myGradient = const LinearGradient(
    //   begin: Alignment.topLeft,
    //   end: Alignment.bottomRight,
    //   colors: [AppTheme.pinkDown, AppTheme.yellowNapes, AppTheme.oldBrick],
    // );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ramadhan OGP 1445 H"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppTheme.myGradient,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: AppTheme.oldBrick,
                foregroundColor: AppTheme.pinkDown,
                shadowColor: Colors.black,
                elevation: 4.0,
                animationDuration: Duration(milliseconds: 300),
              ),
              onPressed: () {
                context.goNamed(SanlatRegistrationScreen.routeName);
              },
              child: Container(
                height: 32.0,
                constraints: BoxConstraints(minWidth: 50.0, minHeight: 0.0), // min sizes for Material buttons
                alignment: Alignment.center,
                child: const Text(
                  'Daftar Sanlat',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: HomeMenuWidget(),
      body: ref.watch(pesertaSanlatControllerProvider).when(
          data: (datas) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Daftar Peserta Sanlat', style: TextStyle(fontSize: 18.0)),
                    )),
                Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: datas.length,
                      itemBuilder: (item, index) {
                        return Card(
                          elevation: 4.0,
                          child: ListTile(
                            title: IntrinsicHeight(
                              child: Row(
                                children: [
                                  getImageBase64(datas[index]['avatar']),
                                  VerticalDivider(),
                                  Wrap(
                                    direction: Axis.vertical,
                                    crossAxisAlignment: WrapCrossAlignment.start,
                                    children: [
                                      Text('${datas[index]['name']} | Block ${datas[index]['remarks']}', style: TextStyle(fontSize: 16.0)),
                                      Text('Usia: ${datas[index]['age']} tahun', style: TextStyle(fontSize: 12.0)),
                                      Text('Alamat: Block ${datas[index]['remarks'] ?? '-'}', style: TextStyle(fontSize: 12.0)),
                                      Text(
                                          'Mendaftar Pada: ${simpleDateTimeFormat(datas[index]['created_at'] ?? DateTime.now().toLocal().toString())}',
                                          style: TextStyle(fontSize: 12.0)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            );
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
