import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:health_passport/services/api_service.dart';

class DocumentItem {
  String type;
  File? file;

  DocumentItem({this.type = 'Prescription', this.file});
}

class CloseAppointmentScreen extends StatefulWidget {
  const CloseAppointmentScreen({super.key});

  @override
  State<CloseAppointmentScreen> createState() => _CloseAppointmentScreenState();
}

class _CloseAppointmentScreenState extends State<CloseAppointmentScreen> {
  final List<DocumentItem> _documents = [DocumentItem()];
  final ApiService _apiService = ApiService();
  bool _isUploading = false;

  void _addDocument() {
    setState(() {
      _documents.add(DocumentItem());
    });
  }

  void _removeDocument(int index) {
    setState(() {
      _documents.removeAt(index);
    });
  }

  Future<void> _pickFile(int index) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _documents[index].file = File(result.files.single.path!);
      });
    }
  }

  Future<void> _closeAppointment() async {
    // Validate that all items have a file selected
    if (_documents.any((doc) => doc.file == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a file for all documents')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // iterate and upload each
      for (var doc in _documents) {
        await _apiService.uploadDocument(
          doc.file!,
          doc.type,
          1,
        ); // Patient ID 1 hardcoded
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Appointment closed successfully')),
        );
        // Navigate all the way back home
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error closing appointment: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Close Appointment')),
      body: _isUploading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _documents.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final doc = _documents[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Document ${index + 1}',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  if (_documents.length > 1)
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () => _removeDocument(index),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                value: doc.type,
                                items: ['Prescription', 'Blood Report', 'Other']
                                    .map(
                                      (type) => DropdownMenuItem(
                                        value: type,
                                        child: Text(type),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    doc.type = value!;
                                  });
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Document Type',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 16),
                              InkWell(
                                onTap: () => _pickFile(index),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.attach_file),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          doc.file != null
                                              ? doc.file!.path
                                                    .split(
                                                      Platform.pathSeparator,
                                                    )
                                                    .last
                                              : 'Select Document',
                                          style: TextStyle(
                                            color: doc.file != null
                                                ? Colors.black
                                                : Colors.grey,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      OutlinedButton.icon(
                        onPressed: _addDocument,
                        icon: const Icon(Icons.add),
                        label: const Text('Add Another Document'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _closeAppointment,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onPrimary,
                        ),
                        child: const Text('Close Appointment'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
