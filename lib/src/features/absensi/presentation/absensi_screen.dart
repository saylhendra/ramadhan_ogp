import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ramadhan_ogp/src/core/utils.dart';
import 'package:ramadhan_ogp/src/features/home/presentation/widgets/home_menu_widget.dart';

import '../../../core/app_theme.dart';
import 'absensi_controller.dart';

class AbsensiScreen extends HookConsumerWidget {
  const AbsensiScreen({
    super.key,
    required this.clusterType,
  });
  static const routeName = 'absensi-screen';

  final String clusterType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final abasensiState = ref.watch(absensiControllerProvider(clusterType: clusterType));
    return Scaffold(
      appBar: AppBar(
          title: Text('Absensi Cluster ${clusterType.toUpperCase()}'),
          flexibleSpace: Container(decoration: BoxDecoration(gradient: AppTheme.myGradient))),
      drawer: HomeMenuWidget(),
      body: abasensiState.when(
        data: (datas) {
          return Stack(
            alignment: Alignment.topRight,
            children: [
              Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: datas.length,
                      itemBuilder: (context, index) {
                        final data = datas[index];
                        return Card(
                          elevation: 4.0,
                          child: ListTile(
                            title: Wrap(
                              direction: Axis.horizontal,
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage: NetworkImage('${data['avatar']}'),
                                ),
                                VerticalDivider(),
                                Wrap(
                                  direction: Axis.vertical,
                                  children: [
                                    SizedBox(
                                      width: 300,
                                      child: Text(
                                        'Nama: ${data['btrim']}',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text('Usia: ${data['age']}'),
                                    Text('Alamat: ${data['remarks']}'),
                                    Text('Kelompok: ${data['title']}'),
                                    if (data['is_hadir'] != null && data['is_hadir'])
                                      Text('Tgl Absen: ${simpleDateTimeFormat(data['updated_at'])} ✅')
                                    else
                                      Text('Tgl Daftar: ${simpleDateTimeFormat(data['created_at'])}'),

                                    //SwitchListTile
                                  ],
                                ),
                                SwitchListTile(
                                  controlAffinity: ListTileControlAffinity.leading,
                                  contentPadding: EdgeInsets.all(0),
                                  value: data['is_hadir'] ?? false,
                                  onChanged: (value) async {
                                    await ref
                                        .read(absensiControllerProvider(clusterType: clusterType).notifier)
                                        .doUpdateIsHadir(idPeserta: data['sanlat_id'], isHadir: value);
                                    ref.invalidate(absensiControllerProvider);
                                  },
                                  title: Text('Hadir ?'),
                                  dense: false,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Chip(label: Text('👶 Total: ${datas.length}')),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Chip(label: Text('✅ Hadir: ${datas.where((element) => element['is_hadir'] == true).length}')),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child:
                        Chip(label: Text('❓ Belum: ${datas.where((element) => element['is_hadir'] == false || element['is_hadir'] == null).length}')),
                  ),
                ],
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
