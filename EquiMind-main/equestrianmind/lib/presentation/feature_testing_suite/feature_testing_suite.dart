import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/ai_coaching_test_widget.dart';
import './widgets/audio_systems_test_widget.dart';
import './widgets/biometric_integration_test_widget.dart';
import './widgets/emergency_features_test_widget.dart';
import './widgets/test_category_tabs_widget.dart';
import './widgets/test_controls_widget.dart';
import './widgets/test_progress_widget.dart';

class FeatureTestingSuite extends StatefulWidget {
  const FeatureTestingSuite({Key? key}) : super(key: key);

  @override
  State<FeatureTestingSuite> createState() => _FeatureTestingSuiteState();
}

class _FeatureTestingSuiteState extends State<FeatureTestingSuite>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _testingInProgress = false;
  double _overallProgress = 0.0;
  int _currentTestStep = 0;
  String _currentTestName = '';
  DateTime? _testStartTime;

  // Test sequence data
  final List<Map<String, dynamic>> testCategories = [
    {
      'id': 'ai_coaching',
      'title': 'AI Coaching Tests',
      'icon': 'psychology',
      'color': Colors.blue,
      'completed': false,
      'progress': 0.0,
      'totalSteps': 8,
    },
    {
      'id': 'biometric',
      'title': 'Biometric Integration',
      'icon': 'favorite',
      'color': Colors.red,
      'completed': false,
      'progress': 0.0,
      'totalSteps': 6,
    },
    {
      'id': 'audio',
      'title': 'Audio Systems',
      'icon': 'headset_mic',
      'color': Colors.orange,
      'completed': false,
      'progress': 0.0,
      'totalSteps': 5,
    },
    {
      'id': 'emergency',
      'title': 'Emergency Features',
      'icon': 'emergency',
      'color': Colors.purple,
      'completed': false,
      'progress': 0.0,
      'totalSteps': 4,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: testCategories.length, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    setState(() {});
  }

  void _startTestSequence() {
    setState(() {
      _testingInProgress = true;
      _testStartTime = DateTime.now();
      _currentTestStep = 0;
      _overallProgress = 0.0;
      _currentTestName = testCategories[_tabController.index]['title'];
    });

    _simulateTestProgress();
  }

  void _simulateTestProgress() {
    final category = testCategories[_tabController.index];
    final totalSteps = category['totalSteps'] as int;

    _currentTestStep = 0;

    void runNextStep() {
      if (_currentTestStep < totalSteps && _testingInProgress) {
        setState(() {
          _currentTestStep++;
          category['progress'] = _currentTestStep / totalSteps;
          _overallProgress = _calculateOverallProgress();
        });

        // Simulate step execution time
        Future.delayed(Duration(seconds: 2), () {
          if (_currentTestStep < totalSteps) {
            runNextStep();
          } else {
            // Test sequence completed
            setState(() {
              category['completed'] = true;
              _testingInProgress = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${category['title']} testing completed'),
                backgroundColor: AppTheme.successLight,
              ),
            );
          }
        });
      }
    }

    runNextStep();
  }

  void _skipCurrentStep() {
    if (_testingInProgress) {
      setState(() {
        _currentTestStep++;
        final category = testCategories[_tabController.index];
        category['progress'] =
            _currentTestStep / (category['totalSteps'] as int);
        _overallProgress = _calculateOverallProgress();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Test step skipped')),
      );
    }
  }

  void _markStepAsFailed() {
    if (_testingInProgress) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Mark Step as Failed'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Please provide details about the failure:'),
              SizedBox(height: 2.h),
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  hintText:
                      'Describe the issue, expected vs actual behavior...',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _handleFailedStep();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorLight,
              ),
              child: Text('Mark as Failed'),
            ),
          ],
        ),
      );
    }
  }

  void _handleFailedStep() {
    setState(() {
      _testingInProgress = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Test step marked as failed - Review required'),
        backgroundColor: AppTheme.errorLight,
      ),
    );
  }

  void _resetTestHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reset Test History'),
        content: Text(
            'This will clear all test progress and restart validation cycles. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                for (var category in testCategories) {
                  category['completed'] = false;
                  category['progress'] = 0.0;
                }
                _testingInProgress = false;
                _overallProgress = 0.0;
                _currentTestStep = 0;
                _testStartTime = null;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Test history reset successfully')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
            ),
            child: Text('Reset All'),
          ),
        ],
      ),
    );
  }

  double _calculateOverallProgress() {
    double totalProgress = 0.0;
    for (var category in testCategories) {
      totalProgress += category['progress'] as double;
    }
    return totalProgress / testCategories.length;
  }

  String _getEstimatedTimeRemaining() {
    if (_testStartTime == null || !_testingInProgress) return 'N/A';

    final elapsed = DateTime.now().difference(_testStartTime!);
    final category = testCategories[_tabController.index];
    final progress = category['progress'] as double;

    if (progress <= 0) return 'Calculating...';

    final estimatedTotal = elapsed.inSeconds / progress;
    final remaining =
        (estimatedTotal - elapsed.inSeconds).clamp(0, double.infinity);

    if (remaining < 60) {
      return '${remaining.toInt()}s';
    } else {
      return '${(remaining / 60).ceil()}m';
    }
  }

  void _exportTestResults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'file_download',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text('Export Test Results'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Generate comprehensive test report:'),
            SizedBox(height: 2.h),
            _buildExportOption('Test results and findings', true),
            _buildExportOption('Performance metrics', true),
            _buildExportOption('Device specifications', true),
            _buildExportOption('Failure screenshots', false),
            _buildExportOption('Detailed logs', _testingInProgress),
            SizedBox(height: 2.h),
            Text(
              'Report will be exported as PDF with timestamps.',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _processExport();
            },
            child: Text('Export Report'),
          ),
        ],
      ),
    );
  }

  Widget _buildExportOption(String option, bool included) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: included ? 'check_box' : 'check_box_outline_blank',
            color: included ? AppTheme.successLight : Colors.grey,
            size: 16,
          ),
          SizedBox(width: 2.w),
          Text(option),
        ],
      ),
    );
  }

  void _processExport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exporting comprehensive test report...'),
        action: SnackBarAction(
          label: 'Download',
          onPressed: () {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Feature Testing Suite'),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'file_download',
              size: 24,
            ),
            onPressed: _exportTestResults,
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'reset') _resetTestHistory();
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'reset',
                child: Row(
                  children: [
                    CustomIconWidget(iconName: 'restart_alt', size: 16),
                    SizedBox(width: 2.w),
                    Text('Reset History'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Overview
          TestProgressWidget(
            overallProgress: _overallProgress,
            testingInProgress: _testingInProgress,
            currentTestName: _currentTestName,
            estimatedTimeRemaining: _getEstimatedTimeRemaining(),
            completedCategories:
                testCategories.where((cat) => cat['completed'] == true).length,
            totalCategories: testCategories.length,
          ),
          // Tab Navigation
          TestCategoryTabsWidget(
            tabController: _tabController,
            categories: testCategories,
          ),
          // Test Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                AiCoachingTestWidget(
                  isActive: _tabController.index == 0,
                  testingInProgress: _testingInProgress,
                  currentStep: _currentTestStep,
                  totalSteps: testCategories[0]['totalSteps'] as int,
                ),
                BiometricIntegrationTestWidget(
                  isActive: _tabController.index == 1,
                  testingInProgress: _testingInProgress,
                  currentStep: _currentTestStep,
                  totalSteps: testCategories[1]['totalSteps'] as int,
                ),
                AudioSystemsTestWidget(
                  isActive: _tabController.index == 2,
                  testingInProgress: _testingInProgress,
                  currentStep: _currentTestStep,
                  totalSteps: testCategories[2]['totalSteps'] as int,
                ),
                EmergencyFeaturesTestWidget(
                  isActive: _tabController.index == 3,
                  testingInProgress: _testingInProgress,
                  currentStep: _currentTestStep,
                  totalSteps: testCategories[3]['totalSteps'] as int,
                ),
              ],
            ),
          ),
          // Test Controls
          TestControlsWidget(
            testingInProgress: _testingInProgress,
            canStartTest: !testCategories[_tabController.index]['completed'],
            onStartTest: _startTestSequence,
            onSkipStep: _skipCurrentStep,
            onMarkFailed: _markStepAsFailed,
            currentStep: _currentTestStep,
            totalSteps:
                testCategories[_tabController.index]['totalSteps'] as int,
          ),
        ],
      ),
    );
  }
}
