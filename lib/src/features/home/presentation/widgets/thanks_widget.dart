import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';

class ThanksWidget extends StatelessWidget {
  const ThanksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Text('Terima Kasih Telah Mendaftar, Pendaftaran Sudah Kami Tutup\nSampai Jumpa Ahad Nanti ya....',
            textAlign: TextAlign.center,
            maxLines: 3,
            style: TextStyle(
              color: AppTheme.oldBrick,
              fontSize: 20.0,
              letterSpacing: 1.0,
              height: 1,
            )),
        Image.asset('assets/images/thanks.gif', width: 100.0, height: 100.0),
      ],
    );
  }
}
