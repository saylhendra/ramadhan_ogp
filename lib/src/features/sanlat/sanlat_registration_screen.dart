import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_validator/form_validator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Sanlat"),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5.sp,
        child: Form(
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
              DropdownSearch<String>(
                popupProps: PopupProps.menu(
                  showSelectedItems: true,
                  disabledItemFn: (String s) => s.startsWith('I'),
                  showSearchBox: true,
                ),
                items: ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Menu mode",
                    hintText: "country in menu mode",
                  ),
                ),
                // popupProps: PopupPropsMultiSelection.modalBottomSheet(
                //   isFilterOnline: true,
                //   showSelectedItems: true,
                //   showSearchBox: true,
                //   itemBuilder: _customPopupItemBuilderExample2,
                //   favoriteItemProps: FavoriteItemProps(
                //     showFavoriteItems: true,
                //     favoriteItems: (us) {
                //       return us.where((e) => e.name.contains("Mrs")).toList();
                //     },
                //   ),
                // ),
                onChanged: print,
                selectedItem: "Brazil",
              ),
              SizedBox(height: 10.0.sp),
              FilledButton(
                onPressed: () {
                  _validate();
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
