import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_passport/models/health_status.dart';
import 'package:health_passport/services/api_service.dart';

final healthStatusProvider = FutureProvider<List<HealthStatus>>((ref) async {
  final apiService = ApiService();

  // Cache the data for 20 minutes
  final timer = Timer(const Duration(minutes: 20), () {
    ref.invalidateSelf();
  });

  // Dispose the timer if the provider is disposed earlier
  ref.onDispose(() => timer.cancel());

  return apiService.fetchHealthStatus();
});
