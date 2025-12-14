import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_passport/models/health_status.dart';
import 'package:health_passport/providers/health_status_provider.dart';

class MyHealthScreen extends ConsumerWidget {
  const MyHealthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthStatusAsyncValue = ref.watch(healthStatusProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Health')),
      body: healthStatusAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (data) {
          if (data.isEmpty) {
            return const Center(child: Text('No health data available'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Header Row
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Parameter',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Value',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Range',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Data List
                Expanded(
                  child: ListView.separated(
                    itemCount: data.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final item = data[index];
                      final isAttentionNeeded = item.status;
                      final textColor = isAttentionNeeded
                          ? Colors.red
                          : Colors.black;
                      final fontWeight = isAttentionNeeded
                          ? FontWeight.bold
                          : FontWeight.normal;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          children: [
                            // Parameter (Left)
                            Expanded(
                              flex: 3,
                              child: Text(
                                item.parameter,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: fontWeight,
                                ),
                              ),
                            ),
                            // Value (Center)
                            Expanded(
                              flex: 2,
                              child: Text(
                                item.value,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: fontWeight,
                                ),
                              ),
                            ),
                            // Range (Right)
                            Expanded(
                              flex: 3,
                              child: Text(
                                item.expectedRange,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: fontWeight,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
