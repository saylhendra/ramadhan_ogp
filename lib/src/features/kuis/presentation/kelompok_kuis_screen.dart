import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ramadhan_ogp/src/features/home/presentation/widgets/home_menu_widget.dart';

import '../../../core/app_theme.dart';
import '../../peserta/presentation/widgets/card_peserta_widget.dart';
import '../../sanlat/peserta_sanlat_detail_screen.dart';
import 'kelompok_kuis_controller.dart';

class KelompokKuisScreen extends HookConsumerWidget {
  const KelompokKuisScreen({super.key});
  static const routeName = 'kelompok-kuis-screen';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peserta Kuis'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppTheme.myGradient,
          ),
        ),
        // leading: IconButton(
        //   icon: Icon(Icons.home),
        //   onPressed: () => context.goNamed(HomeScreen.routeName),
        // ),
      ),
      drawer: HomeMenuWidget(),
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          physics: const BouncingScrollPhysics(),
          dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse, PointerDeviceKind.trackpad},
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(kelompokKuisControllerProvider);
          },
          child: ref.watch(kelompokKuisControllerProvider).when(
                data: (myList) {
                  var datas = [...myList];
                  datas.sort((b, a) => a['gender'].compareTo(b['gender']));
                  return Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Column(
                        children: [
                          Expanded(
                            child: GridView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 5.0,
                              ),
                              itemBuilder: (context, index) {
                                final data = datas[index];
                                return Stack(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        context.pushNamed(PesertaSanlatDetailScreen.routeName, extra: data);
                                      },
                                      child: CardPesertaWidget(
                                        avatar: data['avatar'],
                                        name: data['name'],
                                        age: data['age'],
                                        remarks: data['remarks'],
                                        gender: data['gender'],
                                      ),
                                    ),
                                    //Numbering
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CircleAvatar(
                                          backgroundColor: AppTheme.plantation,
                                          child: Text('${index + 1}', style: TextStyle(color: AppTheme.yellowNapes)),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                              itemCount: datas.length,
                            ),
                          ),
                        ],
                      ),
                      Wrap(
                        direction: Axis.vertical,
                        crossAxisAlignment: WrapCrossAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01, left: 20.0, right: 10.0),
                            child: FloatingActionButton(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
                              backgroundColor: AppTheme.oldBrick,
                              foregroundColor: AppTheme.yellowNapes,
                              onPressed: null,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Total', style: TextStyle(fontSize: 11.0, height: 1.0), textAlign: TextAlign.center),
                                  Text('${datas.length}', style: TextStyle(fontSize: 20.0, height: 1.0), textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Chip(
                            backgroundColor: AppTheme.oldBrick,
                            label: Text(
                              'Ikhwan: ${datas.where((element) => element['gender'] == 'IKHWAN').length}',
                              style: TextStyle(color: AppTheme.yellowNapes, fontSize: 11.0),
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Chip(
                            backgroundColor: AppTheme.oldBrick,
                            label: Text(
                              'Akhwat: ${datas.where((element) => element['gender'] == 'AKHWAT').length}',
                              style: TextStyle(color: AppTheme.yellowNapes, fontSize: 11.0),
                            ),
                          )
                        ],
                      )
                    ],
                  );
                },
                error: (e, s) => Center(
                  child: Text('Error: $e'),
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
        ),
      ),
    );
  }
}
