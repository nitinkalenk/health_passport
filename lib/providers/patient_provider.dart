import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_passport/models/patient.dart';
import 'package:health_passport/services/api_service.dart';

final patientProvider = FutureProvider<Patient>((ref) async {
  final apiService = ApiService();
  return apiService.fetchPatient(1); // Hardcoded ID 1
});
