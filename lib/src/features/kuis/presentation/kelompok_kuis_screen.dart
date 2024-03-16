import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ramadhan_ogp/src/features/home/presentation/home_screen.dart';

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
        title: const Text('Peserta Kuis Ramadhan'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppTheme.myGradient,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () => context.goNamed(HomeScreen.routeName),
        ),
      ),
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
                data: (datas) {
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
                                crossAxisSpacing: 10.0,
                              ),
                              itemBuilder: (context, index) {
                                final data = datas[index];
                                return Stack(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        context.pushNamed(PesertaSanlatDetailScreen.routeName, extra: data);
                                      },
                                      // child: Card(
                                      //   child: Stack(
                                      //     alignment: Alignment.bottomCenter,
                                      //     children: [
                                      //       Container(
                                      //         decoration: BoxDecoration(
                                      //           borderRadius: BorderRadius.circular(10.0),
                                      //           gradient: AppTheme.myGradient,
                                      //           image: DecorationImage(
                                      //             image: NetworkImage(data['avatar']),
                                      //             fit: BoxFit.cover,
                                      //           ),
                                      //         ),
                                      //       ),
                                      //       Container(
                                      //         width: double.infinity,
                                      //         decoration: BoxDecoration(
                                      //           borderRadius: BorderRadius.only(
                                      //             bottomLeft: Radius.circular(10.0),
                                      //             bottomRight: Radius.circular(10.0),
                                      //           ),
                                      //           color: AppTheme.yellowNapes.withAlpha(200),
                                      //         ),
                                      //         child: ListTile(
                                      //           visualDensity: VisualDensity.compact,
                                      //           title: Text('${data['name']} | ${data['age']}thn | ${data['remarks']}',
                                      //               style: TextStyle(height: 1.0, fontSize: 12.0, color: AppTheme.dark, fontWeight: FontWeight.bold)),
                                      //         ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
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
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
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
                      ),
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
