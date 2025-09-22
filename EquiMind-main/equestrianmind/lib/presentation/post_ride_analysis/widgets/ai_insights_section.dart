import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../services/ai_coaching_service.dart';

class AiInsightsSection extends StatefulWidget {
  final Map<String, dynamic> rideData;
  final String emotionalState;
  final Map<String, dynamic> performanceMetrics;

  const AiInsightsSection({
    Key? key,
    required this.rideData,
    required this.emotionalState,
    required this.performanceMetrics,
  }) : super(key: key);

  @override
  State<AiInsightsSection> createState() => _AiInsightsSectionState();
}

class _AiInsightsSectionState extends State<AiInsightsSection> {
  Set<int> expandedCards = {};
  List<Map<String, dynamic>> insights = [];
  bool isLoading = true;
  final AICoachingService _aiService = AICoachingService();

  @override
  void initState() {
    super.initState();
    _generateInsights();
  }

  Future<void> _generateInsights() async {
    try {
      setState(() {
        isLoading = true;
      });

      final generatedInsights = await _aiService.generateRideInsights(
        rideData: widget.rideData,
        emotionalState: widget.emotionalState,
        performanceMetrics: widget.performanceMetrics,
      );

      setState(() {
        insights = generatedInsights;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        // Keep existing insights if any, or show empty state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'psychology',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'AI Coaching Insights',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
              Spacer(),
              if (!isLoading)
                IconButton(
                  onPressed: _generateInsights,
                  icon: CustomIconWidget(
                    iconName: 'refresh',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  tooltip: 'Regenerate Insights',
                ),
            ],
          ),
          SizedBox(height: 2.h),
          if (isLoading)
            _buildLoadingState()
          else if (insights.isEmpty)
            _buildEmptyState()
          else
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: insights.length,
              separatorBuilder: (context, index) => SizedBox(height: 2.h),
              itemBuilder: (context, index) {
                final insight = insights[index];
                final isExpanded = expandedCards.contains(index);

                return Container(
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.lightTheme.colorScheme.shadow,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (isExpanded) {
                              expandedCards.remove(index);
                            } else {
                              expandedCards.add(index);
                            }
                          });
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: EdgeInsets.all(4.w),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(2.w),
                                decoration: BoxDecoration(
                                  color: _getInsightColor(
                                          insight['category'] as String? ?? '')
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: CustomIconWidget(
                                  iconName: _getInsightIcon(
                                      insight['category'] as String? ?? ''),
                                  color: _getInsightColor(
                                      insight['category'] as String? ?? ''),
                                  size: 24,
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      insight['title'] as String? ?? 'Insight',
                                      style: AppTheme
                                          .lightTheme.textTheme.titleMedium
                                          ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme
                                            .lightTheme.colorScheme.onSurface,
                                      ),
                                    ),
                                    SizedBox(height: 0.5.h),
                                    Text(
                                      insight['summary'] as String? ??
                                          'No summary available',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                      ),
                                      maxLines: isExpanded ? null : 2,
                                      overflow: isExpanded
                                          ? null
                                          : TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              CustomIconWidget(
                                iconName:
                                    isExpanded ? 'expand_less' : 'expand_more',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isExpanded) ...[
                        Divider(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                          height: 1,
                        ),
                        Padding(
                          padding: EdgeInsets.all(4.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Recommendations',
                                style: AppTheme.lightTheme.textTheme.titleSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                ),
                              ),
                              SizedBox(height: 1.h),
                              ...(insight['recommendations']
                                          as List<dynamic>? ??
                                      [])
                                  .map((rec) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 1.h),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 0.5.h, right: 2.w),
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: AppTheme
                                              .lightTheme.colorScheme.primary,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          rec as String? ?? '',
                                          style: AppTheme
                                              .lightTheme.textTheme.bodyMedium
                                              ?.copyWith(
                                            color: AppTheme.lightTheme
                                                .colorScheme.onSurface,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              SizedBox(height: 2.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        // Navigate to specific coaching module
                                        Navigator.pushNamed(
                                          context,
                                          '/pre-ride-preparation',
                                          arguments: {
                                            'focus': insight['category'],
                                            'recommendations':
                                                insight['recommendations'],
                                          },
                                        );
                                      },
                                      icon: CustomIconWidget(
                                        iconName: 'play_arrow',
                                        color: AppTheme
                                            .lightTheme.colorScheme.primary,
                                        size: 18,
                                      ),
                                      label: Text('Start Exercise'),
                                      style: OutlinedButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 1.5.h),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 3.w),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        // Save insight for later
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Insight saved to your progress'),
                                            backgroundColor: AppTheme
                                                .lightTheme.primaryColor,
                                          ),
                                        );
                                      },
                                      icon: CustomIconWidget(
                                        iconName: 'bookmark',
                                        color: AppTheme
                                            .lightTheme.colorScheme.onPrimary,
                                        size: 18,
                                      ),
                                      label: Text('Save'),
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 1.5.h),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          CircularProgressIndicator(
            color: AppTheme.lightTheme.primaryColor,
          ),
          SizedBox(height: 2.h),
          Text(
            'AI is analyzing your ride...',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'error_outline',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'Unable to generate insights',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Please check your internet connection and try again',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          ElevatedButton.icon(
            onPressed: _generateInsights,
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 18,
            ),
            label: Text('Retry'),
          ),
        ],
      ),
    );
  }

  String _getInsightIcon(String category) {
    switch (category.toLowerCase()) {
      case 'emotion':
        return 'mood';
      case 'performance':
        return 'trending_up';
      case 'technique':
        return 'sports';
      case 'confidence':
        return 'psychology';
      case 'horse_behavior':
        return 'pets';
      default:
        return 'lightbulb';
    }
  }

  Color _getInsightColor(String category) {
    switch (category.toLowerCase()) {
      case 'emotion':
        return Colors.purple.shade600;
      case 'performance':
        return Colors.green.shade600;
      case 'technique':
        return Colors.blue.shade600;
      case 'confidence':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'horse_behavior':
        return Colors.brown.shade600;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }
}
