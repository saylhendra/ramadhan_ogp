import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ramadhan_ogp/src/features/peserta/presentation/widgets/card_peserta_widget.dart';

import '../../../core/app_theme.dart';
import '../../home/presentation/home_screen.dart';
import 'peserta_based_controller.dart';

class PesertaBasedUsiaScreen extends HookConsumerWidget {
  const PesertaBasedUsiaScreen({super.key});
  static const routeName = 'peserta-based-usia';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterBy = useState('Semua');
    var listTmp = useState([]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peserta Berdasarkan Usia'),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppTheme.myGradient),
        ),
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () => context.goNamed(HomeScreen.routeName),
        ),
      ),
      body: ref.watch(pesertaBasedControllerProvider).when(
            data: (datas) {
              List<String> listGroupAges = calculateListOfAges(datas: datas);
              return Column(
                children: [
                  Expanded(
                    flex: 0,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: listGroupAges
                              .map((e) => Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 8.0),
                                    child: InkWell(
                                        onTap: () {
                                          listTmp.value = [...datas];
                                          filterBy.value = e;
                                          listTmp.value = datas.where((element) => element['age'].toString() == e).toList();
                                          // doOnfilter(filterBy: e, datas: datas);
                                        },
                                        child: Chip(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
                                          label: Text('$e ${e == 'Semua' ? '' : 'Thn'}',
                                              style: TextStyle(color: AppTheme.white, fontFamily: 'NotoKufiArabic')),
                                          backgroundColor: filterBy.value == e ? AppTheme.oldBrick : AppTheme.oldBrick.withAlpha(100),
                                        )),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Chip(
                          label: Text(
                        'Total: ${filterBy.value == 'Semua' ? datas.length.toString() : listTmp.value.length.toString()} peserta',
                        style: TextStyle(color: AppTheme.dark, fontFamily: 'NotoKufiArabic', fontSize: 16.0),
                      )),
                    ),
                  ),
                  Divider(),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                      ),
                      itemCount: filterBy.value == 'Semua' ? datas.length : listTmp.value.length,
                      itemBuilder: (context, index) {
                        final peserta = filterBy.value == 'Semua' ? datas[index] : listTmp.value[index];
                        try {
                          return Stack(
                            alignment: Alignment.topLeft,
                            children: [
                              CardPesertaWidget(
                                avatar: peserta['avatar'],
                                name: peserta['name'],
                                age: peserta['age'],
                                remarks: peserta['remarks'],
                                gender: peserta['gender'],
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        color: AppTheme.dark,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } catch (e) {
                          return SizedBox(
                            child: Text('${peserta['name']} ${e.toString()}'),
                          );
                        }
                      },
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(child: Text('Error: $error')),
          ),
    );
  }

  List<String> calculateListOfAges({required List datas}) {
    List<String> listGroupAges = [];
    listGroupAges.add('Semua');
    for (var data in datas) {
      listGroupAges.add(data['age'].toString());
    }
    var distinctIds = listGroupAges.toSet().toList();
    return distinctIds;
  }

  void doOnfilter({required String filterBy, required List datas}) {}
}
