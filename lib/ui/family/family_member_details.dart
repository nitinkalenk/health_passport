import 'package:flutter/material.dart';
import 'package:health_passport/models/family_member.dart';
import 'package:health_passport/models/report.dart';
import 'package:health_passport/services/api_service.dart';
import 'package:health_passport/ui/report/report_preview.dart';

class FamilyMemberDetailsScreen extends StatefulWidget {
  final FamilyMember member;

  const FamilyMemberDetailsScreen({super.key, required this.member});

  @override
  State<FamilyMemberDetailsScreen> createState() =>
      _FamilyMemberDetailsScreenState();
}

class _FamilyMemberDetailsScreenState extends State<FamilyMemberDetailsScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Report>> _reportsFuture;

  @override
  void initState() {
    super.initState();
    _reportsFuture = _apiService.fetchReports(patientId: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.member.fullName)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildDetailRow(
                      context,
                      'Date of Birth',
                      widget.member.dateOfBirth,
                    ),
                    _buildDetailRow(
                      context,
                      'Phone Number',
                      widget.member.phoneNumber,
                    ),
                    _buildDetailRow(context, 'Email', widget.member.email),
                    _buildDetailRow(context, 'Address', widget.member.address),
                    const Divider(),
                    _buildDetailRow(context, 'Gender', widget.member.gender),
                    _buildDetailRow(
                      context,
                      'Blood Group',
                      widget.member.bloodGroup,
                    ),
                    const Divider(),
                    _buildDetailRow(
                      context,
                      'Chronic Conditions',
                      widget.member.chronicConditions,
                    ),
                    _buildDetailRow(
                      context,
                      'Allergies',
                      widget.member.allergies,
                    ),
                    const Divider(),
                    _buildDetailRow(
                      context,
                      'Emergency Contact',
                      widget.member.emergencyContactName,
                    ),
                    _buildDetailRow(
                      context,
                      'Emergency Phone',
                      widget.member.emergencyContactNumber,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Documents',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 120, // Height for the horizontal list
              child: FutureBuilder<List<Report>>(
                future: _reportsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final reports = snapshot.data!.reversed.toList();
                    if (reports.isEmpty) {
                      return const Center(child: Text('No reports found.'));
                    }
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: reports.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final report = reports[index];
                        return UnconstrainedBox(
                          child: _buildReportCard(
                            context,
                            icon: report.type == 'bllod'
                                ? Icons.bloodtype
                                : Icons.description,
                            label: report.filename,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ReportPreviewScreen(report: report),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
