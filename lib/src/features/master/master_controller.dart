import 'package:dio/dio.dart';
import 'package:ramadhan_ogp/src/core/endpoints.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'domain/master_block_domain.dart';

part 'master_controller.g.dart';

@Riverpod(keepAlive: true)
class MasterBlockController extends _$MasterBlockController {
  @override
  FutureOr<List<MasterBlockDomain>> build() async {
    final dio = Dio();
    final response = await dio.get(Endpoints.masterBlocks);

    if (response.statusCode == 200) {
      var data = response.data;
      return List<Map<String, dynamic>>.from(data).map((e) => MasterBlockDomain.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
