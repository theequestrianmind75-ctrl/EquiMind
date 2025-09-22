import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmergencyStopButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isActive;

  const EmergencyStopButton({
    Key? key,
    required this.onPressed,
    this.isActive = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35.w,
      height: 35.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive
            ? AppTheme.lightTheme.colorScheme.error
            : AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.6),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isActive ? onPressed : null,
          borderRadius: BorderRadius.circular(35.w),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 4,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'stop',
                    color: Colors.white,
                    size: 8.w,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'STOP',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
