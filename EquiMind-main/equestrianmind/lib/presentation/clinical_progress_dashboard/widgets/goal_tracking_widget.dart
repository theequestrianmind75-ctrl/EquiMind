import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class GoalTrackingWidget extends StatefulWidget {
  final List<Map<String, dynamic>> goals;
  final Function(String, double) onGoalUpdate;

  const GoalTrackingWidget({
    Key? key,
    required this.goals,
    required this.onGoalUpdate,
  }) : super(key: key);

  @override
  State<GoalTrackingWidget> createState() => _GoalTrackingWidgetState();
}

class _GoalTrackingWidgetState extends State<GoalTrackingWidget> {
  String _selectedFilter = 'all';

  final Map<String, String> _filterOptions = {
    'all': 'All Goals',
    'active': 'Active',
    'completed': 'Completed',
    'overdue': 'Overdue',
  };

  @override
  Widget build(BuildContext context) {
    final filteredGoals = _getFilteredGoals();

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
          // Header with Add Goal Button
          Row(
            children: [
              Icon(
                Icons.flag,
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SMART Goal Tracking',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Specific, Measurable, Achievable, Relevant, Time-bound',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: () => _showAddGoalDialog(),
                icon: Icon(Icons.add, size: 4.w),
                label: Text('Add Goal'),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Filter Options
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filterOptions.entries.map((entry) {
                  final isSelected = _selectedFilter == entry.key;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFilter = entry.key;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.all(1.w),
                      padding: EdgeInsets.symmetric(
                          horizontal: 4.w, vertical: 1.5.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        entry.value,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.onPrimary
                              : AppTheme.lightTheme.colorScheme.onSurface,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Goals Overview Statistics
          _buildGoalsOverview(),

          SizedBox(height: 3.h),

          // Goals List
          if (filteredGoals.isEmpty)
            _buildEmptyState()
          else
            Column(
              children: filteredGoals.map((goal) {
                return _buildGoalCard(goal);
              }).toList(),
            ),

          SizedBox(height: 3.h),

          // Goal Achievement Insights
          _buildAchievementInsights(),
        ],
      ),
    );
  }

  Widget _buildGoalsOverview() {
    final totalGoals = widget.goals.length;
    final completedGoals =
        widget.goals.where((g) => (g['progress'] ?? 0.0) >= 100.0).length;
    final activeGoals =
        widget.goals.where((g) => (g['progress'] ?? 0.0) < 100.0).length;
    final overdueGoals = widget.goals.where((g) => _isOverdue(g)).length;

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
      child: Column(
        children: [
          Text(
            'Goals Overview',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                  child: _buildOverviewStat(
                      'Total', totalGoals.toString(), Colors.blue)),
              Expanded(
                  child: _buildOverviewStat(
                      'Active', activeGoals.toString(), Colors.orange)),
              Expanded(
                  child: _buildOverviewStat(
                      'Completed', completedGoals.toString(), Colors.green)),
              Expanded(
                  child: _buildOverviewStat(
                      'Overdue', overdueGoals.toString(), Colors.red)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
      ],
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
            Icons.flag_outlined,
            size: 12.w,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          SizedBox(height: 2.h),
          Text(
            _getEmptyStateTitle(),
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            _getEmptyStateDescription(),
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          if (_selectedFilter == 'all') ...[
            SizedBox(height: 2.h),
            ElevatedButton.icon(
              onPressed: () => _showAddGoalDialog(),
              icon: Icon(Icons.add),
              label: Text('Create Your First Goal'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGoalCard(Map<String, dynamic> goal) {
    final progress = (goal['progress'] ?? 0.0) as double;
    final isCompleted = progress >= 100.0;
    final isOverdue = _isOverdue(goal);
    final deadline = goal['deadline'] as DateTime?;

    Color statusColor;
    if (isCompleted) {
      statusColor = Colors.green;
    } else if (isOverdue) {
      statusColor = Colors.red;
    } else {
      statusColor = Colors.orange;
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Goal Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isCompleted ? Icons.check_circle : Icons.flag,
                  color: statusColor,
                  size: 5.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal['title'] ?? 'Untitled Goal',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        decoration:
                            isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    Text(
                      goal['type'] ?? 'Goal',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusChip(isCompleted, isOverdue),
            ],
          ),

          SizedBox(height: 2.h),

          // Goal Target
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Target: ${goal['target']}',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Progress Section
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
                      color: statusColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              LinearProgressIndicator(
                value: progress / 100,
                backgroundColor: statusColor.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                minHeight: 0.8.h,
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Deadline Info
          if (deadline != null)
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  color: isOverdue
                      ? Colors.red
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Deadline: ${_formatDeadline(deadline)}',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: isOverdue
                        ? Colors.red
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight: isOverdue ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                if (isOverdue)
                  Text(
                    ' (Overdue)',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),

          SizedBox(height: 2.h),

          // Milestones
          if (goal['milestones'] != null &&
              (goal['milestones'] as List).isNotEmpty)
            _buildMilestones(goal['milestones'] as List<String>),

          SizedBox(height: 2.h),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showGoalDetails(goal),
                  icon: Icon(Icons.info_outline, size: 4.w),
                  label: Text('Details'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: statusColor,
                    side: BorderSide(color: statusColor.withValues(alpha: 0.5)),
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              if (!isCompleted)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showUpdateProgressDialog(goal),
                    icon: Icon(Icons.edit, size: 4.w),
                    label: Text('Update'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: statusColor,
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

  Widget _buildStatusChip(bool isCompleted, bool isOverdue) {
    Color color;
    String text;

    if (isCompleted) {
      color = Colors.green;
      text = 'Completed';
    } else if (isOverdue) {
      color = Colors.red;
      text = 'Overdue';
    } else {
      color = Colors.orange;
      text = 'In Progress';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        text,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildMilestones(List<String> milestones) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Milestones',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Column(
          children: milestones.take(3).map((milestone) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 0.5.h),
              child: Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 2.w,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      milestone,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        if (milestones.length > 3)
          Text(
            '... and ${milestones.length - 3} more',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
      ],
    );
  }

  Widget _buildAchievementInsights() {
    final completedGoals =
        widget.goals.where((g) => (g['progress'] ?? 0.0) >= 100.0).length;
    final totalGoals = widget.goals.length;
    final averageProgress = totalGoals > 0
        ? widget.goals
                .map((g) => g['progress'] ?? 0.0)
                .reduce((a, b) => a + b) /
            totalGoals
        : 0.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.amber.withValues(alpha: 0.1),
            Colors.orange.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.amber.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.insights,
                color: Colors.amber,
                size: 5.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Achievement Insights',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          if (totalGoals > 0) ...[
            Text(
              'You have completed ${completedGoals} out of ${totalGoals} goals (${(completedGoals / totalGoals * 100).toInt()}% completion rate).',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Average progress across all goals: ${averageProgress.toInt()}%',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            if (averageProgress >= 75)
              Text(
                'Excellent goal achievement rate! Keep up the great work.',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              )
            else if (averageProgress >= 50)
              Text(
                'Good progress on your goals. Consider focusing on priority items.',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.orange,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ] else
            Text(
              'Start setting SMART goals to track your progress and achieve your objectives systematically.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredGoals() {
    switch (_selectedFilter) {
      case 'active':
        return widget.goals
            .where((g) => (g['progress'] ?? 0.0) < 100.0 && !_isOverdue(g))
            .toList();
      case 'completed':
        return widget.goals
            .where((g) => (g['progress'] ?? 0.0) >= 100.0)
            .toList();
      case 'overdue':
        return widget.goals.where((g) => _isOverdue(g)).toList();
      case 'all':
      default:
        return widget.goals;
    }
  }

  bool _isOverdue(Map<String, dynamic> goal) {
    final deadline = goal['deadline'] as DateTime?;
    if (deadline == null) return false;
    return DateTime.now().isAfter(deadline) &&
        (goal['progress'] ?? 0.0) < 100.0;
  }

  String _getEmptyStateTitle() {
    switch (_selectedFilter) {
      case 'active':
        return 'No Active Goals';
      case 'completed':
        return 'No Completed Goals';
      case 'overdue':
        return 'No Overdue Goals';
      case 'all':
      default:
        return 'No Goals Set';
    }
  }

  String _getEmptyStateDescription() {
    switch (_selectedFilter) {
      case 'active':
        return 'All your goals are either completed or overdue. Consider setting new goals to continue your progress.';
      case 'completed':
        return 'You haven\'t completed any goals yet. Keep working on your current goals!';
      case 'overdue':
        return 'Great! No goals are overdue. Keep up the excellent time management.';
      case 'all':
      default:
        return 'Set your first SMART goal to begin tracking your therapeutic progress and achievements.';
    }
  }

  String _formatDeadline(DateTime deadline) {
    final now = DateTime.now();
    final difference = deadline.difference(now);

    if (difference.isNegative) {
      final pastDays = now.difference(deadline).inDays;
      if (pastDays == 0) {
        return 'Today (overdue)';
      } else if (pastDays == 1) {
        return 'Yesterday (overdue)';
      } else {
        return '${pastDays} days ago (overdue)';
      }
    } else if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Tomorrow';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days';
    } else {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''}';
    }
  }

  void _showAddGoalDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New SMART Goal'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create a new SMART goal to track your progress:'),
              SizedBox(height: 2.h),
              Text('S - Specific: Clearly defined objective'),
              Text('M - Measurable: Quantifiable progress indicators'),
              Text('A - Achievable: Realistic and attainable'),
              Text('R - Relevant: Aligned with your therapy goals'),
              Text('T - Time-bound: Has a specific deadline'),
              // Add form fields here for goal creation
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Add goal creation logic here
            },
            child: Text('Create Goal'),
          ),
        ],
      ),
    );
  }

  void _showGoalDetails(Map<String, dynamic> goal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(goal['title'] ?? 'Goal Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Type: ${goal['type']}'),
              SizedBox(height: 1.h),
              Text('Target: ${goal['target']}'),
              SizedBox(height: 1.h),
              Text('Progress: ${(goal['progress'] ?? 0.0).toInt()}%'),
              if (goal['deadline'] != null) ...[
                SizedBox(height: 1.h),
                Text('Deadline: ${_formatDeadline(goal['deadline'])}'),
              ],
              if (goal['milestones'] != null) ...[
                SizedBox(height: 2.h),
                Text('Milestones:',
                    style: AppTheme.lightTheme.textTheme.titleSmall),
                ...(goal['milestones'] as List<String>).map((milestone) {
                  return Text('• $milestone');
                }).toList(),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          if ((goal['progress'] ?? 0.0) < 100.0)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showUpdateProgressDialog(goal);
              },
              child: Text('Update Progress'),
            ),
        ],
      ),
    );
  }

  void _showUpdateProgressDialog(Map<String, dynamic> goal) {
    final currentProgress = (goal['progress'] ?? 0.0) as double;
    double newProgress = currentProgress;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Update Progress'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Update progress for: ${goal['title']}'),
              SizedBox(height: 2.h),
              Text('Current Progress: ${currentProgress.toInt()}%'),
              SizedBox(height: 2.h),
              Slider(
                value: newProgress,
                min: currentProgress,
                max: 100,
                divisions: ((100 - currentProgress) / 5).round(),
                label: '${newProgress.toInt()}%',
                onChanged: (value) {
                  setDialogState(() {
                    newProgress = value;
                  });
                },
              ),
              Text('New Progress: ${newProgress.toInt()}%'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                widget.onGoalUpdate(goal['id'], newProgress);
                Navigator.pop(context);
                if (newProgress >= 100.0) {
                  _showCelebrationDialog(goal);
                }
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCelebrationDialog(Map<String, dynamic> goal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.celebration, color: Colors.amber, size: 6.w),
            SizedBox(width: 2.w),
            Expanded(child: Text('Goal Achieved!')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🎉 Congratulations! 🎉'),
            SizedBox(height: 2.h),
            Text('You have successfully completed:'),
            SizedBox(height: 1.h),
            Text(
              goal['title'],
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
                'This is a significant achievement in your therapeutic journey!'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Thank you!'),
          ),
        ],
      ),
    );
  }
}
