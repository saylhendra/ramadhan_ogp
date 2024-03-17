import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';

class AlignWidget extends StatelessWidget {
  const AlignWidget({super.key, required this.total, this.title, this.type});
  final String? title;
  final int total;
  final String? type;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: type == null
          ? Padding(
              // padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.045, left: 20.0, right: 10.0),
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0, left: 20.0, right: 10.0),
              child: FloatingActionButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
                backgroundColor: AppTheme.oldBrick,
                foregroundColor: AppTheme.yellowNapes,
                onPressed: null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${title ?? 'Total'}', style: TextStyle(fontSize: title != null ? 12.0 : 11.0, height: 1.0), textAlign: TextAlign.center),
                    Text('${total}', style: TextStyle(fontSize: title != null ? 16.0 : 20.0, height: 1.0), textAlign: TextAlign.center),
                  ],
                ),
              ),
            )
          : type == 'chip'
              ? Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Chip(
                    backgroundColor: AppTheme.oldBrick,
                    label: Text(
                      '${title ?? 'Total'}: $total',
                      style: TextStyle(color: AppTheme.yellowNapes, fontSize: 13),
                      textAlign: TextAlign.left,
                    ),
                  ),
                )
              : const SizedBox(),
    );
  }
}
