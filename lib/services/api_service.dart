import 'dart:convert';
import 'dart:io';
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

  Future<bool> createAppointment(Map<String, dynamic> appointmentData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/appointments/'),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(appointmentData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Failed to create appointment');
    }
  }

  Future<bool> uploadDocument(
    File file,
    String documentType,
    int patientId,
  ) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/upload_document/'),
    );

    request.headers['accept'] = 'application/json';
    request.headers['Content-Type'] = 'multipart/form-data';

    request.fields['patient_id'] = patientId.toString();
    request.fields['document_type'] = documentType;

    // Determine mime type if needed, or let standard inference handle it
    // For now, simpler implementation:
    // User curl example: file=@pip.pyz;type=application/x-zip-compressed
    // We'll just add the file directly.

    // Note: http package multipart file fromPath infers type usually
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Failed to upload document');
    }
  }

  Future<bool> shareDocuments(
    int shareId,
    List<int> documentIds,
    DateTime expirationTime,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/shareDocuments/$shareId'),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "patientId": "1",
        "documents": documentIds.map((e) => e.toString()).toList(),
        "expirationTime": expirationTime.toIso8601String(),
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Failed to share documents');
    }
  }
}
