import 'dart:convert';

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
            child: ListTile(
              title: Text('Nama: ${peserta['name']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Alamat: ${peserta['remarks']}'),
                  Text('Usia: ${peserta['age']} tahun'),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.5,
                    margin: const EdgeInsets.only(top: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                          image: MemoryImage(
                            base64Decode(peserta['avatar']),
                            scale: 1.0,
                          ),
                          fit: BoxFit.cover),
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
