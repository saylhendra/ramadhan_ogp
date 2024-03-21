import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/app_theme.dart';
import '../groups/presentation/grouping_screen.dart';
import '../groups/presentation/peserta_based_controller.dart';

final formKey = GlobalKey<FormState>();

class PesertaSanlatDetailScreen extends HookConsumerWidget {
  PesertaSanlatDetailScreen({super.key, required this.peserta});
  static const routeName = 'peserta-sanlat-detail-screen';
  final Map<String, dynamic> peserta;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listSanlatGroupsState = ref.watch(sanlatGroupsControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('${peserta['name']}'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppTheme.myGradient,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: [
          Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  onPressed: () {
                    showComboboxSanlatGroups(idPeserta: peserta['id'], dcontext: context, groups: listSanlatGroupsState, ref: ref);
                  },
                  icon: Icon(Icons.add_box, color: AppTheme.oldBrick, size: 30.0))),
          Card(
            elevation: 4.0,
            child: ListTile(
              title: Text('Nama: ${peserta['name']} - ${peserta['id']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Jns. Kelamin: ${peserta['gender']}'),
                  Text('Alamat: ${peserta['remarks']}'),
                  Text('Usia: ${peserta['age']} tahun'),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width * 1,
                    margin: const EdgeInsets.only(top: 10.0),
                    decoration: BoxDecoration(
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.grey.withOpacity(0.5),
                      //     spreadRadius: 2,
                      //     blurRadius: 5,
                      //     offset: const Offset(0, 2),
                      //   ),
                      // ],
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        image: NetworkImage(peserta['avatar'], scale: 1.0),
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showComboboxSanlatGroups({
    required BuildContext dcontext,
    required AsyncValue<List> groups,
    required WidgetRef ref,
    required int idPeserta,
  }) async {
    final pinController = TextEditingController();
    if (await ref.read(groupingControllerProvider.notifier).checkIfPesertaAlreadyGrouped(idPeserta: idPeserta)) {
      showDialog(context: dcontext, builder: (context) => AlertDialog(content: Text('Peserta sudah tergabung dalam kelompok.')));
      return;
    } else {
      groups.when(
        data: (datas) {
          List<dynamic> groups = [...datas];
          //sorting by id desc
          groups.sort((a, b) => b['id'].compareTo(a['id']));
          return showModalBottomSheet(
            scrollControlDisabledMaxHeightRatio: 0.9,
            context: dcontext,
            builder: (double) {
              var selectedGroup = 'Pilih Kelompok';
              return Container(
                margin: const EdgeInsets.all(15.0),
                height: MediaQuery.of(dcontext).size.height * 0.65,
                child: Column(
                  children: [
                    DropdownSearch<String>(
                      items: groups.map((e) => '${e['id']}~${e['title']} ${e['gender']}').toList(),
                      onChanged: (item) {
                        selectedGroup = item!;
                      },
                      selectedItem: selectedGroup,
                    ),
                    //TextFormField
                    const SizedBox(height: 10.0),
                    FilledButton(
                        onPressed: () async {
                          doConfirmPin(
                            dcontext: dcontext,
                            ref: ref,
                            idPeserta: idPeserta,
                            selectedGroup: selectedGroup,
                            pinController: pinController,
                          );
                          // if (formKey.currentState!.validate()) {
                          //   await ref
                          //       .read(sanlatGroupsControllerProvider.notifier)
                          //       .addGroupToSanlatGroup(idPeserta: idPeserta, idGroup: selectedGroup.split('~')[0]);
                          //   Navigator.pop(dcontext);
                          //   dcontext.pushNamed(GroupingScreen.routeName);
                          // }
                        },
                        child: Text('Tambahkan ke Kelompok')),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      );
    }
  }

  void doConfirmPin(
      {required BuildContext dcontext,
      required WidgetRef ref,
      required int idPeserta,
      required String selectedGroup,
      required TextEditingController pinController}) {
    showDialog(
      context: dcontext,
      builder: (context) => AlertDialog(
        content: Wrap(
          children: [
            Center(
              child: Form(
                key: formKey,
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'PIN Admin Tidak Boleh Kosong';
                    } else if (value.isNotEmpty && value != '2527') {
                      return 'PIN Admin Salah';
                    }
                    return null;
                  },
                  controller: pinController,
                  maxLength: 4,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'PIN Admin',
                    hintText: 'PIN Khusus Admin',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            FilledButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  await ref
                      .read(sanlatGroupsControllerProvider.notifier)
                      .addGroupToSanlatGroup(idPeserta: idPeserta, idGroup: selectedGroup.split('~')[0]);
                  context.pop();
                  context.pop();
                  context.pushNamed(GroupingScreen.routeName);
                }
              },
              child: Text('Tambahkan ke Kelompok'),
            ),
          ],
        ),
      ),
    );
  }
}
