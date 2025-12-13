class Appointment {
  final int patientID;
  final String doctorName;
  final String hospitalName;
  final String appointmentDate;
  final String appointmentTime;
  final String reason;
  final int appointmentID;
  final String createdAt;

  Appointment({
    required this.patientID,
    required this.doctorName,
    required this.hospitalName,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.reason,
    required this.appointmentID,
    required this.createdAt,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      patientID: json['PatientID'] as int,
      doctorName: json['DoctorName'] as String,
      hospitalName: json['HospitalName'] as String,
      appointmentDate: json['AppointmentDate'] as String,
      appointmentTime: json['AppointmentTime'] as String,
      reason: json['Reason'] as String,
      appointmentID: json['AppointmentID'] as int,
      createdAt: json['CreatedAt'] as String,
    );
  }
}
