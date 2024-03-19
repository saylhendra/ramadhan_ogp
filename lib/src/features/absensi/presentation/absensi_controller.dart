import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'absensi_controller.g.dart';

@riverpod
class AbsensiController extends _$AbsensiController {
  @override
  FutureOr<List<dynamic>> build({required String clusterType}) async {
    final resp = await Supabase.instance.client.from('group_sanlats_absen_$clusterType').select();
    return resp as List<dynamic>;
  }

  Future<void> doUpdateIsHadir({required idPeserta, required bool isHadir}) async {
    debugPrint('idPeserta: $idPeserta, isHadir: $isHadir');
    await Supabase.instance.client.from('sanlats').update({
      'is_hadir': isHadir,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', idPeserta);
  }
}
