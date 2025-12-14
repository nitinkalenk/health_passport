import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_passport/models/report.dart';
import 'package:health_passport/services/api_service.dart';

final reportsProvider = FutureProvider<List<Report>>((ref) async {
  final apiService = ApiService();
  return apiService.fetchReports();
});
