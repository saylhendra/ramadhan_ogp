import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ramadhan_ogp/src/core/utils.dart';
import 'package:ramadhan_ogp/src/features/home/home_menu_widget.dart';
import 'package:ramadhan_ogp/src/features/sanlat/sanlat_registration_controller.dart';

import '../../core/app_theme.dart';
import '../sanlat/sanlat_registration_screen.dart';

//global key for form
final formkey = GlobalKey<FormState>(debugLabel: 'search');

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});
  static const String routeName = 'home-screen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pesertaSanlatState = ref.watch(pesertaSanlatControllerProvider);
    // var myGradient = const LinearGradient(
    //   begin: Alignment.topLeft,
    //   end: Alignment.bottomRight,
    //   colors: [AppTheme.pinkDown, AppTheme.yellowNapes, AppTheme.oldBrick],
    // );
    final searchController = useTextEditingController();
    final keyWords = useState('');
    var listTmp = useState([]);

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
                if (kIsWeb) {
                  context.pushNamed(SanlatRegistrationScreen.routeName);
                } else {
                  context.pushNamed(SanlatRegistrationScreen.routeName);
                }
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
      body: pesertaSanlatState.when(
          data: (datas) {
            datas.sort((b, a) => a['id'].compareTo(b['id']));
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Daftar Peserta Sanlat ${listTmp.value.length}', style: TextStyle(fontSize: 18.0)),
                          //refresh button
                          FilledButton.icon(
                            label: Text('Refresh'),
                            icon: Icon(Icons.refresh),
                            onPressed: () {
                              ref.invalidate(pesertaSanlatControllerProvider);
                            },
                          ),
                        ],
                      ),
                    )),
                //Search box peserta sanlat
                Expanded(
                  flex: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                    child: Form(
                      key: formkey,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.length < 3 && keyWords.value.isNotEmpty) {
                            return 'Kata kunci minimal 3 karakter';
                          }
                          return null;
                        },
                        controller: searchController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Cari nama, alamat, usia...',
                          suffixIcon: IconButton(
                            onPressed: () {
                              searchController.clear();
                              keyWords.value = '';
                              listTmp.value = [...datas];
                            },
                            icon: keyWords.value.length > 0 ? Icon(Icons.clear) : Icon(Icons.search),
                          ),
                        ),
                        onChanged: (value) {
                          keyWords.value = value;
                          if (keyWords.value.isNotEmpty) {
                            if (keyWords.value.length > 3) {
                              listTmp.value = [...datas];
                              listTmp.value = listTmp.value.where((peserta) {
                                return peserta['name'].toLowerCase().trim() == (value.toLowerCase()) ||
                                    peserta['remarks'].toLowerCase().trim() == (value.toLowerCase()) ||
                                    peserta['age'].toString().toLowerCase().trim() == (value.toLowerCase());
                              }).toList();
                            } else {
                              formkey.currentState!.validate();
                            }
                          } else {
                            formkey.currentState!.validate();
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                      itemCount: keyWords.value.length > 2 ? listTmp.value.length : datas.length,
                      itemBuilder: (item, index) {
                        var peserta = keyWords.value.length > 2 ? listTmp.value[index] : datas[index];
                        return Card(
                          elevation: 4.0,
                          child: ListTile(
                            title: IntrinsicHeight(
                              child: Row(
                                children: [
                                  getImageBase64(peserta['avatar']),
                                  VerticalDivider(),
                                  Wrap(
                                    direction: Axis.vertical,
                                    crossAxisAlignment: WrapCrossAlignment.start,
                                    children: [
                                      Text('${peserta['name']}${peserta['id']} | Block ${peserta['remarks']}', style: TextStyle(fontSize: 16.0)),
                                      Text('Usia: ${peserta['age']} tahun', style: TextStyle(fontSize: 12.0)),
                                      Text('Alamat: ${peserta['remarks'] ?? '-'}', style: TextStyle(fontSize: 12.0)),
                                      Text('Mendaftar Pada: ${simpleDateTimeFormat(peserta['created_at'] ?? DateTime.now().toLocal().toString())}',
                                          style: TextStyle(fontSize: 12.0)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                )
              ],
            );
          },
          error: (e, s) => Text('Error $s'),
          loading: () => Center(child: CircularProgressIndicator())),
    );
  }

  Widget getImageBase64(data) {
    var avatar = Container(
      width: 70.0,
      height: 70.0,
      constraints: BoxConstraints(minWidth: 50.0, minHeight: 0.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          image: DecorationImage(
            image: (data != null && data.length > 0)
                ? MemoryImage(base64Decode(data))
                : Image.asset(
                    'assets/images/no_image.jpg',
                    width: 70.0,
                    height: 70.0,
                  ).image,
            fit: BoxFit.cover,
          )),
    );
    return avatar;
  }
}
