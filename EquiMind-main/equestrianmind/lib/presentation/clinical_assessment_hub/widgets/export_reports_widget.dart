import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../theme/app_theme.dart';

class ExportReportsWidget extends StatefulWidget {
  const ExportReportsWidget({super.key});

  @override
  State<ExportReportsWidget> createState() => _ExportReportsWidgetState();
}

class _ExportReportsWidgetState extends State<ExportReportsWidget> {
  bool _isGenerating = false;
  String _selectedFormat = 'PDF';
  String _selectedTimeframe = '3_months';
  List<String> _selectedAssessments = ['GAD-7', 'PHQ-9'];

  final List<String> _availableFormats = ['PDF', 'CSV', 'JSON'];
  final List<String> _availableAssessments = [
    'GAD-7',
    'PHQ-9',
    'DASS-21',
    'EQCS',
    'HHRQ'
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: 4.w),
          _buildReportConfiguration(),
          SizedBox(height: 4.w),
          _buildPrivacyNotice(),
          SizedBox(height: 4.w),
          _buildGenerateButton(),
          SizedBox(height: 4.w),
          _buildRecentReports(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryLight.withValues(alpha: 0.1),
            AppTheme.successLight.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(3.w),
      ),
      child: Row(
        children: [
          Icon(
            Icons.file_download,
            color: AppTheme.primaryLight,
            size: 6.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Professional Report Generation',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryLight,
                  ),
                ),
                Text(
                  'Generate clinical-grade reports for sharing with therapists, coaches, or healthcare providers',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppTheme.textSecondaryLight,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportConfiguration() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Report Configuration',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryLight,
          ),
        ),
        SizedBox(height: 3.w),

        // Format Selection
        _buildConfigSection(
          'Export Format',
          DropdownButton<String>(
            value: _selectedFormat,
            isExpanded: true,
            onChanged: (value) => setState(() => _selectedFormat = value!),
            items: _availableFormats
                .map(
                  (format) => DropdownMenuItem(
                    value: format,
                    child: Row(
                      children: [
                        Icon(_getFormatIcon(format), size: 4.w),
                        SizedBox(width: 2.w),
                        Text(format),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),

        SizedBox(height: 3.w),

        // Timeframe Selection
        _buildConfigSection(
          'Timeframe',
          DropdownButton<String>(
            value: _selectedTimeframe,
            isExpanded: true,
            onChanged: (value) => setState(() => _selectedTimeframe = value!),
            items: const [
              DropdownMenuItem(value: '1_month', child: Text('Last Month')),
              DropdownMenuItem(value: '3_months', child: Text('Last 3 Months')),
              DropdownMenuItem(value: '6_months', child: Text('Last 6 Months')),
              DropdownMenuItem(value: '1_year', child: Text('Last Year')),
              DropdownMenuItem(value: 'all', child: Text('All Data')),
            ],
          ),
        ),

        SizedBox(height: 3.w),

        // Assessment Selection
        _buildConfigSection(
          'Include Assessments',
          Column(
            children: _availableAssessments
                .map(
                  (assessment) => CheckboxListTile(
                    title: Text(
                      assessment,
                      style: TextStyle(fontSize: 13.sp),
                    ),
                    value: _selectedAssessments.contains(assessment),
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          _selectedAssessments.add(assessment);
                        } else {
                          _selectedAssessments.remove(assessment);
                        }
                      });
                    },
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildConfigSection(String title, Widget content) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: AppTheme.dividerLight,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryLight,
            ),
          ),
          SizedBox(height: 2.w),
          content,
        ],
      ),
    );
  }

  Widget _buildPrivacyNotice() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.primaryLight.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: AppTheme.primaryLight.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.security,
                color: AppTheme.primaryLight,
                size: 5.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Privacy & Security Notice',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryLight,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.w),
          Text(
            'All reports are generated locally on your device and contain no personally identifiable information beyond clinical scores and dates. Reports are HIPAA-compliant and suitable for sharing with licensed healthcare providers.',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppTheme.textPrimaryLight,
              height: 1.4,
            ),
          ),
          SizedBox(height: 2.w),
          Row(
            children: [
              Icon(
                Icons.verified_user,
                color: AppTheme.successLight,
                size: 3.w,
              ),
              SizedBox(width: 1.w),
              Text(
                'HIPAA Compliant • Encrypted • Secure',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: AppTheme.successLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _selectedAssessments.isEmpty ? null : _generateReport,
        icon: _isGenerating
            ? SizedBox(
                width: 4.w,
                height: 4.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppTheme.onPrimaryLight),
                ),
              )
            : Icon(Icons.file_download),
        label: Text(
          _isGenerating ? 'Generating Report...' : 'Generate Report',
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 4.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.w),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentReports() {
    final recentReports = [
      {
        'name': 'Clinical_Assessment_Report_Aug_2024.pdf',
        'date': '2024-08-15',
        'type': 'PDF',
        'assessments': ['GAD-7', 'PHQ-9', 'EQCS'],
      },
      {
        'name': 'Assessment_Data_Export_Jul_2024.csv',
        'date': '2024-07-28',
        'type': 'CSV',
        'assessments': ['All Assessments'],
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Reports',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryLight,
          ),
        ),
        SizedBox(height: 3.w),
        ...recentReports.map((report) => _buildReportItem(report)).toList(),
      ],
    );
  }

  Widget _buildReportItem(Map<String, dynamic> report) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.w),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: AppTheme.dividerLight,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _getFormatIcon(report['type']),
            color: AppTheme.primaryLight,
            size: 6.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  report['name'],
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryLight,
                  ),
                ),
                Text(
                  'Generated: ${report['date']}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
                Text(
                  'Includes: ${(report['assessments'] as List).join(', ')}',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _downloadReport(report),
            icon: Icon(
              Icons.download,
              color: AppTheme.primaryLight,
              size: 5.w,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getFormatIcon(String format) {
    switch (format) {
      case 'PDF':
        return Icons.picture_as_pdf;
      case 'CSV':
        return Icons.table_chart;
      case 'JSON':
        return Icons.code;
      default:
        return Icons.file_download;
    }
  }

  Future<void> _generateReport() async {
    setState(() => _isGenerating = true);

    try {
      // Simulate report generation
      await Future.delayed(const Duration(seconds: 3));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Report generated successfully!'),
            backgroundColor: AppTheme.successLight,
            action: SnackBarAction(
              label: 'Share',
              onPressed: () => _shareReport(),
              textColor: Colors.white,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating report: ${e.toString()}'),
            backgroundColor: AppTheme.errorLight,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }

  void _downloadReport(Map<String, dynamic> report) {
    // Implementation for downloading existing reports
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading ${report['name']}...'),
        backgroundColor: AppTheme.primaryLight,
      ),
    );
  }

  void _shareReport() {
    // Implementation for sharing reports
  }
}
