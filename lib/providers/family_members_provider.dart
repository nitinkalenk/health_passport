import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_passport/models/family_member.dart';
import 'package:health_passport/services/api_service.dart';

final familyMembersProvider = FutureProvider<List<FamilyMember>>((ref) async {
  final apiService = ApiService();
  return apiService.fetchFamilyMembers();
});
