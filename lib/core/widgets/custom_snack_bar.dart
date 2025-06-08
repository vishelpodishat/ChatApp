import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class CustomSnackbar {
  static Future<void> show(BuildContext context, {required String text}) async {
    return SmartDialog.showToast(
      '',
      builder: (context) {
        return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Color(0xFF303943)),
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          margin: EdgeInsets.only(bottom: 42, right: 16, left: 16),
          child: Text(text, textAlign: TextAlign.start),
        );
      },
      displayTime: Duration(seconds: 5),
    );
  }
}
