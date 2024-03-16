import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/app_theme.dart';
import '../../../sanlat/peserta_sanlat_detail_screen.dart';

class CardPesertaWidget extends StatelessWidget {
  const CardPesertaWidget({
    super.key,
    required this.avatar,
    required this.name,
    required this.age,
    required this.remarks,
    required this.gender,
  });

  final String avatar;
  final String name;
  final int age;
  final String remarks;
  final String gender;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushNamed(
          PesertaSanlatDetailScreen.routeName,
          extra: {
            'avatar': avatar,
            'name': name,
            'age': age,
            'remarks': remarks,
            'gender': gender,
          },
        );
      },
      child: Card(
        elevation: 5.0,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                gradient: AppTheme.myGradient,
                image: DecorationImage(
                  image: avatar.length > 0 ? NetworkImage(avatar) : Image.asset('assets/images/no_mage.jpg').image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
                color: AppTheme.yellowNapes.withAlpha(200),
              ),
              child: ListTile(
                visualDensity: VisualDensity.compact,
                title: Text('${name} | ${age.toString()}thn | ${remarks}',
                    style: TextStyle(height: 1.0, fontSize: 12.0, color: AppTheme.dark, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
