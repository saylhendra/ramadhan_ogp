import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ramadhan_ogp/src/features/peserta/presentation/widgets/card_peserta_widget.dart';

import '../../../core/app_theme.dart';
import '../../home/presentation/widgets/home_menu_widget.dart';
import 'peserta_based_controller.dart';

class GroupingScreen extends HookConsumerWidget {
  const GroupingScreen({super.key});
  static const routeName = 'grouping-screen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupingListState = ref.watch(groupingControllerProvider);
    final filterBy = useState('Semua');
    final listTmp = useState([]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grouping'),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppTheme.myGradient),
        ),
        // leading: IconButton(icon: Icon(Icons.home), onPressed: () => context.goNamed(HomeScreen.routeName)),
      ),
      drawer: HomeMenuWidget(),
      body: groupingListState.when(
          data: (groupings) {
            return Column(
              children: [
                Expanded(
                  flex: 0,
                  child: ref.watch(sanlatGroupsControllerProvider).when(
                        data: (datas) {
                          var listFilter = [
                            {
                              'id': 0,
                              'title': 'Semua',
                              'gender': 'IKHWAN/ AKHWAT',
                            },
                            ...datas.map((e) => e).toList()
                          ];
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: listFilter
                                    .map((e) => InkWell(
                                          onTap: () {
                                            listTmp.value = [...groupings];
                                            filterBy.value = e['title'];
                                            listTmp.value = groupings.where((element) => element['title'].toString() == e['title']).toList();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                                            child: Chip(
                                              label: Text(
                                                '${e['title']}',
                                                style: TextStyle(
                                                  color: AppTheme.white,
                                                  fontFamily: 'NotoKufiArabic',
                                                ),
                                              ),
                                              backgroundColor: filterBy.value == e['title'] ? AppTheme.oldBrick : AppTheme.oldBrick.withAlpha(100),
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator(), heightFactor: 2),
                        error: (error, stack) => Center(
                          child: Text('Error: $error'),
                        ),
                      ),
                ),
                Expanded(
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Column(
                        children: [
                          Expanded(
                            child: GridView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10.0,
                                ),
                                // itemCount: groupings.length,
                                itemCount: filterBy.value == 'Semua' ? groupings.length : listTmp.value.length,
                                itemBuilder: (context, index) {
                                  // final data = groupings[index];
                                  final data = filterBy.value == 'Semua' ? groupings[index] : listTmp.value[index];
                                  return Stack(
                                    alignment: Alignment.bottomLeft,
                                    children: [
                                      CardPesertaWidget(
                                        avatar: data['avatar'],
                                        name: data['name'],
                                        age: data['age'],
                                        gender: data['gender'],
                                        remarks: data['remarks'],
                                      ),
                                      Visibility(
                                        visible: false,
                                        child: Positioned(
                                          right: 0,
                                          top: 0,
                                          child: IconButton(
                                            icon: Icon(Icons.delete, color: Colors.red),
                                            onPressed: () async {
                                              await ref.read(groupingControllerProvider.notifier).removed(data);
                                              ref.invalidate(groupingControllerProvider);
                                            },
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 25,
                                        margin: const EdgeInsets.only(right: 60.0, bottom: 52.0),
                                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.5),
                                        decoration: BoxDecoration(
                                          color: AppTheme.white.withOpacity(0.9),
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10.0),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            data['title'],
                                            style: const TextStyle(
                                              color: AppTheme.cherryWood,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              height: 1.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                          ),
                        ],
                      ),
                      Chip(
                        backgroundColor: AppTheme.oldBrick,
                        label: Text(
                          'Total: ${filterBy.value == 'Semua' ? groupings.length : listTmp.value.length}',
                          style: TextStyle(
                            color: AppTheme.yellowNapes,
                            fontFamily: 'NotoKufiArabic',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error'))),
    );
  }
}
