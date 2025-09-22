import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/connection_testing_service.dart';
import './widgets/scenario_details_widget.dart';
import './widgets/scenario_selector_widget.dart';
import './widgets/test_results_widget.dart';

class ConnectionTestingScreen extends StatefulWidget {
  const ConnectionTestingScreen({Key? key}) : super(key: key);

  @override
  State<ConnectionTestingScreen> createState() =>
      _ConnectionTestingScreenState();
}

class _ConnectionTestingScreenState extends State<ConnectionTestingScreen> {
  final ConnectionTestingService _testingService = ConnectionTestingService();
  List<Map<String, dynamic>> _scenarios = [];
  Map<String, dynamic>? _selectedScenario;
  Map<String, dynamic>? _testResults;
  bool _isRunningTest = false;

  @override
  void initState() {
    super.initState();
    _loadTestScenarios();
  }

  void _loadTestScenarios() {
    setState(() {
      _scenarios = _testingService.getTestScenarios();
    });
  }

  Future<void> _runTest(Map<String, dynamic> scenario) async {
    setState(() {
      _selectedScenario = scenario;
      _isRunningTest = true;
      _testResults = null;
    });

    try {
      final results = await _testingService.simulateTestingSession(scenario);
      setState(() {
        _testResults = results;
        _isRunningTest = false;
      });
    } catch (e) {
      setState(() {
        _isRunningTest = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Test failed: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Connection Testing Lab',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
      ),
      body: SafeArea(
        child: _isRunningTest
            ? _buildLoadingView()
            : _testResults != null
                ? _buildResultsView()
                : _buildScenarioSelection(),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary.withAlpha(26),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.lightTheme.colorScheme.primary,
                ),
                strokeWidth: 3,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Running Test Scenario',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Analyzing ${_selectedScenario?['name']}...',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color:
                  AppTheme.lightTheme.colorScheme.onSurface.withAlpha(179),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScenarioSelection() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer
                    .withAlpha(26),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary.withAlpha(51),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'science',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 24,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Test Different Scenarios',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Explore how your EquiMind AI responds to various rider-horse connection scenarios. Test different emotional states, bonding levels, and interaction patterns to understand the coaching system better.',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Select Test Scenario',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 2.h),
            ScenarioSelectorWidget(
              scenarios: _scenarios,
              onScenarioSelected: _runTest,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsView() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            // Test scenario details
            if (_selectedScenario != null)
              ScenarioDetailsWidget(scenario: _selectedScenario!),

            SizedBox(height: 3.h),

            // Test results
            if (_testResults != null)
              TestResultsWidget(
                testResults: _testResults!,
                onRunAnotherTest: () {
                  setState(() {
                    _testResults = null;
                    _selectedScenario = null;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}
