import 'package:flutter/material.dart';
import 'package:health_passport/models/family_member.dart';

class FamilyMemberDetailsScreen extends StatelessWidget {
  final FamilyMember member;

  const FamilyMemberDetailsScreen({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(member.fullName)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildDetailRow(context, 'Date of Birth', member.dateOfBirth),
                _buildDetailRow(context, 'Phone Number', member.phoneNumber),
                _buildDetailRow(context, 'Email', member.email),
                _buildDetailRow(context, 'Address', member.address),
                const Divider(),
                _buildDetailRow(context, 'Gender', member.gender),
                _buildDetailRow(context, 'Blood Group', member.bloodGroup),
                const Divider(),
                _buildDetailRow(
                  context,
                  'Chronic Conditions',
                  member.chronicConditions,
                ),
                _buildDetailRow(context, 'Allergies', member.allergies),
                const Divider(),
                _buildDetailRow(
                  context,
                  'Emergency Contact',
                  member.emergencyContactName,
                ),
                _buildDetailRow(
                  context,
                  'Emergency Phone',
                  member.emergencyContactNumber,
                ),
              ],
            ),
          ),
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
}
