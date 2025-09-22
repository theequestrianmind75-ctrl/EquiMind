import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BottomActionBarWidget extends StatelessWidget {
  final VoidCallback onGenerateReport;
  final VoidCallback onClearData;
  final VoidCallback onExportLogs;
  final bool testingModeEnabled;

  const BottomActionBarWidget({
    Key? key,
    required this.onGenerateReport,
    required this.onClearData,
    required this.onExportLogs,
    required this.testingModeEnabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onGenerateReport,
                    icon: CustomIconWidget(
                      iconName: 'description',
                      color: Colors.white,
                      size: 20,
                    ),
                    label: Text('Generate Test Report'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(0, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onClearData,
                    icon: CustomIconWidget(
                      iconName: 'clear_all',
                      color: AppTheme.errorLight,
                      size: 18,
                    ),
                    label: Text(
                      'Clear Test Data',
                      style: TextStyle(color: AppTheme.errorLight),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppTheme.errorLight),
                      minimumSize: Size(0, 44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: testingModeEnabled ? onExportLogs : null,
                    icon: CustomIconWidget(
                      iconName: 'file_download',
                      color: testingModeEnabled
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.38),
                      size: 18,
                    ),
                    label: Text(
                      'Export Logs',
                      style: TextStyle(
                        color: testingModeEnabled
                            ? AppTheme.lightTheme.primaryColor
                            : AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.38),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: testingModeEnabled
                            ? AppTheme.lightTheme.primaryColor
                            : AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.12),
                      ),
                      minimumSize: Size(0, 44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (!testingModeEnabled) ...[
              SizedBox(height: 1.h),
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
                      iconName: 'info_outline',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'Enable Testing Mode to unlock enhanced logging and debug features',
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
          ],
        ),
      ),
    );
  }
}
