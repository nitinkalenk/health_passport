import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:health_passport/providers/reports_provider.dart';
import 'package:health_passport/ui/share/qr_code_screen.dart';
import 'package:uuid/uuid.dart';

class SelectReportsScreen extends ConsumerStatefulWidget {
  const SelectReportsScreen({super.key});

  @override
  ConsumerState<SelectReportsScreen> createState() =>
      _SelectReportsScreenState();
}

class _SelectReportsScreenState extends ConsumerState<SelectReportsScreen> {
  final Set<int> _selectedReportIds = {};

  @override
  Widget build(BuildContext context) {
    final reportsAsyncValue = ref.watch(reportsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Select Reports to Share')),
      body: Column(
        children: [
          Expanded(
            child: reportsAsyncValue.when(
              data: (reports) {
                if (reports.isEmpty) {
                  return const Center(child: Text("No reports available"));
                }
                return ListView.separated(
                  itemCount: reports.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final report = reports[index];
                    final isSelected = _selectedReportIds.contains(report.id);

                    return CheckboxListTile(
                      value: isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedReportIds.add(report.id);
                          } else {
                            _selectedReportIds.remove(report.id);
                          }
                        });
                      },
                      title: Text(report.filename),
                      subtitle: Text(report.type),
                      secondary: Icon(
                        report.type == 'bllod'
                            ? Icons.bloodtype
                            : Icons.description,
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedReportIds.isEmpty
                    ? null
                    : () {
                        // Generate UUID and navigate
                        var uuid = const Uuid().v4();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QRCodeScreen(uuid: uuid),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: Text('Share (${_selectedReportIds.length})'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
