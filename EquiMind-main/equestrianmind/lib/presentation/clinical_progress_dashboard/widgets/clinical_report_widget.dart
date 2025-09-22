import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ClinicalReportWidget extends StatelessWidget {
  final DateTime? lastReport;
  final VoidCallback onGenerateReport;
  final VoidCallback onShareReport;

  const ClinicalReportWidget({
    Key? key,
    this.lastReport,
    required this.onGenerateReport,
    required this.onShareReport,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.assessment,
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Clinical Reports',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Professional documentation for healthcare providers',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Last Report Info
          if (lastReport != null)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              margin: EdgeInsets.only(bottom: 3.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.history,
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Last Report Generated',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          _formatLastReportDate(lastReport!),
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: onShareReport,
                    child: Text('Share'),
                  ),
                ],
              ),
            ),

          // Report Features
          Text(
            'Report Features',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),

          _buildFeatureItem(
            Icons.show_chart,
            'Progress Tracking',
            'Comprehensive charts showing improvement trends across all metrics',
            Colors.blue,
          ),
          _buildFeatureItem(
            Icons.psychology,
            'Clinical Assessment Summary',
            'Validated scale scores with clinical significance analysis',
            Colors.green,
          ),
          _buildFeatureItem(
            Icons.timeline,
            'Treatment Response',
            'Intervention effectiveness and treatment response patterns',
            Colors.purple,
          ),
          _buildFeatureItem(
            Icons.flag,
            'Goal Achievement',
            'Progress toward therapeutic goals with milestone tracking',
            Colors.orange,
          ),
          _buildFeatureItem(
            Icons.warning,
            'Risk Assessment',
            'Current risk level and safety considerations',
            Colors.red,
          ),
          _buildFeatureItem(
            Icons.lightbulb,
            'Recommendations',
            'Evidence-based recommendations for continued care',
            Colors.amber,
          ),

          SizedBox(height: 3.h),

          // Report Types
          Text(
            'Available Report Types',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),

          Row(
            children: [
              Expanded(
                child: _buildReportTypeCard(
                  'Summary Report',
                  'Brief overview for regular check-ins',
                  Icons.summarize,
                  AppTheme.lightTheme.colorScheme.primary,
                  () => _generateReport(context, 'summary'),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildReportTypeCard(
                  'Comprehensive Report',
                  'Detailed analysis for healthcare providers',
                  Icons.assignment,
                  AppTheme.lightTheme.colorScheme.secondary,
                  () => _generateReport(context, 'comprehensive'),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          Row(
            children: [
              Expanded(
                child: _buildReportTypeCard(
                  'Progress Report',
                  'Focus on treatment progress and outcomes',
                  Icons.trending_up,
                  Colors.green,
                  () => _generateReport(context, 'progress'),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildReportTypeCard(
                  'Crisis Assessment',
                  'Risk assessment and safety planning',
                  Icons.emergency,
                  Colors.red,
                  () => _generateReport(context, 'crisis'),
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Professional Standards Note
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  AppTheme.lightTheme.colorScheme.secondary
                      .withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.verified,
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 5.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Professional Standards',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  'All reports are generated following clinical documentation standards and include validated assessment scores, treatment outcomes, and evidence-based recommendations. Reports are suitable for sharing with mental health professionals, physicians, and other healthcare providers.',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Generate Report Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onGenerateReport,
              icon: Icon(Icons.file_download, size: 5.w),
              label: Text('Generate New Report'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(vertical: 2.h),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(
      IconData icon, String title, String description, Color color) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.all(2.w),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 4.w,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  description,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportTypeCard(
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 8.w,
            ),
            SizedBox(height: 1.h),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 0.5.h),
            Text(
              description,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _formatLastReportDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    }
  }

  void _generateReport(BuildContext context, String reportType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Generate ${_capitalize(reportType)} Report'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'This will generate a ${reportType.toLowerCase()} report including:'),
            SizedBox(height: 1.h),
            ..._getReportFeatures(reportType).map((feature) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 0.5.h),
                child: Row(
                  children: [
                    Icon(Icons.check, color: Colors.green, size: 4.w),
                    SizedBox(width: 2.w),
                    Expanded(child: Text(feature)),
                  ],
                ),
              );
            }).toList(),
            SizedBox(height: 2.h),
            Text(
              'The report will be generated in PDF format and can be shared securely with healthcare providers.',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Trigger the report generation
              // This would typically call the parent's onGenerateReport callback
              // with the specific report type
            },
            child: Text('Generate'),
          ),
        ],
      ),
    );
  }

  List<String> _getReportFeatures(String reportType) {
    switch (reportType) {
      case 'summary':
        return [
          'Current assessment scores',
          'Recent progress summary',
          'Key recommendations',
          'Next appointment suggestions',
        ];
      case 'comprehensive':
        return [
          'Complete assessment history',
          'Detailed progress charts',
          'Treatment response analysis',
          'Risk assessment',
          'Clinical recommendations',
          'Intervention effectiveness',
        ];
      case 'progress':
        return [
          'Progress tracking charts',
          'Goal achievement status',
          'Treatment milestones',
          'Outcome predictions',
          'Continued care plan',
        ];
      case 'crisis':
        return [
          'Current risk assessment',
          'Safety planning elements',
          'Crisis intervention history',
          'Emergency contact information',
          'Immediate care recommendations',
        ];
      default:
        return ['Standard clinical documentation'];
    }
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
