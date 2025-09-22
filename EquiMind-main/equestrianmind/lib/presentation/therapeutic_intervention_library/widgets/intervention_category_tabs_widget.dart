import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../theme/app_theme.dart';

class InterventionCategoryTabsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const InterventionCategoryTabsWidget({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.h,
      padding: EdgeInsets.symmetric(vertical: 3.w),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category['id'] == selectedCategory;

          return GestureDetector(
            onTap: () => onCategorySelected(category['id']),
            child: Container(
              width: 40.w,
              margin: EdgeInsets.only(right: 3.w),
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? category['color'].withValues(alpha: 0.15)
                    : AppTheme.surfaceLight,
                borderRadius: BorderRadius.circular(3.w),
                border: Border.all(
                  color: isSelected ? category['color'] : AppTheme.dividerLight,
                  width: isSelected ? 2 : 1,
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
                          color: category['color'].withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(2.w),
                        ),
                        child: Icon(
                          category['icon'],
                          color: category['color'],
                          size: 5.w,
                        ),
                      ),
                      Spacer(),
                      if (isSelected)
                        Icon(
                          Icons.check_circle,
                          color: category['color'],
                          size: 4.w,
                        ),
                    ],
                  ),
                  SizedBox(height: 2.w),
                  Text(
                    category['name'],
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? category['color']
                          : AppTheme.textPrimaryLight,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 1.w),
                  Text(
                    category['description'],
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppTheme.textSecondaryLight,
                      height: 1.3,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  if (category['techniques'] != null)
                    Wrap(
                      spacing: 1.w,
                      children: (category['techniques'] as List<String>)
                          .take(2)
                          .map(
                            (technique) => Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 1.5.w, vertical: 0.5.w),
                              decoration: BoxDecoration(
                                color: category['color'].withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(1.w),
                              ),
                              child: Text(
                                technique,
                                style: TextStyle(
                                  fontSize: 8.sp,
                                  color: category['color'],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
