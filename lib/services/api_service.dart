import 'dart:convert';
import 'package:health_passport/models/appointment.dart';
import 'package:health_passport/models/family_member.dart';
import 'package:health_passport/models/report.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://api.jsonbin.io/v3/b';

  Future<List<Appointment>> fetchAppointments() async {
    final response = await http.get(
      Uri.parse('$baseUrl/693d6cca43b1c97be9eba14b?meta=false'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Appointment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load appointments');
    }
  }

  Future<List<Report>> fetchReports() async {
    final response = await http.get(
      Uri.parse('$baseUrl/693e40cbae596e708f98a97d?meta=false'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Report.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load reports');
    }
  }

  Future<List<FamilyMember>> fetchFamilyMembers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/693e4601d0ea881f40280608?meta=false'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => FamilyMember.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load family members');
    }
  }
}
