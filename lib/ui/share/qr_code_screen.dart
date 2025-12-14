import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeScreen extends StatelessWidget {
  final int shareId;

  const QRCodeScreen({super.key, required this.shareId});

  @override
  Widget build(BuildContext context) {
    final String url = 'http://localhost:1000/$shareId';

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
              const SizedBox(height: 16),
              Text(
                'OR Open http://localhost:1000 and enter share pin :',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '$shareId',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
