import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_app/localization/localization.dart';
import 'package:mobile_app/utils/app_strings.dart';

class QrCodeScreen extends StatelessWidget {
  const QrCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    final String? studentId = ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.get(AppStrings.qrCode)),
      ),
      body: Center(
        child: studentId != null
            ? QrImageView(
                data: studentId,
                version: QrVersions.auto,
                size: 200.0,
              )
            : Text(appLocalizations.get(AppStrings.noStudentIdFound)),
      ),
    );
  }
}