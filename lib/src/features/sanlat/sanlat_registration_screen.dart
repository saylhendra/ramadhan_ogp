import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_validator/form_validator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../master/domain/master_block_domain.dart';
import '../master/master_controller.dart';

var _formKey = GlobalKey<FormState>();

class SanlatRegistrationScreen extends HookConsumerWidget {
  const SanlatRegistrationScreen({super.key});
  static const String routeName = 'sanlat-registration-screen';

  void _validate() {
    _formKey.currentState?.validate();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var namaController = useTextEditingController();
    var dobController = useTextEditingController();
    var dobInsertController = useTextEditingController();
    var addressController = useTextEditingController();
    var calculatedAgeController = useTextEditingController();
    var calculatedAge = useState<int>(0);
    final listMasterBlock = ref.watch(masterBlockControllerProvider);

    return Scaffold(
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
                  addressController.text = value?.title.toString() ?? '0';
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
              onPressed: () {
                _validate();
              },
              child: const Text('Submit'),
            ),
            Wrap(
              direction: Axis.vertical,
              children: [
                Text('Nama: ${namaController.text}'),
                Text('Tanggal Lahir: ${dobController.text}'),
                // Text('Tanggal Lahir Insert: ${dobInsertController.text}'),
                Text('Umur: ${calculatedAge.value}'),
                Text('Alamat: ${addressController.text}'),
              ],
            )
          ],
        ),
      ),
    );
  }
}
