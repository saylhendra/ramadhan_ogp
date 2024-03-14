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
    String? avatar,
    required int age,
  }) async {
    for (int i = 0; i < 5; i++) {
      await Supabase.instance.client.from('sanlats').upsert([
        {
          'name': name + i.toString(),
          'gender': gender,
          'age': age + i,
          'dob': dob,
          'remarks': address,
          // 'avatar': avatar ?? '',
          'created_at': DateTime.now().toLocal(),
          'updated_at': DateTime.now().toLocal(),
          'published_at': DateTime.now().toLocal(),
        }
      ]);
    }
  }
}

@Riverpod(keepAlive: true)
class PesertaSanlatController extends _$PesertaSanlatController {
  @override
  FutureOr<List<dynamic>> build() async {
    List x = await Supabase.instance.client.from('sanlats').select();
    return x;
  }
}
