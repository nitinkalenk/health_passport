import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:health_passport/models/report.dart';
import 'package:health_passport/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ReportPreviewScreen extends StatefulWidget {
  final Report report;

  const ReportPreviewScreen({super.key, required this.report});

  @override
  State<ReportPreviewScreen> createState() => _ReportPreviewScreenState();
}

class _ReportPreviewScreenState extends State<ReportPreviewScreen> {
  String? _localPath;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDocument();
  }

  Future<void> _loadDocument() async {
    try {
      final url = '${ApiService.baseUrl}/download/${widget.report.id}';

      // Determine file extension from filename or default to nothing
      final ext = widget.report.filename.contains('.')
          ? widget.report.filename.split('.').last.toLowerCase()
          : '';

      // If it's an image, we might not need to download it for preview IF we use Image.network
      // But for consistency and simplicity in handling errors/auth/custom endpoints, let's download
      // Or if it's an image, Image.network is definitely faster/cacched.

      final isImage = ['jpg', 'jpeg', 'png'].contains(ext);

      if (isImage) {
        // We will just use Image.network in build, no need to download to file here
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // For PDF (or others), we must download
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/${widget.report.filename}');

        await file.writeAsBytes(bytes);

        setState(() {
          _localPath = file.path;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to download file');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ext = widget.report.filename.contains('.')
        ? widget.report.filename.split('.').last.toLowerCase()
        : '';
    final isImage = ['jpg', 'jpeg', 'png'].contains(ext);
    final url = '${ApiService.baseUrl}/download/${widget.report.id}';

    return Scaffold(
      appBar: AppBar(title: Text(widget.report.filename)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text('Error: $_error'))
          : isImage
          ? Center(
              child: Image.network(
                url,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Text('Failed to load image'));
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
            )
          : _localPath != null
          ? PDFView(
              filePath: _localPath!,
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: false,
              pageFling: false,
            )
          : const Center(child: Text('Unsupported file type')),
    );
  }
}
