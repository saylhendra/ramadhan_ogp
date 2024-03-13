import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../home/home_screen.dart';
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
    final listMasterBlock = ref.watch(masterBlockControllerProvider);

    return PopScope(
      onPopInvoked: (didPop) {
        confirmBack(context, didPop);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Daftar Sanlat"),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: MediaQuery.of(context).padding + EdgeInsets.symmetric(horizontal: 16.0.sp, vertical: 10.0.sp),
            children: [
              TextFormField(
                controller: namaController,
                validator: ValidationBuilder().required('Nama tidak boleh kosong').build(),
                decoration: InputDecoration(labelText: 'Nama Anak'),
                onFieldSubmitted: (value) {
                  _validate();
                },
              ),
              //radio button gender
              Column(
                children: [
                  RadioListTile<EnumGender>(
                    title: const Text('Ikhwan'),
                    value: EnumGender.ikhwan,
                    groupValue: _character.value,
                    onChanged: (value) {
                      _character.value = value ?? EnumGender.ikhwan;
                    },
                  ),
                  RadioListTile<EnumGender>(
                    title: const Text('Akhwat'),
                    value: EnumGender.akhwat,
                    groupValue: _character.value,
                    onChanged: (value) {
                      _character.value = value ?? EnumGender.ikhwan;
                    },
                  ),
                ],
              ),
              TextFormField(
                controller: dobController,
                validator: ValidationBuilder().required('Tgl Lahir tidak boleh kosong').build(),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Tanggal Lahir',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => showDatePicker(
                  context: context,
                  initialDate: DateTime.now().subtract(Duration(days: 365 * 3)),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                ).then((value) {
                  if (value != null) {
                    dobController.text = DateFormat('EEEE, dd-MMM-yyyy', 'id').format(value);
                    dobInsertController.text = DateFormat('yyyy-MM-dd').format(value);
                    var age = DateTime.now().toLocal().year - value.year;
                    calculatedAge.value = age;
                    calculatedAgeController.text = age.toString();
                  }
                }),
              ),
              //calculated age
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Usia tidak boleh kosong';
                  }
                  //not zero
                  if (int.parse(value) == 0) {
                    return 'Usia tidak boleh 0';
                  }
                  return null;
                },
                controller: calculatedAgeController,
                readOnly: true,
                decoration: InputDecoration(labelText: 'Usia Saat Ini (Tahun)', filled: true, fillColor: Colors.grey[200]),
              ),
              listMasterBlock.when(data: (datas) {
                return DropdownSearch<MasterBlockDomain>(
                  validator: (value) {
                    if (value == null) {
                      return 'Alamat tidak boleh kosong';
                    }
                    return null;
                  },
                  popupProps: PopupProps.menu(showSearchBox: true),
                  items: datas,
                  itemAsString: (item) => item.title ?? '',
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      labelText: "Alamat Rumah (Block-Nomor)",
                      hintText: "Pilih block dan nomor rumah",
                    ),
                  ),
                  onChanged: (value) {
                    addressController.text = value?.title ?? '';
                  },
                  selectedItem: null,
                );
              }, loading: () {
                return Center(child: const CircularProgressIndicator());
              }, error: (e, s) {
                return Text('Error: $e');
              }),
              SizedBox(height: 10.0.sp),
              FilledButton(
                onPressed: loadingSubmit.value == true
                    ? null
                    : () async {
                        if (_validate()) {
                          loadingSubmit.value = true;
                          await ref.read(sanlatRegistrationControllerProvider.notifier).doSubmitRegistration(
                                age: calculatedAge.value,
                                gender: _character == EnumGender.ikhwan ? 'IKHWAN' : 'AKHWAT',
                                name: namaController.text,
                                dob: dobInsertController.text,
                                address: addressController.text,
                              );
                          loadingSubmit.value = false;
                          context.goNamed(HomeScreen.routeName);
                        }
                      },
                child: loadingSubmit.value
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : const Text('Submit'),
              ),
              Wrap(
                direction: Axis.vertical,
                children: [
                  Text('Nama: ${namaController.text}'),
                  Text('Tanggal Lahir: ${dobController.text}'),
                  Text('Gender : ${_character.value == EnumGender.ikhwan ? 'Ikhwan' : 'Akhwat'}'),
                  Text('Umur: ${calculatedAge.value}'),
                  Text('Alamat: ${addressController.text}'),
                ],
              )
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
        builder: (context) {
          return AlertDialog(
            title: const Text('Konfirmasi'),
            content: const Text('Apakah Anda yakin ingin kembali?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Tidak'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('Ya'),
              ),
            ],
          );
        },
      );
    }
  }
}

enum EnumGender { ikhwan, akhwat }
