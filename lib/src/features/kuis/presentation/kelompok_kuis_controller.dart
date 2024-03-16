import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'kelompok_kuis_controller.g.dart';

@Riverpod(keepAlive: true)
class KelompokKuisController extends _$KelompokKuisController {
  FutureOr<List<dynamic>> build() async {
    var res = await Supabase.instance.client.from('kelompok_kuis').select();
    return res;
  }
}
