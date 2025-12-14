class Patient {
  final String fullName;
  final String gender;
  final String dateOfBirth;
  final String familyID;
  final String bloodGroup;
  final String phoneNumber;
  final String email;
  final String address;
  final String allergies;
  final String chronicConditions;
  final String emergencyContactName;
  final String emergencyContactNumber;

  Patient({
    required this.fullName,
    required this.gender,
    required this.dateOfBirth,
    required this.familyID,
    required this.bloodGroup,
    required this.phoneNumber,
    required this.email,
    required this.address,
    required this.allergies,
    required this.chronicConditions,
    required this.emergencyContactName,
    required this.emergencyContactNumber,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      fullName: json['FullName'] ?? '',
      gender: json['Gender'] ?? '',
      dateOfBirth: json['DateOfBirth'] ?? '',
      familyID: json['FamilyID'] ?? '',
      bloodGroup: json['BloodGroup'] ?? '',
      phoneNumber: json['PhoneNumber'] ?? '',
      email: json['Email'] ?? '',
      address: json['Address'] ?? '',
      allergies: json['Allergies'] ?? '',
      chronicConditions: json['ChronicConditions'] ?? '',
      emergencyContactName: json['EmergencyContactName'] ?? '',
      emergencyContactNumber: json['EmergencyContactNumber'] ?? '',
    );
  }
}
