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

@riverpod
class SanlatGroupsController extends _$SanlatGroupsController {
  @override
  FutureOr<List<dynamic>> build() async {
    final res = await Supabase.instance.client.from('sanlat_groups').select();
    print('res: $res');
    return res;
  }

  Future<void> addGroupToSanlatGroup({required int idPeserta, required String idGroup}) async {
    print('idPeserta: $idPeserta, idGroup: $idGroup');
    await Supabase.instance.client.from('sanlats_sanlat_group_links').upsert({
      'sanlat_id': idPeserta,
      'sanlat_group_id': idGroup,
    });
  }
}

@riverpod
//groupingController
class GroupingController extends _$GroupingController {
  @override
  FutureOr<List<dynamic>> build() async {
    final res = await Supabase.instance.client.from('group_sanlats_members').select();
    return res;
  }

  Future<void> removed(dynamic data) async {
    await Supabase.instance.client
        .from('sanlats_sanlat_group_links')
        .delete()
        .eq(
          'sanlat_group_id',
          data['sanlat_group_id'],
        )
        .eq(
          'sanlat_id',
          data['sanlat_id'],
        );
  }

  Future<bool> checkIfPesertaAlreadyGrouped({required int idPeserta}) async {
    var alreadyGrouped = false;
    var x = await Supabase.instance.client.from('sanlats_sanlat_group_links').select().eq('sanlat_id', idPeserta);
    if (x.isNotEmpty) {
      alreadyGrouped = true;
    }
    return alreadyGrouped;
  }
}
