import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/advanced_options_section.dart';
import './widgets/biometric_integration_section.dart';
import './widgets/coaching_style_section.dart';
import './widgets/data_privacy_section.dart';
import './widgets/emergency_features_section.dart';
import './widgets/notification_settings_section.dart';
import './widgets/reset_section.dart';
import './widgets/session_preferences_section.dart';
import './widgets/trigger_sensitivity_section.dart';
import './widgets/voice_settings_section.dart';

class AiCoachingSettings extends StatefulWidget {
  const AiCoachingSettings({Key? key}) : super(key: key);

  @override
  State<AiCoachingSettings> createState() => _AiCoachingSettingsState();
}

class _AiCoachingSettingsState extends State<AiCoachingSettings> {
  // Coaching Style Settings
  String selectedCoachingStyle = 'Encouraging';

  // Voice Settings
  double voiceSpeed = 1.0;
  String selectedAccent = 'American';
  double volume = 0.8;

  // Trigger Sensitivity
  String selectedSensitivity = 'Medium';

  // Biometric Integration
  bool heartRateEnabled = true;
  bool stressDetectionEnabled = false;
  double emergencyThreshold = 0.7;

  // Session Preferences
  int defaultDuration = 60;
  int breakInterval = 15;
  bool autoStartEnabled = true;

  // Emergency Features
  String emergencyContact = '+1 (555) 123-4567';
  String panicButtonBehavior = 'Call Emergency Contact';
  int safetyCheckFrequency = 15;

  // Notification Settings
  bool coachingReminders = true;
  bool progressCelebrations = true;
  bool sessionScheduling = false;

  // Data Privacy
  bool aiLearningEnabled = true;
  String dataRetentionPeriod = '1 Year';
  bool anonymizedSharingEnabled = false;

  // Advanced Options
  bool offlineCoachingEnabled = false;
  bool backgroundProcessingEnabled = true;
  bool batteryOptimizationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.primaryColor,
      elevation: 2,
      leading: InkWell(
        onTap: () => Navigator.pop(context),
        borderRadius: BorderRadius.circular(2.w),
        child: Container(
          margin: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(2.w),
          ),
          child: CustomIconWidget(
            iconName: 'arrow_back',
            color: Colors.white,
            size: 6.w,
          ),
        ),
      ),
      title: Text(
        'AI Coaching Settings',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        InkWell(
          onTap: _showHelp,
          borderRadius: BorderRadius.circular(2.w),
          child: Container(
            margin: EdgeInsets.all(2.w),
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: CustomIconWidget(
              iconName: 'help_outline',
              color: Colors.white,
              size: 6.w,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderSection(),
          SizedBox(height: 3.h),
          CoachingStyleSection(
            selectedStyle: selectedCoachingStyle,
            onStyleChanged: (style) =>
                setState(() => selectedCoachingStyle = style),
          ),
          SizedBox(height: 3.h),
          VoiceSettingsSection(
            voiceSpeed: voiceSpeed,
            selectedAccent: selectedAccent,
            volume: volume,
            onSpeedChanged: (speed) => setState(() => voiceSpeed = speed),
            onAccentChanged: (accent) =>
                setState(() => selectedAccent = accent),
            onVolumeChanged: (vol) => setState(() => volume = vol),
          ),
          SizedBox(height: 3.h),
          TriggerSensitivitySection(
            selectedSensitivity: selectedSensitivity,
            onSensitivityChanged: (sensitivity) =>
                setState(() => selectedSensitivity = sensitivity),
          ),
          SizedBox(height: 3.h),
          BiometricIntegrationSection(
            heartRateEnabled: heartRateEnabled,
            stressDetectionEnabled: stressDetectionEnabled,
            emergencyThreshold: emergencyThreshold,
            onHeartRateToggle: (enabled) =>
                setState(() => heartRateEnabled = enabled),
            onStressDetectionToggle: (enabled) =>
                setState(() => stressDetectionEnabled = enabled),
            onEmergencyThresholdChanged: (threshold) =>
                setState(() => emergencyThreshold = threshold),
          ),
          SizedBox(height: 3.h),
          SessionPreferencesSection(
            defaultDuration: defaultDuration,
            breakInterval: breakInterval,
            autoStartEnabled: autoStartEnabled,
            onDurationChanged: (duration) =>
                setState(() => defaultDuration = duration),
            onBreakIntervalChanged: (interval) =>
                setState(() => breakInterval = interval),
            onAutoStartToggle: (enabled) =>
                setState(() => autoStartEnabled = enabled),
          ),
          SizedBox(height: 3.h),
          EmergencyFeaturesSection(
            emergencyContact: emergencyContact,
            panicButtonBehavior: panicButtonBehavior,
            safetyCheckFrequency: safetyCheckFrequency,
            onEmergencyContactChanged: (contact) =>
                setState(() => emergencyContact = contact),
            onPanicButtonBehaviorChanged: (behavior) =>
                setState(() => panicButtonBehavior = behavior),
            onSafetyCheckFrequencyChanged: (frequency) =>
                setState(() => safetyCheckFrequency = frequency),
          ),
          SizedBox(height: 3.h),
          NotificationSettingsSection(
            coachingReminders: coachingReminders,
            progressCelebrations: progressCelebrations,
            sessionScheduling: sessionScheduling,
            onCoachingRemindersToggle: (enabled) =>
                setState(() => coachingReminders = enabled),
            onProgressCelebrationsToggle: (enabled) =>
                setState(() => progressCelebrations = enabled),
            onSessionSchedulingToggle: (enabled) =>
                setState(() => sessionScheduling = enabled),
          ),
          SizedBox(height: 3.h),
          DataPrivacySection(
            aiLearningEnabled: aiLearningEnabled,
            dataRetentionPeriod: dataRetentionPeriod,
            anonymizedSharingEnabled: anonymizedSharingEnabled,
            onAiLearningToggle: (enabled) =>
                setState(() => aiLearningEnabled = enabled),
            onDataRetentionChanged: (period) =>
                setState(() => dataRetentionPeriod = period),
            onAnonymizedSharingToggle: (enabled) =>
                setState(() => anonymizedSharingEnabled = enabled),
          ),
          SizedBox(height: 3.h),
          AdvancedOptionsSection(
            offlineCoachingEnabled: offlineCoachingEnabled,
            backgroundProcessingEnabled: backgroundProcessingEnabled,
            batteryOptimizationEnabled: batteryOptimizationEnabled,
            onOfflineCoachingToggle: (enabled) =>
                setState(() => offlineCoachingEnabled = enabled),
            onBackgroundProcessingToggle: (enabled) =>
                setState(() => backgroundProcessingEnabled = enabled),
            onBatteryOptimizationToggle: (enabled) =>
                setState(() => batteryOptimizationEnabled = enabled),
          ),
          SizedBox(height: 3.h),
          ResetSection(
            onResetCoachingHistory: _resetCoachingHistory,
            onRestorePreferences: _restorePreferences,
            onResetAiLearning: _resetAiLearning,
          ),
          SizedBox(height: 5.h),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
            AppTheme.lightTheme.primaryColor.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(3.w),
                ),
                child: CustomIconWidget(
                  iconName: 'psychology',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 8.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Personalize Your AI Coach',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.lightTheme.primaryColor,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Customize your coaching experience to match your riding style and preferences',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              _buildQuickStat('Current Style', selectedCoachingStyle),
              SizedBox(width: 4.w),
              _buildQuickStat('Sensitivity', selectedSensitivity),
              SizedBox(width: 4.w),
              _buildQuickStat('Duration', '${defaultDuration}min'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(String label, String value) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(2.w),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.primaryColor,
              ),
            ),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'help',
              color: AppTheme.lightTheme.primaryColor,
              size: 6.w,
            ),
            SizedBox(width: 2.w),
            Text(
              'Coaching Settings Help',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Customize your AI coaching experience:',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2.h),
              _buildHelpItem(
                  'Coaching Style', 'Choose how the AI communicates with you'),
              _buildHelpItem(
                  'Voice Settings', 'Adjust speech speed, accent, and volume'),
              _buildHelpItem('Trigger Sensitivity',
                  'Control how often AI provides feedback'),
              _buildHelpItem('Biometric Integration',
                  'Connect heart rate monitors and stress sensors'),
              _buildHelpItem('Emergency Features',
                  'Set up safety contacts and panic button behavior'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Got it',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String title, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 0.5.h),
            width: 1.w,
            height: 1.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  description,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _resetCoachingHistory() {
    // Reset coaching history logic would go here
  }

  void _restorePreferences() {
    setState(() {
      selectedCoachingStyle = 'Encouraging';
      voiceSpeed = 1.0;
      selectedAccent = 'American';
      volume = 0.8;
      selectedSensitivity = 'Medium';
      heartRateEnabled = true;
      stressDetectionEnabled = false;
      emergencyThreshold = 0.7;
      defaultDuration = 60;
      breakInterval = 15;
      autoStartEnabled = true;
      emergencyContact = '';
      panicButtonBehavior = 'Call Emergency Contact';
      safetyCheckFrequency = 15;
      coachingReminders = true;
      progressCelebrations = true;
      sessionScheduling = false;
      aiLearningEnabled = true;
      dataRetentionPeriod = '1 Year';
      anonymizedSharingEnabled = false;
      offlineCoachingEnabled = false;
      backgroundProcessingEnabled = true;
      batteryOptimizationEnabled = true;
    });
  }

  void _resetAiLearning() {
    // Reset AI learning logic would go here
  }
}
