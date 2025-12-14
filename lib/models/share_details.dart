class ShareDetails {
  final String patientId;
  final List<String> documents;
  final String expirationTime;

  ShareDetails({
    required this.patientId,
    required this.documents,
    required this.expirationTime,
  });

  factory ShareDetails.fromJson(Map<String, dynamic> json) {
    return ShareDetails(
      patientId: json['patientId'] ?? '',
      documents: List<String>.from(json['documents'] ?? []),
      expirationTime: json['expirationTime'] ?? '',
    );
  }
}
