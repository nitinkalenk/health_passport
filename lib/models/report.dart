class Report {
  final int id;
  final String filename;
  final String type;
  final String uploadedOn;

  Report({
    required this.id,
    required this.filename,
    required this.type,
    required this.uploadedOn,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'] as int,
      filename: json['filename'] as String,
      type: json['type'] as String,
      uploadedOn: json['UploadedOn'] as String,
    );
  }
}
