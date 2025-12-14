import 'package:flutter/material.dart';
import 'package:health_passport/models/health_status.dart';
import 'package:health_passport/services/api_service.dart';

class MyHealthScreen extends StatefulWidget {
  const MyHealthScreen({super.key});

  @override
  State<MyHealthScreen> createState() => _MyHealthScreenState();
}

class _MyHealthScreenState extends State<MyHealthScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<HealthStatus>> _healthStatusFuture;

  @override
  void initState() {
    super.initState();
    _healthStatusFuture = _apiService.fetchHealthStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Health')),
      body: FutureBuilder<List<HealthStatus>>(
        future: _healthStatusFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
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
          } else {
            return const Center(child: Text('No data found'));
          }
        },
      ),
    );
  }
}
