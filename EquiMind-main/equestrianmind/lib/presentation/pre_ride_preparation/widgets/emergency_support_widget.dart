import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmergencySupportWidget extends StatelessWidget {
  final VoidCallback onClose;

  const EmergencySupportWidget({
    Key? key,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          SizedBox(height: 3.h),

          Row(
            children: [
              CustomIconWidget(
                iconName: 'emergency',
                color: Colors.red,
                size: 7.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Emergency Support',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: onClose,
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 6.w,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.red.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'info',
                  color: Colors.red,
                  size: 5.w,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'If you\'re experiencing severe anxiety or panic, these tools can help you regain control.',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 4.h),

          // Emergency techniques
          _buildEmergencyTechnique(
            icon: 'air',
            title: '5-4-3-2-1 Grounding',
            description:
                'Name 5 things you see, 4 you hear, 3 you touch, 2 you smell, 1 you taste',
            color: AppTheme.lightTheme.colorScheme.primary,
            onTap: () {
              // Implement grounding technique
            },
          ),

          SizedBox(height: 2.h),

          _buildEmergencyTechnique(
            icon: 'favorite',
            title: 'Box Breathing',
            description: 'Breathe in for 4, hold for 4, out for 4, hold for 4',
            color: Color(0xFF8B4513),
            onTap: () {
              // Implement box breathing
            },
          ),

          SizedBox(height: 2.h),

          _buildEmergencyTechnique(
            icon: 'self_improvement',
            title: 'Progressive Relaxation',
            description: 'Tense and release each muscle group from head to toe',
            color: Color(0xFFD4AF37),
            onTap: () {
              // Implement progressive relaxation
            },
          ),

          SizedBox(height: 4.h),

          // Emergency contacts
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need Professional Help?',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Implement emergency contact
                        },
                        icon: CustomIconWidget(
                          iconName: 'phone',
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          size: 4.w,
                        ),
                        label: Text('Crisis Hotline'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Implement coach contact
                        },
                        icon: CustomIconWidget(
                          iconName: 'support_agent',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 4.w,
                        ),
                        label: Text('Contact Coach'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildEmergencyTechnique({
    required String icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: color,
                size: 6.w,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    description,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: color,
              size: 4.w,
            ),
          ],
        ),
      ),
    );
  }
}
