import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'peserta_based_controller.g.dart';

@riverpod
class PesertaBasedController extends _$PesertaBasedController {
  @override
  FutureOr<List<dynamic>> build() async {
    final res = await Supabase.instance.client.from('peserta_based_usia').select();
    return res;
  }
}
