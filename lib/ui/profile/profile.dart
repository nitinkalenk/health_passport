import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_passport/models/patient.dart';
import 'package:health_passport/providers/patient_provider.dart';
import 'package:health_passport/ui/profile/edit_profile.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientAsyncValue = ref.watch(patientProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              patientAsyncValue.whenData((patient) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(patient: patient),
                  ),
                );
              });
            },
          ),
        ],
      ),
      body: patientAsyncValue.when(
        data: (patient) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileItem('Full Name', patient.fullName),
                _buildProfileItem('Gender', patient.gender),
                _buildProfileItem('Date of Birth', patient.dateOfBirth),
                _buildProfileItem('Blood Group', patient.bloodGroup),
                _buildProfileItem('Phone Number', patient.phoneNumber),
                _buildProfileItem('Email', patient.email),
                _buildProfileItem('Address', patient.address),
                _buildProfileItem('Allergies', patient.allergies),
                _buildProfileItem(
                  'Chronic Conditions',
                  patient.chronicConditions,
                ),
                _buildProfileItem(
                  'Emergency Contact',
                  patient.emergencyContactName,
                ),
                _buildProfileItem(
                  'Emergency Number',
                  patient.emergencyContactNumber,
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
