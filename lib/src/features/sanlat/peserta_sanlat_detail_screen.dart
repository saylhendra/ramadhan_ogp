import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/app_theme.dart';

class PesertaSanlatDetailScreen extends HookConsumerWidget {
  PesertaSanlatDetailScreen({super.key, required this.peserta});
  static const routeName = 'peserta-sanlat-detail-screen';
  final Map<String, dynamic> peserta;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${peserta['name']}'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppTheme.myGradient,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: [
          Card(
            elevation: 4.0,
            child: ListTile(
              title: Text('Nama: ${peserta['name']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Jns. Kelamin: ${peserta['gender']}'),
                  Text('Alamat: ${peserta['remarks']}'),
                  Text('Usia: ${peserta['age']} tahun'),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width * 1,
                    margin: const EdgeInsets.only(top: 10.0),
                    decoration: BoxDecoration(
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.grey.withOpacity(0.5),
                      //     spreadRadius: 2,
                      //     blurRadius: 5,
                      //     offset: const Offset(0, 2),
                      //   ),
                      // ],
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        image: NetworkImage(peserta['avatar'], scale: 1.0),
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
