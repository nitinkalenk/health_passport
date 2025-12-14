import 'package:flutter/material.dart';
import 'package:health_passport/models/patient.dart';

class EditProfileScreen extends StatefulWidget {
  final Patient patient;

  const EditProfileScreen({super.key, required this.patient});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _fullNameController;
  late TextEditingController _genderController;
  late TextEditingController _dobController;
  late TextEditingController _bloodGroupController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _allergiesController;
  late TextEditingController _chronicController;
  late TextEditingController _emergencyNameController;
  late TextEditingController _emergencyNumberController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.patient.fullName);
    _genderController = TextEditingController(text: widget.patient.gender);
    _dobController = TextEditingController(text: widget.patient.dateOfBirth);
    _bloodGroupController = TextEditingController(
      text: widget.patient.bloodGroup,
    );
    _phoneController = TextEditingController(text: widget.patient.phoneNumber);
    _emailController = TextEditingController(text: widget.patient.email);
    _addressController = TextEditingController(text: widget.patient.address);
    _allergiesController = TextEditingController(
      text: widget.patient.allergies,
    );
    _chronicController = TextEditingController(
      text: widget.patient.chronicConditions,
    );
    _emergencyNameController = TextEditingController(
      text: widget.patient.emergencyContactName,
    );
    _emergencyNumberController = TextEditingController(
      text: widget.patient.emergencyContactNumber,
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _genderController.dispose();
    _dobController.dispose();
    _bloodGroupController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _allergiesController.dispose();
    _chronicController.dispose();
    _emergencyNameController.dispose();
    _emergencyNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField('Full Name', _fullNameController),
              _buildTextField('Gender', _genderController),
              _buildTextField('Date of Birth', _dobController),
              _buildTextField('Blood Group', _bloodGroupController),
              _buildTextField('Phone Number', _phoneController),
              _buildTextField('Email', _emailController),
              _buildTextField('Address', _addressController),
              _buildTextField('Allergies', _allergiesController),
              _buildTextField('Chronic Conditions', _chronicController),
              _buildTextField(
                'Emergency Contact Name',
                _emergencyNameController,
              ),
              _buildTextField(
                'Emergency Contact Number',
                _emergencyNumberController,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Logic to save profile (Placeholder)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile update logic placeholder'),
                      ),
                    );
                  },
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
