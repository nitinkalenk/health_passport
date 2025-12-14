import 'package:flutter/material.dart';

class SharesContentScreen extends StatelessWidget {
  final String pin;

  const SharesContentScreen({super.key, required this.pin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shared Documents')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.folder_shared, size: 64, color: Colors.blue),
            const SizedBox(height: 16),
            Text(
              'Viewing shared content for PIN',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              pin,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 32),
            const Text('Document list will appear here.'),
          ],
        ),
      ),
    );
  }
}
