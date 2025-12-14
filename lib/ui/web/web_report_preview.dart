import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:health_passport/models/report.dart';
import 'package:health_passport/models/share_details.dart';
import 'package:health_passport/services/api_service.dart';

class WebReportPreviewScreen extends StatefulWidget {
  final String pin;
  final String reportId;

  const WebReportPreviewScreen({
    super.key,
    required this.pin,
    required this.reportId,
  });

  @override
  State<WebReportPreviewScreen> createState() => _WebReportPreviewScreenState();
}

class _WebReportPreviewScreenState extends State<WebReportPreviewScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didUpdateWidget(covariant WebReportPreviewScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pin != widget.pin || oldWidget.reportId != widget.reportId) {
      _loadData(); // Reload if params change
    }
  }

  void _loadData() {
    _dataFuture = _fetchData();
    setState(() {});
  }

  Future<List<dynamic>> _fetchData() async {
    final shareDetails = await _apiService.fetchShareDetails(widget.pin);
    // Determine patient ID from shareDetails
    final patientId = int.tryParse(shareDetails.patientId) ?? 1;
    final reports = await _apiService.fetchReports(patientId: patientId);
    return [shareDetails, reports];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Document Preview'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/shares/${widget.pin}'),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else if (snapshot.hasData) {
            final shareDetails = snapshot.data![0] as ShareDetails;
            final allReports = snapshot.data![1] as List<Report>;

            return _buildPreview(shareDetails, allReports);
          } else {
            return const Center(
              child: Text(
                'No data found',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildPreview(ShareDetails shareDetails, List<Report> allReports) {
    // 1. Filter reports
    final sharedReports = allReports.where((r) {
      return shareDetails.documents.contains(r.id.toString());
    }).toList();

    // 2. Find current report
    final currentIndex = sharedReports.indexWhere(
      (r) => r.id.toString() == widget.reportId,
    );

    if (currentIndex == -1) {
      return const Center(
        child: Text(
          'Document not found in this share.',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    final currentReport = sharedReports[currentIndex];
    final url = '${ApiService.baseUrl}/download/${currentReport.id}';

    // Check file type
    final ext = currentReport.filename.contains('.')
        ? currentReport.filename.split('.').last.toLowerCase()
        : '';
    final isImage = ['jpg', 'jpeg', 'png'].contains(ext);

    return Stack(
      children: [
        // Content
        Center(
          child: isImage
              ? Image.network(
                  url,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Text(
                    'Failed to load image',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : const Text(
                  'Preview not available for this file type on web yet.',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
        ),

        // Navigation Arrows
        if (currentIndex > 0)
          Positioned(
            left: 20,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 40,
                  color: Colors.white,
                ),
                onPressed: () {
                  final prevId = sharedReports[currentIndex - 1].id;
                  context.go('/shares/${widget.pin}/preview/$prevId');
                },
              ),
            ),
          ),

        if (currentIndex < sharedReports.length - 1)
          Positioned(
            right: 20,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  size: 40,
                  color: Colors.white,
                ),
                onPressed: () {
                  final nextId = sharedReports[currentIndex + 1].id;
                  context.go('/shares/${widget.pin}/preview/$nextId');
                },
              ),
            ),
          ),
      ],
    );
  }
}
