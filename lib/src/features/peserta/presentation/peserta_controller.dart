import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'peserta_controller.g.dart';

@riverpod
class PesertaController extends _$PesertaController {
  @override
  FutureOr<List<ReturnObject>> build() async {
    final jsons = await Supabase.instance.client.from('sanlats_keluargas').select();
    List<ReturnObject> rObject = [];
    for (int i = 0; i < jsons.length; i++) {
      final records = fromJson(jsons[i]);
      rObject.add(ReturnObject(
        namaAnak: records.nama_anak,
        usia: records.usia,
        namaOrangTua: records.nama_ayah,
        alamat: records.alamat,
      ));
    }
    return rObject;
    // return rObject;
  }

  ({String nama_anak, String nama_ayah, int usia, String alamat}) fromJson(Map<String, dynamic> jsonx) {
    return (
      nama_anak: jsonx['nama_anak'],
      nama_ayah: jsonx['nama_ayah'],
      usia: jsonx['usia'],
      alamat: jsonx['alamat'],
    );
  }
}

class ReturnObject {
  ReturnObject({
    required this.namaAnak,
    required this.usia,
    required this.namaOrangTua,
    required this.alamat,
  });
  String namaAnak;
  int usia;
  String namaOrangTua;
  String alamat;
}
