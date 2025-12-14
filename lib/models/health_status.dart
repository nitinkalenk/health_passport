class HealthStatus {
  final String parameter;
  final String expectedRange;
  final String value;
  final bool status;

  HealthStatus({
    required this.parameter,
    required this.expectedRange,
    required this.value,
    required this.status,
  });

  factory HealthStatus.fromJson(Map<String, dynamic> json) {
    return HealthStatus(
      parameter: json['parameter'] ?? '',
      expectedRange: json['expectedRange'] ?? '',
      value: json['value'] ?? '',
      status: json['status'] ?? false,
    );
  }
}
