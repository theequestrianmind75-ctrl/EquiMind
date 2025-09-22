import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../theme/app_theme.dart';

class RiskAssessmentWidget extends StatefulWidget {
  const RiskAssessmentWidget({super.key});

  @override
  State<RiskAssessmentWidget> createState() => _RiskAssessmentWidgetState();
}

class _RiskAssessmentWidgetState extends State<RiskAssessmentWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  bool _showCrisisPanel = false;
  String _currentRiskLevel = 'LOW';

  final Map<String, Map<String, dynamic>> _riskLevels = {
    'LOW': {
      'color': AppTheme.successLight,
      'icon': Icons.check_circle,
      'message': 'Risk factors within normal range',
    },
    'MODERATE': {
      'color': AppTheme.warningLight,
      'icon': Icons.warning_amber,
      'message': 'Some concerning patterns detected',
    },
    'HIGH': {
      'color': AppTheme.errorLight,
      'icon': Icons.error,
      'message': 'Immediate attention recommended',
    },
    'CRISIS': {
      'color': Colors.red.shade700,
      'icon': Icons.emergency,
      'message': 'Crisis intervention protocols activated',
    },
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _checkRiskLevel();

    if (_currentRiskLevel == 'HIGH' || _currentRiskLevel == 'CRISIS') {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _checkRiskLevel() {
    // This would analyze current assessment scores and determine risk level
    // For demo purposes, using simulated risk assessment
    setState(() {
      _currentRiskLevel = 'LOW'; // Would be calculated based on actual scores
    });
  }

  void _showCrisisResources() {
    setState(() => _showCrisisPanel = true);
  }

  void _hideCrisisPanel() {
    setState(() => _showCrisisPanel = false);
  }

  @override
  Widget build(BuildContext context) {
    final riskData = _riskLevels[_currentRiskLevel]!;

    return Stack(
      children: [
        // Risk Assessment FAB
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale:
                  _currentRiskLevel == 'HIGH' || _currentRiskLevel == 'CRISIS'
                      ? _pulseAnimation.value
                      : 1.0,
              child: FloatingActionButton.extended(
                onPressed: _showCrisisResources,
                backgroundColor: riskData['color'],
                icon: Icon(riskData['icon']),
                label: Text(_currentRiskLevel),
              ),
            );
          },
        ),

        // Crisis Resources Panel
        if (_showCrisisPanel) _buildCrisisPanel(),
      ],
    );
  }

  Widget _buildCrisisPanel() {
    return Positioned(
      bottom: 80,
      right: 16,
      left: 16,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(3.w),
        child: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.backgroundLight,
            borderRadius: BorderRadius.circular(3.w),
            border: Border.all(
              color: _riskLevels[_currentRiskLevel]!['color'],
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.emergency,
                    color: AppTheme.errorLight,
                    size: 6.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Crisis Intervention Resources',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimaryLight,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _hideCrisisPanel,
                    icon: Icon(
                      Icons.close,
                      color: AppTheme.textSecondaryLight,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.w),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.errorLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Risk Level: ${_currentRiskLevel}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: _riskLevels[_currentRiskLevel]!['color'],
                      ),
                    ),
                    SizedBox(height: 1.w),
                    Text(
                      _riskLevels[_currentRiskLevel]!['message'],
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppTheme.textPrimaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3.w),
              _buildCrisisButton(
                'Grounding Techniques',
                Icons.spa,
                Colors.blue,
                () => _launchGroundingTechniques(),
              ),
              SizedBox(height: 2.w),
              _buildCrisisButton(
                'Crisis Hotline',
                Icons.phone,
                AppTheme.errorLight,
                () => _callCrisisLine(),
              ),
              SizedBox(height: 2.w),
              _buildCrisisButton(
                'Emergency Services',
                Icons.local_hospital,
                Colors.red.shade700,
                () => _callEmergencyServices(),
              ),
              if (_currentRiskLevel == 'HIGH' ||
                  _currentRiskLevel == 'CRISIS') ...[
                SizedBox(height: 3.w),
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(2.w),
                    border: Border.all(color: Colors.red.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.warning,
                            color: Colors.red.shade700,
                            size: 5.w,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Immediate Safety Protocol',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.w),
                      Text(
                        'Professional consultation recommended within 24 hours. If experiencing thoughts of self-harm, contact emergency services immediately.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppTheme.textPrimaryLight,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCrisisButton(
      String title, IconData icon, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(title),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 3.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.w),
          ),
        ),
      ),
    );
  }

  void _launchGroundingTechniques() {
    Navigator.pushNamed(context, '/grounding-techniques');
  }

  void _callCrisisLine() {
    // Implementation for calling crisis hotline (988 in US)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Crisis Support'),
        content: const Text(
            'National Crisis Text Line: Text HOME to 741741\nNational Suicide Prevention Lifeline: 988'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _callEmergencyServices() {
    // Implementation for calling emergency services
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emergency Services'),
        content:
            const Text('If this is a medical emergency, call 911 immediately.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
