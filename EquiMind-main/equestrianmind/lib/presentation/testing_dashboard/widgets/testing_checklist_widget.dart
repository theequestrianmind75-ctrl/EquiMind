import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TestingChecklistWidget extends StatelessWidget {
  final List<Map<String, dynamic>> checklistItems;
  final Function(Map<String, dynamic>) onItemTap;
  final Function(int, String) onUpdateNotes;

  const TestingChecklistWidget({
    Key? key,
    required this.checklistItems,
    required this.onItemTap,
    required this.onUpdateNotes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'checklist_rtl',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Testing Checklist',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Text(
                '${_getCompletedCount()}/${checklistItems.length}',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          LinearProgressIndicator(
            value: _getOverallProgress(),
            backgroundColor:
                AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
            valueColor:
                AlwaysStoppedAnimation<Color>(AppTheme.lightTheme.primaryColor),
          ),
          SizedBox(height: 3.h),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: checklistItems.length,
            itemBuilder: (context, index) {
              final item = checklistItems[index];
              return Container(
                margin: EdgeInsets.only(bottom: 3.h),
                child: _buildChecklistItem(context, item),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(BuildContext context, Map<String, dynamic> item) {
    final status = item['status'] as String;
    final progress = item['progress'] as double;
    final Color statusColor = _getStatusColor(status);
    final IconData statusIcon = _getStatusIcon(status);

    return InkWell(
      onTap: () => onItemTap(item),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: statusColor.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    statusIcon,
                    color: statusColor,
                    size: 20,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'] ?? '',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        item['description'] ?? '',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getStatusText(status),
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Text(
                  'Progress:',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: statusColor.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                  ),
                ),
                SizedBox(width: 2.w),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ],
            ),
            if ((item['notes'] as String).isNotEmpty) ...[
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'note',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        item['notes'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(height: 2.h),
            Row(
              children: [
                if (status == 'in_progress' || status == 'failed') ...[
                  TextButton.icon(
                    onPressed: () => _showNotesDialog(context, item),
                    icon: CustomIconWidget(
                      iconName: 'edit_note',
                      size: 16,
                    ),
                    label: Text('Add Notes'),
                  ),
                  SizedBox(width: 2.w),
                ],
                if (status == 'pending') ...[
                  ElevatedButton.icon(
                    onPressed: () => _startTest(context, item),
                    icon: CustomIconWidget(
                      iconName: 'play_arrow',
                      color: Colors.white,
                      size: 16,
                    ),
                    label: Text('Start Test'),
                  ),
                ] else if (status == 'in_progress') ...[
                  OutlinedButton.icon(
                    onPressed: () => _continueTest(context, item),
                    icon: CustomIconWidget(
                      iconName: 'play_arrow',
                      size: 16,
                    ),
                    label: Text('Continue'),
                  ),
                  SizedBox(width: 2.w),
                  OutlinedButton.icon(
                    onPressed: () => _markComplete(context, item),
                    icon: CustomIconWidget(
                      iconName: 'check',
                      size: 16,
                    ),
                    label: Text('Complete'),
                  ),
                ] else if (status == 'failed') ...[
                  ElevatedButton.icon(
                    onPressed: () => _retryTest(context, item),
                    icon: CustomIconWidget(
                      iconName: 'refresh',
                      color: Colors.white,
                      size: 16,
                    ),
                    label: Text('Retry'),
                  ),
                ] else if (status == 'passed') ...[
                  OutlinedButton.icon(
                    onPressed: () => _viewResults(context, item),
                    icon: CustomIconWidget(
                      iconName: 'visibility',
                      size: 16,
                    ),
                    label: Text('View Results'),
                  ),
                ],
                Spacer(),
                PopupMenuButton<String>(
                  icon: CustomIconWidget(
                    iconName: 'more_vert',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  onSelected: (value) =>
                      _handleMenuAction(context, item, value),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'reset',
                      child: Row(
                        children: [
                          CustomIconWidget(iconName: 'restart_alt', size: 16),
                          SizedBox(width: 2.w),
                          Text('Reset'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'skip',
                      child: Row(
                        children: [
                          CustomIconWidget(iconName: 'skip_next', size: 16),
                          SizedBox(width: 2.w),
                          Text('Skip'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'details',
                      child: Row(
                        children: [
                          CustomIconWidget(iconName: 'info', size: 16),
                          SizedBox(width: 2.w),
                          Text('Details'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'passed':
        return AppTheme.successLight;
      case 'failed':
        return AppTheme.errorLight;
      case 'in_progress':
        return AppTheme.warningLight;
      case 'pending':
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'passed':
        return Icons.check_circle;
      case 'failed':
        return Icons.error;
      case 'in_progress':
        return Icons.timelapse;
      case 'pending':
      default:
        return Icons.radio_button_unchecked;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'passed':
        return 'PASSED';
      case 'failed':
        return 'FAILED';
      case 'in_progress':
        return 'IN PROGRESS';
      case 'pending':
      default:
        return 'PENDING';
    }
  }

  int _getCompletedCount() {
    return checklistItems.where((item) => item['status'] == 'passed').length;
  }

  double _getOverallProgress() {
    if (checklistItems.isEmpty) return 0.0;
    double totalProgress = checklistItems.fold(
        0.0, (sum, item) => sum + (item['progress'] as double));
    return totalProgress / checklistItems.length;
  }

  void _showNotesDialog(BuildContext context, Map<String, dynamic> item) {
    final TextEditingController notesController =
        TextEditingController(text: item['notes']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Testing Notes'),
        content: TextField(
          controller: notesController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Enter notes about this test case...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              onUpdateNotes(item['id'], notesController.text);
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _startTest(BuildContext context, Map<String, dynamic> item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Starting ${item['title']} test...')),
    );
  }

  void _continueTest(BuildContext context, Map<String, dynamic> item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Continuing ${item['title']} test...')),
    );
  }

  void _markComplete(BuildContext context, Map<String, dynamic> item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item['title']} marked as complete')),
    );
  }

  void _retryTest(BuildContext context, Map<String, dynamic> item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Retrying ${item['title']} test...')),
    );
  }

  void _viewResults(BuildContext context, Map<String, dynamic> item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Viewing results for ${item['title']}')),
    );
  }

  void _handleMenuAction(
      BuildContext context, Map<String, dynamic> item, String action) {
    switch (action) {
      case 'reset':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reset ${item['title']} test')),
        );
        break;
      case 'skip':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Skipped ${item['title']} test')),
        );
        break;
      case 'details':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Viewing details for ${item['title']}')),
        );
        break;
    }
  }
}
