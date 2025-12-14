import 'dart:convert';
import 'package:health_passport/models/appointment.dart';
import 'package:health_passport/models/family_member.dart';
import 'package:health_passport/models/report.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8000';

  Future<List<Appointment>> fetchAppointments() async {
    final response = await http.get(Uri.parse('$baseUrl/appointments/1'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Appointment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load appointments');
    }
  }

  Future<List<Report>> fetchReports() async {
    final response = await http.get(Uri.parse('$baseUrl/patients/1/documents'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Report.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load reports');
    }
  }

  Future<List<FamilyMember>> fetchFamilyMembers() async {
    final response = await http.get(Uri.parse('$baseUrl/family/2'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => FamilyMember.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load family members');
    }
  }
}
