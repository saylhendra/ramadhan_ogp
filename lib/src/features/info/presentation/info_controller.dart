import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'info_controller.g.dart';

@Riverpod(keepAlive: true)
class InfoController extends _$InfoController {
  @override
  FutureOr<List<dynamic>> build() async {
    var response = await Supabase.instance.client.from('infos').select();
    return response as List<dynamic>;
  }
}
