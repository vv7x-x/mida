import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:special_one_student/config/localization.dart';

class QrCodeScreen extends StatelessWidget {
  const QrCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    final String? studentId = ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.qrCode),
      ),
      body: Center(
        child: studentId != null
            ? QrImageView(
                data: studentId,
                version: QrVersions.auto,
                size: 200.0,
              )
            : Text(l.noData),
      ),
    );
  }
}