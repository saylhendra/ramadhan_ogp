import 'dart:convert';
import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
// import 'package:image_picker_web/image_picker_web.dart';
import 'package:intl/intl.dart';
import 'package:ramadhan_ogp/src/features/info/presentation/info_controller.dart';

import '../../core/app_theme.dart';
import '../../core/utils.dart';
import '../home/presentation/home_screen.dart';
import '../master/domain/master_block_domain.dart';
import '../master/master_controller.dart';
import 'sanlat_registration_controller.dart';

var _formKey = GlobalKey<FormState>();

class SanlatRegistrationScreen extends HookConsumerWidget {
  const SanlatRegistrationScreen({super.key});
  static const String routeName = 'sanlat-registration-screen';

  bool _validate() {
    return _formKey.currentState?.validate() ?? false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var namaController = useTextEditingController();
    var dobController = useTextEditingController();
    var dobInsertController = useTextEditingController();
    var addressController = useTextEditingController();
    var calculatedAgeController = useTextEditingController();
    var calculatedAge = useState<int>(0);
    var _character = useState(EnumGender.ikhwan);
    var loadingSubmit = useState<bool>(false);
    var avatarController = useTextEditingController();
    var imagePreview = useState<String>('');
    var isExpandedState = useState<bool>(true);
    final listMasterBlock = ref.watch(masterBlockControllerProvider);
    final infosState = ref.watch(infoControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Sanlat"),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppTheme.myGradient),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          // padding: const EdgeInsets.all(8.0),
          padding: MediaQuery.of(context).padding + EdgeInsets.symmetric(horizontal: 16.0.sp, vertical: 20.0.sp),
          child: Column(
            children: [
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                // color: AppTheme.white,
                borderOnForeground: true,
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextFormField(
                          autofocus: false,
                          focusNode: FocusNode(),
                          controller: namaController,
                          validator: ValidationBuilder().required('Nama tidak boleh kosong').build(),
                          decoration: InputDecoration(
                            labelText: 'Nama Anak (*)',
                            hintText: 'Nama Lengkap Anak',
                          ),
                          onFieldSubmitted: (value) {
                            _validate();
                          },
                        ),
                        SizedBox(height: 5.0.sp),
                        Container(
                          color: AppTheme.pinkDown,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RadioListTile<EnumGender>(
                                dense: false,
                                visualDensity: VisualDensity.compact,
                                title: const Text('Ikhwan'),
                                value: EnumGender.ikhwan,
                                groupValue: _character.value,
                                onChanged: (value) {
                                  _character.value = value ?? EnumGender.ikhwan;
                                },
                              ),
                              RadioListTile<EnumGender>(
                                dense: false,
                                visualDensity: VisualDensity.compact,
                                title: const Text('Akhwat'),
                                value: EnumGender.akhwat,
                                groupValue: _character.value,
                                onChanged: (value) {
                                  _character.value = value ?? EnumGender.ikhwan;
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5.0.sp),
                        TextFormField(
                          controller: dobController,
                          validator: ValidationBuilder().required('Tgl Lahir tidak boleh kosong').build(),
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Tanggal Lahir',
                            disabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          onTap: () => showDatePicker(
                            context: context,
                            initialDate: DateTime.now().subtract(Duration(days: 365 * 3)),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          ).then((dt) {
                            if (dt != null) {
                              dobController.text = DateFormat('EEEE, dd-MMM-yyyy', 'id').format(dt);
                              dobInsertController.text = DateFormat('yyyy-MM-dd').format(dt);
                              //menghitung tanggal
                              calculatedAge.value = calcAge(DateTime.now().toLocal(), dt, calculatedAgeController);
                            }
                          }),
                        ),
                        SizedBox(height: 5.0.sp),
                        TextFormField(
                          focusNode: FocusNode(),
                          controller: calculatedAgeController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Usia Saat Ini',
                            filled: true,
                            fillColor: const Color.fromARGB(255, 229, 219, 215),
                          ),
                          enabled: false,
                        ),
                        SizedBox(height: 5.0.sp),
                        listMasterBlock.when(data: (datas) {
                          return DropdownSearch<MasterBlockDomain>(
                            validator: (value) {
                              if (addressController.text.isEmpty) {
                                return 'Alamat tidak boleh kosong';
                              }
                              return null;
                            },
                            popupProps: PopupProps.menu(
                              showSearchBox: true,
                              searchFieldProps: TextFieldProps(
                                decoration: InputDecoration(
                                  labelText: "Cari Alamat",
                                  hintText: "ketik block atau nomor rumah...",
                                ),
                              ),
                            ),
                            items: datas,
                            itemAsString: (item) => item.title ?? '',
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                labelText: "Alamat Rumah",
                                hintText: "Pilih block dan nomor rumah",
                              ),
                            ),
                            onChanged: (value) {
                              addressController.text = value?.title ?? '';
                            },
                            selectedItem: MasterBlockDomain(title: 'Pilih Alamat'),
                          );
                        }, loading: () {
                          return Center(child: const CircularProgressIndicator());
                        }, error: (e, s) {
                          return Text('Error: $e');
                        }),
                        SizedBox(height: 5.0.sp),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            if (imagePreview.value.length > 0)
                              CircleAvatar(
                                radius: 50.0,
                                child: Image.network(
                                  imagePreview.value,
                                  width: 100.0.sp,
                                  height: 100.0.sp,
                                  fit: BoxFit.cover,
                                ),
                              )
                            else
                              const Icon(Icons.person, size: 100.0),
                            Wrap(
                              children: [
                                OutlinedButton.icon(
                                  label: const Text('Upload Foto Peserta'),
                                  icon: const Icon(Icons.image),
                                  onPressed: () async {
                                    // avatarController.text = await doUploadImage(context);
                                    avatarController.text = await doUploadImageToFirebase(context, namaController.text);
                                    // avatarController.text = await doUploadImageToFirebaseMobile(context, namaController.text);
                                    // await doUploadImageToFirebase(context, namaController.text);
                                    imagePreview.value = avatarController.text;
                                  },
                                  // onPressed: null,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 5.0.sp),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                              onPressed: loadingSubmit.value == true
                                  ? null
                                  : () {
                                      if (_validate()) {
                                        loadingSubmit.value = true;
                                        ref
                                            .read(sanlatRegistrationControllerProvider.notifier)
                                            .doSubmitRegistration(
                                              age: calculatedAge.value,
                                              gender: _character.value == EnumGender.ikhwan ? 'IKHWAN' : 'AKHWAT',
                                              name: namaController.text,
                                              avatar: avatarController.text,
                                              dob: dobInsertController.text,
                                              address: addressController.text,
                                            )
                                            .then(
                                          (value) {
                                            loadingSubmit.value = false;
                                            ref.invalidate(pesertaSanlatControllerProvider);
                                            context.pushReplacementNamed(HomeScreen.routeName);
                                            // Future.delayed(const Duration(seconds: 3), () {});
                                          },
                                        );
                                      }
                                    },
                              child: loadingSubmit.value ? Center(child: CircularProgressIndicator()) : const Text('Submit')),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Divider(),
              infosState.when(
                data: (datas) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: ExpansionPanelList(
                      expandIconColor: AppTheme.oldBrick,
                      expansionCallback: (int index, bool isExpanded) {
                        isExpandedState.value = isExpanded;
                      },
                      animationDuration: const Duration(milliseconds: 500),
                      elevation: 4.0,
                      expandedHeaderPadding: const EdgeInsets.symmetric(vertical: 10.0),
                      children: datas.map<ExpansionPanel>((info) {
                        return ExpansionPanel(
                          backgroundColor: AppTheme.pinkDown,
                          isExpanded: isExpandedState.value,
                          canTapOnHeader: true,
                          headerBuilder: (context, isExpanded) {
                            return ListTile(
                              title: Text('Klik Disini Untuk Lihat Informasi Sanlat'),
                            );
                          },
                          body: Card(
                            child: ListTile(
                              subtitle: Wrap(
                                children: [
                                  Image.memory(
                                    base64Decode(info['avatar'].toString()),
                                    fit: BoxFit.cover,
                                  ),
                                  MarkdownBody(
                                    data: info['content_markdown'].toString(),
                                    selectable: true,
                                    onTapLink: (text, href, title) {
                                      launchInBrowser(href ?? '');
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
                loading: () {
                  return const Center(child: CircularProgressIndicator());
                },
                error: (e, s) {
                  return Text('Error: $e');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void confirmBack(BuildContext context, bool didPop) {
    if (didPop) {
      showDialog(
        context: context,
        builder: (dcontext) {
          return AlertDialog(
            title: const Text('Konfirmasi'),
            content: const Text('Apakah Anda yakin ingin kembali?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dcontext).pop();
                },
                child: const Text('Tidak'),
              ),
              TextButton(
                onPressed: () {
                  context.goNamed(HomeScreen.routeName);
                  Navigator.of(dcontext).pop();
                },
                child: const Text('Ya'),
              ),
            ],
          );
        },
      );
    }
  }

  // Future<String> doUploadImage(BuildContext context) async {
  //   var result = '';
  //   if (kIsWeb) {
  //     final imageSource = await ImagePickerWeb.getImageAsBytes();
  //     if (imageSource != null) {
  //       // var f = await imageSource.readAsBytes();
  //       var f = imageSource;
  //       // File photo = File(f.toSet().toString());
  //       String fileInBase64 = base64Encode(f);
  //       // var fileName = photo.path.split('/').last.replaceAll('scaled_', '');
  //       final bytes = f.lengthInBytes;
  //       print(bytes.toString());
  //       if (bytes > 5000000) {
  //         showAlertDialog(context, 'Sorry, file size is too large, max 5Mb');
  //       } else {
  //         result = fileInBase64;
  //       }
  //     }
  //   } else {
  //     final imageSource = await ImagePicker().pickImage(source: ImageSource.gallery);
  //     if (imageSource != null) {
  //       var f = File(imageSource.path);
  //       final bytes = f.lengthSync();
  //       print(bytes.toString());
  //       if (bytes > 5000000) {
  //         showAlertDialog(context, 'Sorry, file size is too large, max 5Mb');
  //       } else {
  //         result = base64Encode(f.readAsBytesSync());
  //       }
  //     }
  //   }
  //   return result;
  // }

  Future<String> doUploadImageToFirebase(BuildContext context, String paramFileName) async {
    var firebaseUrl = '';
    final imageSource = await ImagePickerWeb.getImageAsBytes();
    if (imageSource != null) {
      var f = imageSource;
      var fileName = 'sanlat_$paramFileName${DateTime.now().millisecondsSinceEpoch}';
      final bytes = f.lengthInBytes;
      if (bytes > 2000000) {
        showAlertDialog(context, 'Maaf, ukuran file terlalu besar, maksimal 2Mb');
      } else {
        // Create a Reference to the file
        Reference ref = FirebaseStorage.instance.ref().child('peserta-sanlats').child('/$fileName.jpg');
        final metadata = SettableMetadata(
          contentType: 'image/jpeg',
          // customMetadata: {'picked-file-path': file.relativePath ?? ''},
          contentEncoding: 'base64',
        );
        UploadTask uploadTask = ref.putData(await f, metadata);
        var dowurl = await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
        firebaseUrl = dowurl;
      }
    }
    return firebaseUrl;
  }

  Future<String> doUploadImageToFirebaseMobile(BuildContext context, String paramFileName) async {
    var firebaseUrl = '';
    final imageSource = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageSource != null) {
      var f = File(imageSource.path);
      var fileName = 'sanlat_$paramFileName${DateTime.now().millisecondsSinceEpoch}';
      final bytes = f.lengthSync();
      if (bytes > 2000000) {
        showAlertDialog(context, 'Maaf, ukuran file terlalu besar, maksimal 2Mb');
      } else {
        // Create a Reference to the file
        Reference ref = FirebaseStorage.instance.ref().child('peserta-sanlats').child('/$fileName.jpg');
        final metadata = SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {'picked-file-path': f.path},
        );
        UploadTask uploadTask = ref.putFile(f, metadata);
        var dowurl = await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
        firebaseUrl = dowurl;
      }
    }
    return firebaseUrl;
  }

  void showAlertDialog(BuildContext context, String s) {
    showDialog(
      context: context,
      builder: (dcontext) {
        return AlertDialog(
          title: const Text('Info'),
          content: Text(s),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dcontext).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  int calcAge(DateTime today, DateTime dob, TextEditingController calculatedAgeController) {
    final year = today.year - dob.year;
    final mth = today.month - dob.month;
    final days = today.day - dob.day;
    if (mth < 0) {
      /// negative month means it's still upcoming
      print('you buns is ${year - 1}');
      print('turning $year in ${mth.abs()} months and $days days');
      calculatedAgeController.text = '${year - 1} tahun, ${mth.abs()} bulan';
      return year - 1;
    } else {
      //age now
      print('your age is $year years and ${mth} months and ${days} days');
      print('your next bday is ${12 - mth}months and ${28 - days} days away');
      calculatedAgeController.text = '$year tahun, $mth bulan';
      return year;
    }
  }
}

enum EnumGender { ikhwan, akhwat }
