import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ramadhan_ogp/src/features/peserta/presentation/peserta_controller.dart';

class PesertaDanOrtuScreen extends HookConsumerWidget {
  const PesertaDanOrtuScreen({super.key});
  static const routeName = 'peserta-dan-ortu-screen';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pesertaDanOrtuState = ref.watch(pesertaControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peserta dan Orang Tua'),
      ),
      body: Center(
        child: pesertaDanOrtuState.when(
          data: (data) {
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(data[index].namaAnak),
                    subtitle: Text('Anaknya Pak ${data[index].namaOrangTua} di ${data[index].alamat}'),
                    trailing: Text(data[index].usia.toString()),
                  );
                });
          },
          loading: () => CircularProgressIndicator(),
          error: (error, stackTrace) {
            return Text('Error: $error');
          },
        ),
      ),
    );
  }
}
