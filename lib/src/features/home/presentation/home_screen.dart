import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ramadhan_ogp/src/core/utils.dart';
import 'package:ramadhan_ogp/src/features/home/presentation/widgets/home_menu_widget.dart';
import 'package:ramadhan_ogp/src/features/sanlat/sanlat_quiz_registration_screen.dart';
import 'package:ramadhan_ogp/src/features/sanlat/sanlat_registration_controller.dart';

import '../../../core/app_theme.dart';
import '../../sanlat/peserta_sanlat_detail_screen.dart';
import '../../sanlat/sanlat_registration_screen.dart';

//global key for form
final formkey = GlobalKey<FormState>();

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
    final isShowSearchBox = useState(false);
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
          data: (List<dynamic> datas) {
            datas.sort((b, a) => a['id'].compareTo(b['id']));
            return Stack(
              alignment: Alignment.topRight,
              children: [
                Column(
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
                              Text('Daftar Peserta Sanlat', style: TextStyle(fontSize: 18.0)),
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
                        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 4.0),
                        child: Form(
                          key: formkey,
                          child: TextFormField(
                            validator: (value) {
                              if (value!.length < 1 && keyWords.value.isNotEmpty) {
                                return 'Kata kunci minimal 3 karakter';
                              }
                              return null;
                            },
                            controller: searchController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Cari nama, alamat, usia...',
                              prefixIcon: IconButton(
                                onPressed: () {
                                  searchController.clear();
                                  keyWords.value = '';
                                  // listTmp.value = [...datas];
                                },
                                icon: keyWords.value.length > 1 ? Icon(Icons.clear) : Icon(Icons.search),
                              ),
                            ),
                            onFieldSubmitted: (value) {
                              keyWords.value = value;
                              if (keyWords.value.isNotEmpty) {
                                if (keyWords.value.length > 1) {
                                  listTmp.value = [...datas];
                                  listTmp.value = datas.where((peserta) {
                                    return peserta['name'].toLowerCase().contains(value.toLowerCase()) ||
                                        peserta['remarks'].toLowerCase().contains(value.toLowerCase()) ||
                                        peserta['age'].toString().contains(value.toLowerCase());
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
                          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
                          itemCount: keyWords.value.length > 1 ? listTmp.value.length : datas.length,
                          itemBuilder: (item, index) {
                            var peserta = keyWords.value.length > 1 ? listTmp.value[index] : datas[index];
                            return InkWell(
                              onTap: () {
                                doOpenDetailPeserta(context, peserta);
                              },
                              child: Card(
                                elevation: 4.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Row(
                                        children: [
                                          getImageBase64(peserta['avatar']),
                                          VerticalDivider(),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context).size.width * 0.35,
                                                child: Text(
                                                  '${peserta['name']} | ${peserta['remarks']}\n${peserta['gender']}',
                                                  style: TextStyle(fontSize: 16.0),
                                                  maxLines: 3,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Text('Usia: ${peserta['age']} tahun', style: TextStyle(fontSize: 12.0)),
                                              Text('Alamat: ${peserta['remarks'] ?? '-'}', style: TextStyle(fontSize: 12.0)),
                                              Text(
                                                  'Mendaftar Pada: ${simpleDateTimeFormat(peserta['created_at'] ?? DateTime.now().toLocal().toString())}',
                                                  style: TextStyle(fontSize: 12.0)),
                                            ],
                                          ),
                                        ],
                                      ),
                                      if (peserta['is_quiz_registered'] != null && peserta['is_quiz_registered'] == true)
                                        Chip(
                                            label: Text('✅ Terdaftar Kuis', style: TextStyle(fontSize: 10.0)),
                                            backgroundColor: AppTheme.plantation,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(100.0), side: BorderSide(color: AppTheme.pinkDown)),
                                            labelStyle: TextStyle(color: AppTheme.pinkDown))
                                      else
                                        Visibility(
                                          //visible if age is 8 or above
                                          visible: peserta['age'] >= 8,
                                          child: OutlinedButton(
                                            //onHover show tooltip
                                            onHover: (value) {
                                              if (value) showTooltip(context, 'Kuis', 'Hanya untuk Usia 8 - 13 thn');
                                            },
                                            onLongPress: () => showTooltip(context, 'Kuis', 'Hanya untuk Usia 8 - 13 thn'),
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor: AppTheme.oldBrick,
                                              foregroundColor: AppTheme.pinkDown,
                                              shadowColor: Colors.black,
                                              elevation: 4.0,
                                              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
                                              animationDuration: Duration(milliseconds: 300),
                                            ),
                                            onPressed: () {
                                              context.pushNamed(
                                                SanlatQuizRegistrationScreen.routeName,
                                                extra: {
                                                  'id': peserta['id'].toString(),
                                                  'name': peserta['name'],
                                                  'avatar': peserta['avatar'],
                                                  'age': peserta['age'].toString(),
                                                  'remarks': peserta['remarks'] ?? '-',
                                                },
                                              );
                                            },
                                            child: Text(
                                              'Daftarkan\nKuis?',
                                              style: TextStyle(fontSize: 11.0),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.045, left: 20.0, right: 10.0),
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
              // ? MemoryImage(base64Decode(data))
              // ? NetworkImage(data)
              ? NetworkImage(data)
              : Image.asset(
                  'assets/images/no_image.jpg',
                  width: 70.0,
                  height: 70.0,
                ).image,
          fit: BoxFit.cover,
        ),
      ),
      // child: BackdropFilter(
      //   filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 10.0),
      //   child: Container(
      //     decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
      //   ),
      // ),
    );
    return avatar;
  }

  doOpenDetailPeserta(BuildContext context, dynamic peserta) {
    var paramPeserta = {
      'id': peserta['id'].toString(),
      'name': peserta['name'],
      'gender': peserta['gender'],
      'age': peserta['age'].toString(),
      'remarks': peserta['remarks'],
      'avatar': peserta['avatar'],
      'created_at': peserta['created_at'],
    };

    context.pushNamed(PesertaSanlatDetailScreen.routeName, extra: paramPeserta);
  }

  void showTooltip(BuildContext context, String s, String t) {
    final snackBar = SnackBar(
      content: Text(s),
      action: SnackBarAction(
        label: t,
        onPressed: () {},
      ),
    );
    //show snackbar with duration
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

/// Enum representing the upload task types the example app supports.
enum UploadType {
  /// Uploads a randomly generated string (as a file) to Storage.
  string,

  /// Uploads a file from the device.
  file,

  /// Clears any tasks from the list.
  clear,
}
