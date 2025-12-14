import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeScreen extends StatelessWidget {
  final String uuid;

  const QRCodeScreen({super.key, required this.uuid});

  @override
  Widget build(BuildContext context) {
    final String url = 'http://google.com/$uuid';

    return Scaffold(
      appBar: AppBar(title: const Text('Share Data')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              QrImageView(data: url, version: QrVersions.auto, size: 280.0),
              const SizedBox(height: 24),
              Text(
                'Scan this QR code',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                url,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
