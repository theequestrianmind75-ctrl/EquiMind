import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/app_info_section_widget.dart';
import './widgets/bottom_action_bar_widget.dart';
import './widgets/device_testing_tools_widget.dart';
import './widgets/feedback_collection_widget.dart';
import './widgets/performance_metrics_widget.dart';
import './widgets/quick_testing_cards_widget.dart';
import './widgets/testing_checklist_widget.dart';

class TestingDashboard extends StatefulWidget {
  const TestingDashboard({Key? key}) : super(key: key);

  @override
  State<TestingDashboard> createState() => _TestingDashboardState();
}

class _TestingDashboardState extends State<TestingDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _testingModeEnabled = false;
  String _testingSessionId = "TS-${DateTime.now().millisecondsSinceEpoch}";

  // Mock testing data
  final Map<String, dynamic> appInfo = {
    "version": "2.1.3",
    "buildNumber": "145",
    "environment": "Development",
    "lastModified": "2025-08-18 10:30 AM"
  };

  final Map<String, dynamic> performanceMetrics = {
    "memoryUsage": 67.5,
    "batteryConsumption": 12.3,
    "networkActivity": 8.2,
    "statusColor": Colors.green,
    "overallHealth": "Optimal"
  };

  List<Map<String, dynamic>> testingChecklist = [
    {
      "id": 1,
      "title": "Authentication Flow",
      "description": "Login, biometric auth, social login",
      "status": "passed",
      "progress": 1.0,
      "notes": "All auth methods working correctly"
    },
    {
      "id": 2,
      "title": "Coaching Session Flow",
      "description": "Pre-ride to post-ride journey",
      "status": "in_progress",
      "progress": 0.6,
      "notes": "Audio feedback needs adjustment"
    },
    {
      "id": 3,
      "title": "Emergency Features",
      "description": "Panic button, contact notification",
      "status": "pending",
      "progress": 0.0,
      "notes": ""
    },
    {
      "id": 4,
      "title": "Biometric Integration",
      "description": "Heart rate, stress detection",
      "status": "failed",
      "progress": 0.3,
      "notes": "Connection timeout issues"
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleTestingMode() {
    setState(() {
      _testingModeEnabled = !_testingModeEnabled;
      if (_testingModeEnabled) {
        _testingSessionId = "TS-${DateTime.now().millisecondsSinceEpoch}";
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_testingModeEnabled
            ? 'Testing Mode Enabled - Enhanced logging active'
            : 'Testing Mode Disabled'),
        backgroundColor: _testingModeEnabled
            ? AppTheme.successLight
            : AppTheme.lightTheme.colorScheme.onSurface,
      ),
    );
  }

  void _navigateToFeatureTestingSuite() {
    Navigator.pushNamed(context, AppRoutes.featureTestingSuite);
  }

  void _generateTestReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'description',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text('Generate Test Report'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Include the following in your test report:'),
            SizedBox(height: 2.h),
            _buildReportOption('Performance Metrics', true),
            _buildReportOption('Testing Checklist Results', true),
            _buildReportOption('Device Information', true),
            _buildReportOption('Feedback Screenshots', false),
            _buildReportOption('Debug Logs', _testingModeEnabled),
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
              _processTestReport();
            },
            child: Text('Generate'),
          ),
        ],
      ),
    );
  }

  Widget _buildReportOption(String title, bool enabled) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        children: [
          Checkbox(
            value: enabled,
            onChanged: (_) {},
          ),
          Expanded(child: Text(title)),
        ],
      ),
    );
  }

  void _processTestReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Test report generated successfully'),
        action: SnackBarAction(
          label: 'View',
          onPressed: () {},
        ),
      ),
    );
  }

  void _clearTestData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Test Data'),
        content: Text(
            'This will remove all testing session data, screenshots, and logs. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _testingSessionId =
                    "TS-${DateTime.now().millisecondsSinceEpoch}";
                testingChecklist = testingChecklist
                    .map((item) => {
                          ...item,
                          'status': 'pending',
                          'progress': 0.0,
                          'notes': ''
                        })
                    .toList();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Test data cleared successfully')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
            ),
            child: Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _exportLogs() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exporting debug logs...'),
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
        title: Text('Testing Dashboard'),
        actions: [
          Switch(
            value: _testingModeEnabled,
            onChanged: (_) => _toggleTestingMode(),
          ),
          SizedBox(width: 2.w),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'bug_report',
              color: _testingModeEnabled
                  ? AppTheme.successLight
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            onPressed: _navigateToFeatureTestingSuite,
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
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
              controller: _tabController,
              tabs: [
                Tab(
                  icon: CustomIconWidget(
                    iconName: 'dashboard',
                    size: 20,
                  ),
                  text: 'Overview',
                ),
                Tab(
                  icon: CustomIconWidget(
                    iconName: 'checklist_rtl',
                    size: 20,
                  ),
                  text: 'Testing',
                ),
                Tab(
                  icon: CustomIconWidget(
                    iconName: 'settings',
                    size: 20,
                  ),
                  text: 'Tools',
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Overview Tab
                SingleChildScrollView(
                  child: Column(
                    children: [
                      AppInfoSectionWidget(
                        appInfo: appInfo,
                        testingSessionId: _testingSessionId,
                        testingModeEnabled: _testingModeEnabled,
                      ),
                      QuickTestingCardsWidget(),
                      PerformanceMetricsWidget(
                        metricsData: performanceMetrics,
                      ),
                      FeedbackCollectionWidget(),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
                // Testing Tab
                SingleChildScrollView(
                  child: Column(
                    children: [
                      TestingChecklistWidget(
                        checklistItems: testingChecklist,
                        onItemTap: (item) {
                          // Handle checklist item interaction
                        },
                        onUpdateNotes: (id, notes) {
                          setState(() {
                            final index = testingChecklist
                                .indexWhere((item) => item['id'] == id);
                            if (index != -1) {
                              testingChecklist[index]['notes'] = notes;
                            }
                          });
                        },
                      ),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
                // Tools Tab
                SingleChildScrollView(
                  child: Column(
                    children: [
                      DeviceTestingToolsWidget(),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Bottom Action Bar
          BottomActionBarWidget(
            onGenerateReport: _generateTestReport,
            onClearData: _clearTestData,
            onExportLogs: _exportLogs,
            testingModeEnabled: _testingModeEnabled,
          ),
        ],
      ),
    );
  }
}
