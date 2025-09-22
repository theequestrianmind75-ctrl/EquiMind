import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class UpcomingSessionsCard extends StatefulWidget {
  final List<Map<String, dynamic>> upcomingSessions;
  final Function(Map<String, dynamic>)? onSessionTap;
  final Function(Map<String, dynamic>)? onDeleteSession;

  const UpcomingSessionsCard({
    Key? key,
    required this.upcomingSessions,
    this.onSessionTap,
    this.onDeleteSession,
  }) : super(key: key);

  @override
  State<UpcomingSessionsCard> createState() => _UpcomingSessionsCardState();
}

class _UpcomingSessionsCardState extends State<UpcomingSessionsCard> {
  String selectedFilter = 'All Sessions';

  final List<String> filterOptions = [
    'All Sessions',
    'Today Only',
    'This Week',
    'Training Sessions',
    'Coaching Sessions',
    'Assessments',
  ];

  List<Map<String, dynamic>> get filteredSessions {
    if (selectedFilter == 'All Sessions') {
      return widget.upcomingSessions;
    }

    final now = DateTime.now();

    switch (selectedFilter) {
      case 'Today Only':
        return widget.upcomingSessions.where((session) {
          try {
            final sessionDate =
                DateTime.parse(session['scheduledFor'] as String? ?? '');
            return sessionDate.day == now.day &&
                sessionDate.month == now.month &&
                sessionDate.year == now.year;
          } catch (e) {
            return false;
          }
        }).toList();

      case 'This Week':
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final endOfWeek = startOfWeek.add(Duration(days: 6));
        return widget.upcomingSessions.where((session) {
          try {
            final sessionDate =
                DateTime.parse(session['scheduledFor'] as String? ?? '');
            return sessionDate.isAfter(startOfWeek) &&
                sessionDate.isBefore(endOfWeek);
          } catch (e) {
            return false;
          }
        }).toList();

      case 'Training Sessions':
        return widget.upcomingSessions
            .where((session) =>
                (session['type'] as String? ?? '').toLowerCase() == 'training')
            .toList();

      case 'Coaching Sessions':
        return widget.upcomingSessions
            .where((session) =>
                (session['type'] as String? ?? '').toLowerCase() == 'coaching')
            .toList();

      case 'Assessments':
        return widget.upcomingSessions
            .where((session) =>
                (session['type'] as String? ?? '').toLowerCase() ==
                'assessment')
            .toList();

      default:
        return widget.upcomingSessions;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'schedule',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedFilter,
                      isExpanded: true,
                      icon: CustomIconWidget(
                        iconName: 'arrow_drop_down',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 24,
                      ),
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedFilter = newValue ?? 'All Sessions';
                        });
                      },
                      items: filterOptions
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            filteredSessions.isEmpty
                ? _buildEmptyState()
                : Column(
                    children: filteredSessions.take(3).map((session) {
                      return _buildSessionItem(context, session);
                    }).toList(),
                  ),
            if (filteredSessions.length > 3)
              Container(
                margin: EdgeInsets.only(top: 1.h),
                child: TextButton(
                  onPressed: () {
                    _showAllSessions(context);
                  },
                  child: Text(
                    'View All ${filteredSessions.length} Sessions',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showAllSessions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                '$selectedFilter (${filteredSessions.length})',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: filteredSessions.length,
                  itemBuilder: (context, index) {
                    return _buildSessionItem(context, filteredSessions[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSessionItem(BuildContext context, Map<String, dynamic> session) {
    return Dismissible(
      key: Key((session['id'] as int? ?? 0).toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.error,
          borderRadius: BorderRadius.circular(12),
        ),
        child: CustomIconWidget(
          iconName: 'delete',
          color: AppTheme.lightTheme.colorScheme.onError,
          size: 24,
        ),
      ),
      onDismissed: (direction) {
        widget.onDeleteSession?.call(session);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        child: InkWell(
          onTap: () => widget.onSessionTap?.call(session),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color:
                        _getSessionTypeColor(session['type'] as String? ?? '')
                            .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName:
                          _getSessionTypeIcon(session['type'] as String? ?? ''),
                      color: _getSessionTypeColor(
                          session['type'] as String? ?? ''),
                      size: 20,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (session['title'] as String?) ?? 'Coaching Session',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        (session['description'] as String?) ??
                            'Personalized coaching session',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'access_time',
                            color: AppTheme.lightTheme.colorScheme.secondary,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            (session['time'] as String?) ?? '10:00 AM',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.secondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          CustomIconWidget(
                            iconName: 'timer',
                            color: AppTheme.lightTheme.colorScheme.tertiary,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            (session['duration'] as String?) ?? '60 min',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.tertiary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getCountdownText(
                            session['scheduledFor'] as String? ?? ''),
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'event_available',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            selectedFilter == 'All Sessions'
                ? 'No Upcoming Sessions'
                : 'No $selectedFilter Found',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            selectedFilter == 'All Sessions'
                ? 'Schedule your next coaching session'
                : 'Try selecting a different filter option',
            textAlign: TextAlign.center,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Color _getSessionTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'coaching':
        return AppTheme.lightTheme.primaryColor;
      case 'training':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'assessment':
        return AppTheme.lightTheme.colorScheme.tertiary;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  String _getSessionTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'coaching':
        return 'psychology';
      case 'training':
        return 'fitness_center';
      case 'assessment':
        return 'assessment';
      default:
        return 'event';
    }
  }

  String _getCountdownText(String scheduledFor) {
    try {
      final scheduledDate = DateTime.parse(scheduledFor);
      final now = DateTime.now();
      final difference = scheduledDate.difference(now);

      if (difference.inDays > 0) {
        return '${difference.inDays}d';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m';
      } else {
        return 'Now';
      }
    } catch (e) {
      return 'Soon';
    }
  }
}
