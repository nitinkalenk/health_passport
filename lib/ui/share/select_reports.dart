import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:health_passport/providers/reports_provider.dart';
import 'package:health_passport/services/api_service.dart';
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
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            int selectedHours = 1;
                            return StatefulBuilder(
                              builder: (context, setModalState) {
                                return Container(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Set Expiry Time',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleLarge,
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [1, 4, 8].map((hours) {
                                          return ChoiceChip(
                                            label: Text('$hours Hours'),
                                            selected: selectedHours == hours,
                                            onSelected: (selected) {
                                              if (selected) {
                                                setModalState(() {
                                                  selectedHours = hours;
                                                });
                                              }
                                            },
                                          );
                                        }).toList(),
                                      ),
                                      const SizedBox(height: 24),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            // 1. Generate 4-digit ID (1000-9999)
                                            final shareId =
                                                1000 +
                                                (DateTime.now()
                                                        .microsecondsSinceEpoch %
                                                    9000);

                                            // 2. Calculate expiration time
                                            final expirationTime =
                                                DateTime.now().add(
                                                  Duration(
                                                    hours: selectedHours,
                                                  ),
                                                );

                                            // 3. Call API
                                            try {
                                              final apiService = ApiService();
                                              await apiService.shareDocuments(
                                                shareId,
                                                _selectedReportIds.toList(),
                                                expirationTime,
                                              );

                                              if (context.mounted) {
                                                Navigator.pop(
                                                  context,
                                                ); // Close bottom sheet

                                                // 4. Generate UUID for QR (keep as UUID per request)
                                                var uuid = const Uuid().v4();
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        QRCodeScreen(
                                                          uuid: uuid,
                                                        ),
                                                  ),
                                                );
                                              }
                                            } catch (e) {
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Error sharing: $e',
                                                    ),
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 16.0,
                                            ),
                                            backgroundColor: Theme.of(
                                              context,
                                            ).primaryColor,
                                            foregroundColor: Theme.of(
                                              context,
                                            ).colorScheme.onPrimary,
                                          ),
                                          child: const Text('Share'),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
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
