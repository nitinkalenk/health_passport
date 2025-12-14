class FamilyMember {
  final String familyId;
  final String dateOfBirth;
  final String phoneNumber;
  final String address;
  final String chronicConditions;
  final String emergencyContactNumber;
  final String fullName;
  final int patientId;
  final String gender;
  final String bloodGroup;
  final String email;
  final String allergies;
  final String emergencyContactName;
  final String createdAt;

  FamilyMember({
    required this.familyId,
    required this.dateOfBirth,
    required this.phoneNumber,
    required this.address,
    required this.chronicConditions,
    required this.emergencyContactNumber,
    required this.fullName,
    required this.patientId,
    required this.gender,
    required this.bloodGroup,
    required this.email,
    required this.allergies,
    required this.emergencyContactName,
    required this.createdAt,
  });

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      familyId: json['FamilyID'] as String,
      dateOfBirth: json['DateOfBirth'] as String,
      phoneNumber: json['PhoneNumber'] as String,
      address: json['Address'] as String,
      chronicConditions: json['ChronicConditions'] as String,
      emergencyContactNumber: json['EmergencyContactNumber'] as String,
      fullName: json['FullName'] as String,
      patientId: json['PatientID'] as int,
      gender: json['Gender'] as String,
      bloodGroup: json['BloodGroup'] as String,
      email: json['Email'] as String,
      allergies: json['Allergies'] as String,
      emergencyContactName: json['EmergencyContactName'] as String,
      createdAt: json['CreatedAt'] as String,
    );
  }
}
