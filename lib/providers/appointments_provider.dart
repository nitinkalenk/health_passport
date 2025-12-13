import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_passport/models/appointment.dart';
import 'package:health_passport/services/api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final appointmentsProvider = FutureProvider<List<Appointment>>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  return apiService.fetchAppointments();
});
