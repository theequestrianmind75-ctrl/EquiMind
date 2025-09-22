import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class InterventionTrackingWidget extends StatefulWidget {
  final List<Map<String, dynamic>> activeInterventions;
  final Function(Map<String, dynamic>) onInterventionSelected;

  const InterventionTrackingWidget({
    Key? key,
    required this.activeInterventions,
    required this.onInterventionSelected,
  }) : super(key: key);

  @override
  State<InterventionTrackingWidget> createState() =>
      _InterventionTrackingWidgetState();
}

class _InterventionTrackingWidgetState
    extends State<InterventionTrackingWidget> {
  final Map<String, Map<String, dynamic>> _interventionTypes = {
    'CBT': {
      'name': 'Cognitive Behavioral Therapy',
      'description':
          'Evidence-based approach focusing on thought patterns and behaviors',
      'color': Colors.blue,
      'icon': Icons.psychology_alt,
      'techniques': [
        'Cognitive restructuring',
        'Behavioral activation',
        'Exposure therapy'
      ],
    },
    'MBSR': {
      'name': 'Mindfulness-Based Stress Reduction',
      'description':
          'Meditation and mindfulness practices for stress management',
      'color': Colors.green,
      'icon': Icons.self_improvement,
      'techniques': [
        'Body scan meditation',
        'Breathing exercises',
        'Mindful movement'
      ],
    },
    'EMDR': {
      'name': 'Eye Movement Desensitization and Reprocessing',
      'description': 'Trauma-focused psychotherapy using bilateral stimulation',
      'color': Colors.purple,
      'icon': Icons.visibility,
      'techniques': [
        'Bilateral stimulation',
        'Resource installation',
        'Safe place visualization'
      ],
    },
    'DBT': {
      'name': 'Dialectical Behavior Therapy',
      'description':
          'Skills-based therapy for emotional regulation and distress tolerance',
      'color': Colors.orange,
      'icon': Icons.balance,
      'techniques': [
        'Distress tolerance',
        'Emotion regulation',
        'Interpersonal effectiveness'
      ],
    },
    'ACT': {
      'name': 'Acceptance and Commitment Therapy',
      'description':
          'Values-based approach focusing on psychological flexibility',
      'color': Colors.teal,
      'icon': Icons.open_in_full,
      'techniques': ['Values clarification', 'Mindfulness', 'Committed action'],
    },
  };

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
                Icons.timeline,
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Active Interventions',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Evidence-based therapeutic approaches',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: () => _showAddInterventionDialog(),
                icon: Icon(Icons.add, size: 4.w),
                label: Text('Add'),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Active Interventions List
          if (widget.activeInterventions.isEmpty)
            _buildEmptyState()
          else
            Column(
              children: widget.activeInterventions.map((intervention) {
                return _buildInterventionCard(intervention);
              }).toList(),
            ),

          SizedBox(height: 3.h),

          // Effectiveness Summary
          _buildEffectivenessSummary(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.psychology_outlined,
            size: 12.w,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          SizedBox(height: 2.h),
          Text(
            'No Active Interventions',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Start tracking evidence-based therapeutic interventions to monitor their effectiveness over time.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInterventionCard(Map<String, dynamic> intervention) {
    final interventionType = _interventionTypes[intervention['type']] ?? {};
    final progress = (intervention['progress'] ?? 0.0) as double;
    final effectiveness = intervention['effectiveness'] ?? 'unknown';

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              (interventionType['color'] as Color?)?.withValues(alpha: 0.3) ??
                  Colors.grey.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: (interventionType['color'] as Color?)
                          ?.withValues(alpha: 0.1) ??
                      Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  interventionType['icon'] ?? Icons.psychology,
                  color: interventionType['color'] ?? Colors.grey,
                  size: 5.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      intervention['name'] ?? 'Unknown Intervention',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    if (interventionType['description'] != null)
                      Text(
                        interventionType['description'],
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              _buildEffectivenessChip(effectiveness),
            ],
          ),

          SizedBox(height: 2.h),

          // Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    '${progress.toInt()}%',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: interventionType['color'] ??
                          AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              LinearProgressIndicator(
                value: progress / 100,
                backgroundColor: (interventionType['color'] as Color?)
                        ?.withValues(alpha: 0.2) ??
                    Colors.grey.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                  interventionType['color'] ??
                      AppTheme.lightTheme.colorScheme.primary,
                ),
                minHeight: 0.8.h,
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Intervention Details
          Row(
            children: [
              Expanded(
                child: _buildDetailChip(
                  'Duration',
                  '${intervention['duration']} weeks',
                  Icons.schedule,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildDetailChip(
                  'Sessions',
                  '${(progress * (intervention['duration'] ?? 1) / 100).ceil()}/${intervention['duration']}',
                  Icons.event_note,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => widget.onInterventionSelected(intervention),
                  icon: Icon(Icons.info_outline, size: 4.w),
                  label: Text('Details'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: interventionType['color'] ??
                        AppTheme.lightTheme.colorScheme.primary,
                    side: BorderSide(
                      color: (interventionType['color'] as Color?)
                              ?.withValues(alpha: 0.5) ??
                          AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showProgressUpdateDialog(intervention),
                  icon: Icon(Icons.update, size: 4.w),
                  label: Text('Update'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: interventionType['color'] ??
                        AppTheme.lightTheme.colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEffectivenessChip(String effectiveness) {
    Color chipColor;
    String chipText;

    switch (effectiveness.toLowerCase()) {
      case 'high':
        chipColor = Colors.green;
        chipText = 'High';
        break;
      case 'medium':
        chipColor = Colors.orange;
        chipText = 'Medium';
        break;
      case 'low':
        chipColor = Colors.red;
        chipText = 'Low';
        break;
      default:
        chipColor = Colors.grey;
        chipText = 'Unknown';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: chipColor.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        chipText,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: chipColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDetailChip(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 4.w,
          ),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEffectivenessSummary() {
    if (widget.activeInterventions.isEmpty) return SizedBox.shrink();

    final highEffectiveness = widget.activeInterventions
        .where((i) => i['effectiveness'] == 'high')
        .length;
    final totalInterventions = widget.activeInterventions.length;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.insights,
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 5.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Treatment Effectiveness',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  '$highEffectiveness of $totalInterventions interventions showing high effectiveness',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddInterventionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Intervention'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select an evidence-based intervention to begin tracking:'),
            SizedBox(height: 2.h),
            ..._interventionTypes.entries.map((entry) {
              return ListTile(
                leading: Icon(entry.value['icon'], color: entry.value['color']),
                title: Text(entry.value['name']),
                subtitle: Text(entry.value['description']),
                onTap: () {
                  Navigator.pop(context);
                  // Add intervention logic here
                },
              );
            }).toList(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showProgressUpdateDialog(Map<String, dynamic> intervention) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Progress'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Update progress for ${intervention['name']}:'),
            SizedBox(height: 2.h),
            Text('Current Progress: ${intervention['progress']}%'),
            // Add slider or input for updating progress
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
              // Update progress logic here
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }
}
