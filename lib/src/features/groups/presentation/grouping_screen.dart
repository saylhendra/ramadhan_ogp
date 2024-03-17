import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ramadhan_ogp/src/features/peserta/presentation/widgets/card_peserta_widget.dart';

import '../../../core/app_theme.dart';
import 'peserta_based_controller.dart';

class GroupingScreen extends HookConsumerWidget {
  const GroupingScreen({super.key});
  static const routeName = 'grouping-screen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grouping'),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppTheme.myGradient),
        ),
        // leading: IconButton(icon: Icon(Icons.home), onPressed: () => context.goNamed(HomeScreen.routeName)),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 0,
            child: ref.watch(sanlatGroupsControllerProvider).when(
                  data: (datas) {
                    return Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: datas
                          .map((e) => Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Chip(label: Text('${e['title']} ${e['gender']}')),
                              ))
                          .toList(),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator(), heightFactor: 2),
                  error: (error, stack) => Center(
                    child: Text('Error: $error'),
                  ),
                ),
          ),
          Expanded(
            child: ref.watch(groupingControllerProvider).when(
                  data: (datas) {
                    return GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                        ),
                        itemCount: datas.length,
                        itemBuilder: (context, index) {
                          final data = datas[index];
                          return Stack(
                            children: [
                              CardPesertaWidget(
                                avatar: data['avatar'],
                                name: data['name'],
                                age: data['age'],
                                gender: data['gender'],
                                remarks: data['remarks'],
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  // onPressed: () async {
                                  //   await ref.read(groupingControllerProvider.notifier).removed(data);
                                  //   ref.invalidate(groupingControllerProvider);
                                  // },
                                  onPressed: null,
                                ),
                              ),
                            ],
                          );
                        });
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text('Error: $error')),
                ),
          ),
        ],
      ),
    );
  }
}
