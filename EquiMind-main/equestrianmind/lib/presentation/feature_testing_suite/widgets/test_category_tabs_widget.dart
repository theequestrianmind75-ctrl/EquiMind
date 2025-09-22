import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TestCategoryTabsWidget extends StatelessWidget {
  final TabController tabController;
  final List<Map<String, dynamic>> categories;

  const TestCategoryTabsWidget({
    Key? key,
    required this.tabController,
    required this.categories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: TabBar(
        controller: tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        tabs: categories.asMap().entries.map((entry) {
          final index = entry.key;
          final category = entry.value;
          final isSelected = tabController.index == index;
          final color = category['color'] as Color;
          final completed = category['completed'] as bool;
          final progress = category['progress'] as double;

          return Tab(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? color.withValues(alpha: 0.2)
                              : color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: category['icon'],
                            color: isSelected
                                ? color
                                : color.withValues(alpha: 0.7),
                            size: 16,
                          ),
                        ),
                      ),
                      if (completed)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 3.w,
                            height: 3.w,
                            decoration: BoxDecoration(
                              color: AppTheme.successLight,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.check,
                                size: 8,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      if (!completed && progress > 0)
                        Positioned.fill(
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(color),
                            backgroundColor: color.withValues(alpha: 0.2),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(width: 2.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        category['title'],
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected
                              ? AppTheme.lightTheme.primaryColor
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (progress > 0) ...[
                        SizedBox(height: 0.2.h),
                        Text(
                          '${(progress * 100).toInt()}%',
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
