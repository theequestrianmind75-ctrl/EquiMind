import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../theme/app_theme.dart';

class InterventionCardWidget extends StatelessWidget {
  final Map<String, dynamic> intervention;
  final VoidCallback onStart;
  final VoidCallback onBookmark;
  final VoidCallback onShare;

  const InterventionCardWidget({
    super.key,
    required this.intervention,
    required this.onStart,
    required this.onBookmark,
    required this.onShare,
  });

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'CBT':
        return Colors.blue;
      case 'MINDFULNESS':
        return Colors.green;
      case 'EXPOSURE':
        return Colors.orange;
      case 'EQUINE_ASSISTED':
        return Colors.purple;
      default:
        return AppTheme.primaryLight;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'CBT':
        return Icons.psychology_outlined;
      case 'MINDFULNESS':
        return Icons.self_improvement_outlined;
      case 'EXPOSURE':
        return Icons.trending_up_outlined;
      case 'EQUINE_ASSISTED':
        return Icons.pets_outlined;
      default:
        return Icons.healing_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor(intervention['category']);

    return Container(
      margin: EdgeInsets.only(bottom: 4.w),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.w),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with category and actions
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    categoryColor.withValues(alpha: 0.1),
                    categoryColor.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4.w),
                  topRight: Radius.circular(4.w),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: categoryColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2.w),
                    ),
                    child: Icon(
                      _getCategoryIcon(intervention['category']),
                      color: categoryColor,
                      size: 5.w,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          intervention['category'],
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: categoryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          intervention['difficulty'] ?? 'Beginner',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppTheme.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (intervention['audioAvailable'] == true)
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                      decoration: BoxDecoration(
                        color: AppTheme.accentLight.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(1.w),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.volume_up,
                            size: 3.w,
                            color: AppTheme.accentLight,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            'Audio',
                            style: TextStyle(
                              fontSize: 9.sp,
                              color: AppTheme.accentLight,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(width: 2.w),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'bookmark':
                          onBookmark();
                          break;
                        case 'share':
                          onShare();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'bookmark',
                        child: Row(
                          children: [
                            Icon(Icons.bookmark_add),
                            SizedBox(width: 8),
                            Text('Bookmark'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'share',
                        child: Row(
                          children: [
                            Icon(Icons.share),
                            SizedBox(width: 8),
                            Text('Share'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    intervention['title'],
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryLight,
                    ),
                  ),
                  SizedBox(height: 2.w),
                  Text(
                    intervention['description'],
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppTheme.textPrimaryLight,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 3.w),

                  // Metrics Row
                  Row(
                    children: [
                      _buildMetric(
                        Icons.access_time,
                        '${intervention['duration']} min',
                        Colors.blue,
                      ),
                      SizedBox(width: 4.w),
                      _buildMetric(
                        Icons.star,
                        '${intervention['effectiveness']}/5',
                        AppTheme.accentLight,
                      ),
                      if (intervention['professionalGuidance'] == true) ...[
                        SizedBox(width: 4.w),
                        _buildMetric(
                          Icons.verified_user,
                          'Licensed',
                          AppTheme.successLight,
                        ),
                      ],
                    ],
                  ),

                  SizedBox(height: 3.w),

                  // Book Integration
                  if (intervention['bookChapter'] != null)
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.book,
                            color: AppTheme.primaryLight,
                            size: 4.w,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              intervention['bookChapter'],
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: AppTheme.primaryLight,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  SizedBox(height: 3.w),

                  // Steps Preview
                  if (intervention['steps'] != null &&
                      (intervention['steps'] as List).isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Key Steps:',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimaryLight,
                          ),
                        ),
                        SizedBox(height: 1.w),
                        ...(intervention['steps'] as List<String>)
                            .take(3)
                            .map((step) => Padding(
                                  padding: EdgeInsets.only(bottom: 1.w),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 1.5.w,
                                        height: 1.5.w,
                                        margin: EdgeInsets.only(top: 1.5.w),
                                        decoration: BoxDecoration(
                                          color: categoryColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: 2.w),
                                      Expanded(
                                        child: Text(
                                          step,
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            color: AppTheme.textSecondaryLight,
                                            height: 1.3,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                        if ((intervention['steps'] as List).length > 3)
                          Text(
                            '+ ${(intervention['steps'] as List).length - 3} more steps',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppTheme.textSecondaryLight,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),

            // Action Button
            Padding(
              padding: EdgeInsets.all(4.w),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onStart,
                  icon: Icon(Icons.play_arrow),
                  label: Text('Start Intervention'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: categoryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 3.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2.w),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 3.5.w,
          color: color,
        ),
        SizedBox(width: 1.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 10.sp,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
