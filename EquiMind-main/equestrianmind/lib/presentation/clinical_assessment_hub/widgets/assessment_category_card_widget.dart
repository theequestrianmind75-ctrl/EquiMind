import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../theme/app_theme.dart';

class AssessmentCategoryCardWidget extends StatelessWidget {
  final Map<String, dynamic> category;
  final VoidCallback onTap;
  final bool isLoading;

  const AssessmentCategoryCardWidget({
    super.key,
    required this.category,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.w),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3.w),
        ),
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(3.w),
          child: Container(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color:
                            (category['color'] as Color).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                      child: Icon(
                        category['icon'] as IconData,
                        color: category['color'] as Color,
                        size: 6.w,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category['name'],
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimaryLight,
                            ),
                          ),
                          Text(
                            category['type'],
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppTheme.textSecondaryLight,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isLoading)
                      SizedBox(
                        width: 5.w,
                        height: 5.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            category['color'] as Color,
                          ),
                        ),
                      )
                    else
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppTheme.textSecondaryLight,
                        size: 4.w,
                      ),
                  ],
                ),
                SizedBox(height: 3.w),
                Text(
                  category['description'],
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppTheme.textPrimaryLight,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 3.w),
                Row(
                  children: [
                    _buildInfoChip(
                      Icons.access_time,
                      category['estimatedTime'],
                      Colors.blue,
                    ),
                    SizedBox(width: 2.w),
                    _buildInfoChip(
                      Icons.verified,
                      'Clinical Grade',
                      Colors.green,
                    ),
                  ],
                ),
                SizedBox(height: 2.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                  decoration: BoxDecoration(
                    color: AppTheme.successLight.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(1.w),
                  ),
                  child: Text(
                    'Reliability: ${category['clinicalReliability']}',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppTheme.successLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(1.w),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 3.w,
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
      ),
    );
  }
}
