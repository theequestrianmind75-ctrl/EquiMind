import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class RiskMonitoringWidget extends StatelessWidget {
  final String riskLevel;
  final DateTime? lastAssessment;
  final List<String> recommendations;

  const RiskMonitoringWidget({
    Key? key,
    required this.riskLevel,
    this.lastAssessment,
    required this.recommendations,
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
                Icons.security,
                color: _getRiskColor(riskLevel),
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Risk Monitoring',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Automated safety assessment and monitoring',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.w),
                decoration: BoxDecoration(
                  color: _getRiskColor(riskLevel).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _getRiskColor(riskLevel).withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  '${_formatRiskLevel(riskLevel)} Risk',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: _getRiskColor(riskLevel),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Risk Level Indicator
          _buildRiskIndicator(),

          SizedBox(height: 3.h),

          // Risk Factors Assessment
          Text(
            'Risk Factors Assessment',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),

          _buildRiskFactorsList(),

          SizedBox(height: 3.h),

          // Protective Factors
          Text(
            'Protective Factors',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),

          _buildProtectiveFactorsList(),

          SizedBox(height: 3.h),

          // Recommendations
          if (recommendations.isNotEmpty) ...[
            Text(
              'Safety Recommendations',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 2.h),
            Column(
              children: recommendations.map((recommendation) {
                return _buildRecommendationItem(recommendation);
              }).toList(),
            ),
            SizedBox(height: 3.h),
          ],

          // Emergency Support Section
          _buildEmergencySupport(),

          SizedBox(height: 3.h),

          // Last Assessment Info
          if (lastAssessment != null)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.schedule,
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 4.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Last assessment: ${_formatAssessmentDate(lastAssessment!)}',
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

  Widget _buildRiskIndicator() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getRiskColor(riskLevel).withValues(alpha: 0.1),
            _getRiskColor(riskLevel).withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getRiskColor(riskLevel).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                _getRiskIcon(riskLevel),
                color: _getRiskColor(riskLevel),
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Risk Level: ${_formatRiskLevel(riskLevel)}',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: _getRiskColor(riskLevel),
                      ),
                    ),
                    Text(
                      _getRiskDescription(riskLevel),
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildRiskLevelBar(),
        ],
      ),
    );
  }

  Widget _buildRiskLevelBar() {
    final riskValue = _getRiskValue(riskLevel);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Low',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Moderate',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: Colors.orange,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'High',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        LinearProgressIndicator(
          value: riskValue / 100,
          backgroundColor: Colors.grey.withValues(alpha: 0.2),
          valueColor: AlwaysStoppedAnimation<Color>(_getRiskColor(riskLevel)),
          minHeight: 1.h,
        ),
      ],
    );
  }

  Widget _buildRiskFactorsList() {
    final riskFactors = _getRiskFactors(riskLevel);

    if (riskFactors.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.green.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                'No significant risk factors identified',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: riskFactors.map((factor) {
        return _buildRiskFactorItem(
          factor['factor'],
          factor['severity'],
          factor['description'],
        );
      }).toList(),
    );
  }

  Widget _buildRiskFactorItem(
      String factor, String severity, String description) {
    Color severityColor = _getSeverityColor(severity);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: severityColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: severityColor.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning,
            color: severityColor,
            size: 4.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        factor,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.w),
                      decoration: BoxDecoration(
                        color: severityColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        severity.toUpperCase(),
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: severityColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
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

  Widget _buildProtectiveFactorsList() {
    final protectiveFactors = _getProtectiveFactors();

    return Column(
      children: protectiveFactors.map((factor) {
        return Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 1.h),
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.green.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.shield,
                color: Colors.green,
                size: 4.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      factor['factor'],
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      factor['description'],
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
      }).toList(),
    );
  }

  Widget _buildRecommendationItem(String recommendation) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb,
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 4.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              recommendation,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencySupport() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.red.withValues(alpha: 0.1),
            Colors.orange.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.red.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.emergency,
                color: Colors.red,
                size: 5.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Emergency Support',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'If you are experiencing thoughts of self-harm or suicide, please reach out for help immediately:',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          _buildEmergencyContactItem(
              'National Suicide Prevention Lifeline', '988'),
          _buildEmergencyContactItem('Crisis Text Line', 'Text HOME to 741741'),
          _buildEmergencyContactItem('Emergency Services', '911'),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // Open emergency support modal or navigate to emergency resources
              },
              icon: Icon(Icons.phone, size: 4.w),
              label: Text('Access Emergency Resources'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContactItem(String service, String contact) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        children: [
          Icon(
            Icons.phone,
            color: Colors.red,
            size: 4.w,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              '$service: $contact',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getRiskColor(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
      case 'moderate':
        return Colors.orange;
      case 'low':
      default:
        return Colors.green;
    }
  }

  IconData _getRiskIcon(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'high':
        return Icons.dangerous;
      case 'medium':
      case 'moderate':
        return Icons.warning;
      case 'low':
      default:
        return Icons.check_circle;
    }
  }

  String _formatRiskLevel(String riskLevel) {
    return riskLevel[0].toUpperCase() + riskLevel.substring(1).toLowerCase();
  }

  String _getRiskDescription(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'high':
        return 'Requires immediate attention and increased monitoring';
      case 'medium':
      case 'moderate':
        return 'Regular monitoring recommended with preventive measures';
      case 'low':
      default:
        return 'Maintaining good progress with minimal safety concerns';
    }
  }

  double _getRiskValue(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'high':
        return 85.0;
      case 'medium':
      case 'moderate':
        return 50.0;
      case 'low':
      default:
        return 15.0;
    }
  }

  List<Map<String, dynamic>> _getRiskFactors(String riskLevel) {
    if (riskLevel.toLowerCase() == 'low') {
      return [];
    }

    return [
      {
        'factor': 'Elevated Anxiety Scores',
        'severity': riskLevel.toLowerCase() == 'high' ? 'high' : 'moderate',
        'description':
            'GAD-7 scores indicate significant anxiety symptoms requiring attention',
      },
      if (riskLevel.toLowerCase() == 'high')
        {
          'factor': 'Social Isolation',
          'severity': 'moderate',
          'description':
              'Reduced social support and increased isolation from activities',
        },
      {
        'factor': 'Competition Stress',
        'severity': 'moderate',
        'description':
            'Upcoming competition causing increased stress and performance anxiety',
      },
    ];
  }

  List<Map<String, dynamic>> _getProtectiveFactors() {
    return [
      {
        'factor': 'Active Treatment Engagement',
        'description':
            'Consistently participating in therapeutic interventions',
      },
      {
        'factor': 'Strong Support Network',
        'description':
            'Family, friends, and riding community providing emotional support',
      },
      {
        'factor': 'Regular Exercise',
        'description':
            'Maintaining physical activity through riding and other exercises',
      },
      {
        'factor': 'Coping Skills Development',
        'description': 'Learning and applying evidence-based coping strategies',
      },
    ];
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'moderate':
        return Colors.orange;
      case 'low':
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }

  String _formatAssessmentDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    }
  }
}
