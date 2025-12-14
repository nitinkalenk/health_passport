// ignore: avoid_web_libraries_in_flutter
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:health_passport/models/patient.dart';
import 'package:health_passport/models/report.dart';
import 'package:health_passport/models/share_details.dart';
import 'package:health_passport/services/api_service.dart';

class SharesContentScreen extends StatefulWidget {
  final String pin;

  const SharesContentScreen({super.key, required this.pin});

  @override
  State<SharesContentScreen> createState() => _SharesContentScreenState();
}

class _SharesContentScreenState extends State<SharesContentScreen> {
  late Future<ShareDetails> _shareDetailsFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _shareDetailsFuture = _apiService.fetchShareDetails(widget.pin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Passport')),
      body: FutureBuilder<ShareDetails>(
        future: _shareDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final shareDetails = snapshot.data!;
            // Check expiry
            if (DateTime.now().isAfter(
              DateTime.parse(shareDetails.expirationTime),
            )) {
              return const Center(
                child: Text(
                  'This share link has expired.',
                  style: TextStyle(fontSize: 24, color: Colors.red),
                ),
              );
            }

            return _buildContent(shareDetails);
          } else {
            return const Center(child: Text('No data found'));
          }
        },
      ),
    );
  }

  Widget _buildContent(ShareDetails shareDetails) {
    return FutureBuilder<List<Object>>(
      future: Future.wait([
        _apiService.fetchPatient(int.parse(shareDetails.patientId)),
        _apiService.fetchReports(patientId: int.parse(shareDetails.patientId)),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error loading details: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          final patient = snapshot.data![0] as Patient;
          final allReports = snapshot.data![1] as List<Report>;

          // Filter reports based on shared document IDs
          // Ensure ID comparison matches types (String vs Int)
          final sharedReports = allReports.where((r) {
            return shareDetails.documents.contains(r.id.toString());
          }).toList();

          return Row(
            children: [
              // Left Side: Patient Info
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.grey[100],
                  padding: const EdgeInsets.all(24.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Patient Details',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 24),
                        _buildInfoRow('Full Name', patient.fullName),
                        _buildInfoRow('Gender', patient.gender),
                        _buildInfoRow('Date of Birth', patient.dateOfBirth),
                        _buildInfoRow('Blood Group', patient.bloodGroup),
                        _buildInfoRow('Phone', patient.phoneNumber),
                        _buildInfoRow('Email', patient.email),
                        _buildInfoRow('Address', patient.address),
                        _buildInfoRow('Allergies', patient.allergies),
                        _buildInfoRow(
                          'Chronic Conditions',
                          patient.chronicConditions,
                        ),
                        // Explicitly excluding FamilyID and Emergency Contacts
                      ],
                    ),
                  ),
                ),
              ),
              const VerticalDivider(width: 1),
              // Right Side: Shared Documents
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reports / Prescriptions',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 24),
                      if (sharedReports.isEmpty)
                        const Text('No documents shared.')
                      else
                        Expanded(
                          child: ListView.separated(
                            itemCount: sharedReports.length,
                            separatorBuilder: (ctx, i) => const Divider(),
                            itemBuilder: (context, index) {
                              final report = sharedReports[index];
                              return ListTile(
                                leading: const Icon(Icons.description),
                                title: Text(report.filename),
                                subtitle: Text(report.type),
                                trailing: IconButton(
                                  icon: const Icon(Icons.download),
                                  onPressed: () {},
                                ),
                                onTap: () {
                                  context.go(
                                    '/shares/${widget.pin}/preview/${report.id}',
                                  );
                                },
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
