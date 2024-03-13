import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:ramadhan_ogp/src/core/endpoints.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'sanlat_registration_controller.g.dart';

@riverpod
class SanlatRegistrationController extends _$SanlatRegistrationController {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<void> doSubmitRegistration({
    required String name,
    required String dob,
    required String gender,
    required String address,
    required int age,
  }) async {
    await Supabase.instance.client.from('sanlats').upsert([
      {
        'name': name,
        'gender': gender,
        'age': age,
        'dob': dob,
        'remarks': address,
      }
    ]);
  }
}

@Riverpod(keepAlive: true)
class PesertaSanlatController extends _$PesertaSanlatController {
  @override
  FutureOr<List<dynamic>> build() async {
    final dio = Dio();
    var res = await dio.get(Endpoints.sanlats);
    if (res.statusCode == 200) {
      debugPrint(res.data);
      return res.data;
    }
    return [];
  }
}
