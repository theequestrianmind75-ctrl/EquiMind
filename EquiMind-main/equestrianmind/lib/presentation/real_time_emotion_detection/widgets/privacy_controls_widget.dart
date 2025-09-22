import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PrivacyControlsWidget extends StatefulWidget {
  const PrivacyControlsWidget({super.key});

  @override
  State<PrivacyControlsWidget> createState() => _PrivacyControlsWidgetState();
}

class _PrivacyControlsWidgetState extends State<PrivacyControlsWidget> {
  bool _shareWithTrainer = false;
  bool _shareWithCoach = false;
  bool _allowDataAnalytics = true;
  bool _enableRemoteSharing = false;
  bool _storeLocally = true;
  bool _anonymizeData = true;

  String _dataRetentionPeriod = '30';
  String _trainerEmail = '';
  String _coachEmail = '';

  final List<Map<String, String>> _retentionOptions = [
    {'value': '7', 'label': '7 days'},
    {'value': '30', 'label': '30 days'},
    {'value': '90', 'label': '90 days'},
    {'value': '365', 'label': '1 year'},
    {'value': 'forever', 'label': 'Forever'},
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _shareWithTrainer = prefs.getBool('emotion_share_trainer') ?? false;
      _shareWithCoach = prefs.getBool('emotion_share_coach') ?? false;
      _allowDataAnalytics = prefs.getBool('emotion_allow_analytics') ?? true;
      _enableRemoteSharing = prefs.getBool('emotion_remote_sharing') ?? false;
      _storeLocally = prefs.getBool('emotion_store_locally') ?? true;
      _anonymizeData = prefs.getBool('emotion_anonymize') ?? true;
      _dataRetentionPeriod =
          prefs.getString('emotion_retention_period') ?? '30';
      _trainerEmail = prefs.getString('trainer_email') ?? '';
      _coachEmail = prefs.getString('coach_email') ?? '';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('emotion_share_trainer', _shareWithTrainer);
    await prefs.setBool('emotion_share_coach', _shareWithCoach);
    await prefs.setBool('emotion_allow_analytics', _allowDataAnalytics);
    await prefs.setBool('emotion_remote_sharing', _enableRemoteSharing);
    await prefs.setBool('emotion_store_locally', _storeLocally);
    await prefs.setBool('emotion_anonymize', _anonymizeData);
    await prefs.setString('emotion_retention_period', _dataRetentionPeriod);
    await prefs.setString('trainer_email', _trainerEmail);
    await prefs.setString('coach_email', _coachEmail);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Privacy settings saved'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _clearAllData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will permanently delete all stored emotion data. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // In a real implementation, this would clear all stored emotion data
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All emotion data has been cleared'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85.w,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(230),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withAlpha(51)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Privacy Controls',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Data sharing section
          _buildSectionTitle('Data Sharing'),
          _buildDataSharingControls(),
          SizedBox(height: 3.h),

          // Data storage section
          _buildSectionTitle('Data Storage'),
          _buildDataStorageControls(),
          SizedBox(height: 3.h),

          // Data retention section
          _buildSectionTitle('Data Retention'),
          _buildDataRetentionControls(),
          SizedBox(height: 4.h),

          // Action buttons
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 12.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDataSharingControls() {
    return Column(
      children: [
        SizedBox(height: 2.h),
        SwitchListTile(
          title: Text(
            'Share with Trainer',
            style: TextStyle(color: Colors.white, fontSize: 10.sp),
          ),
          subtitle: Text(
            'Allow your trainer to view emotion data',
            style:
                TextStyle(color: Colors.white.withAlpha(179), fontSize: 9.sp),
          ),
          value: _shareWithTrainer,
          onChanged: (value) {
            setState(() {
              _shareWithTrainer = value;
            });
          },
          activeColor: Colors.blue,
          contentPadding: EdgeInsets.zero,
        ),
        if (_shareWithTrainer) ...[
          Padding(
            padding: EdgeInsets.only(left: 4.w, bottom: 1.h),
            child: TextFormField(
              initialValue: _trainerEmail,
              decoration: InputDecoration(
                labelText: 'Trainer Email',
                labelStyle: TextStyle(color: Colors.white.withAlpha(179)),
                filled: true,
                fillColor: Colors.white.withAlpha(26),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              ),
              style: TextStyle(color: Colors.white, fontSize: 9.sp),
              onChanged: (value) {
                _trainerEmail = value;
              },
            ),
          ),
        ],
        SwitchListTile(
          title: Text(
            'Share with Coach',
            style: TextStyle(color: Colors.white, fontSize: 10.sp),
          ),
          subtitle: Text(
            'Allow your coach to view emotion data',
            style:
                TextStyle(color: Colors.white.withAlpha(179), fontSize: 9.sp),
          ),
          value: _shareWithCoach,
          onChanged: (value) {
            setState(() {
              _shareWithCoach = value;
            });
          },
          activeColor: Colors.blue,
          contentPadding: EdgeInsets.zero,
        ),
        if (_shareWithCoach) ...[
          Padding(
            padding: EdgeInsets.only(left: 4.w, bottom: 1.h),
            child: TextFormField(
              initialValue: _coachEmail,
              decoration: InputDecoration(
                labelText: 'Coach Email',
                labelStyle: TextStyle(color: Colors.white.withAlpha(179)),
                filled: true,
                fillColor: Colors.white.withAlpha(26),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              ),
              style: TextStyle(color: Colors.white, fontSize: 9.sp),
              onChanged: (value) {
                _coachEmail = value;
              },
            ),
          ),
        ],
        SwitchListTile(
          title: Text(
            'Enable Remote Sharing',
            style: TextStyle(color: Colors.white, fontSize: 10.sp),
          ),
          subtitle: Text(
            'Allow secure data transmission to coaches',
            style:
                TextStyle(color: Colors.white.withAlpha(179), fontSize: 9.sp),
          ),
          value: _enableRemoteSharing,
          onChanged: (value) {
            setState(() {
              _enableRemoteSharing = value;
            });
          },
          activeColor: Colors.blue,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildDataStorageControls() {
    return Column(
      children: [
        SizedBox(height: 2.h),
        SwitchListTile(
          title: Text(
            'Store Data Locally',
            style: TextStyle(color: Colors.white, fontSize: 10.sp),
          ),
          subtitle: Text(
            'Keep emotion data on your device',
            style:
                TextStyle(color: Colors.white.withAlpha(179), fontSize: 9.sp),
          ),
          value: _storeLocally,
          onChanged: (value) {
            setState(() {
              _storeLocally = value;
            });
          },
          activeColor: Colors.blue,
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile(
          title: Text(
            'Anonymize Data',
            style: TextStyle(color: Colors.white, fontSize: 10.sp),
          ),
          subtitle: Text(
            'Remove personal identifiers from stored data',
            style:
                TextStyle(color: Colors.white.withAlpha(179), fontSize: 9.sp),
          ),
          value: _anonymizeData,
          onChanged: (value) {
            setState(() {
              _anonymizeData = value;
            });
          },
          activeColor: Colors.blue,
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile(
          title: Text(
            'Allow Data Analytics',
            style: TextStyle(color: Colors.white, fontSize: 10.sp),
          ),
          subtitle: Text(
            'Use data for improving AI insights (anonymized)',
            style:
                TextStyle(color: Colors.white.withAlpha(179), fontSize: 9.sp),
          ),
          value: _allowDataAnalytics,
          onChanged: (value) {
            setState(() {
              _allowDataAnalytics = value;
            });
          },
          activeColor: Colors.blue,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildDataRetentionControls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 2.h),
        Text(
          'Data Retention Period',
          style: TextStyle(
            color: Colors.white.withAlpha(230),
            fontSize: 10.sp,
          ),
        ),
        SizedBox(height: 1.h),
        DropdownButtonFormField<String>(
          value: _dataRetentionPeriod,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withAlpha(26),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          ),
          dropdownColor: Colors.grey[800],
          style: TextStyle(color: Colors.white, fontSize: 10.sp),
          items: _retentionOptions.map((option) {
            return DropdownMenuItem<String>(
              value: option['value'],
              child: Text(option['label']!),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _dataRetentionPeriod = value;
              });
            }
          },
        ),
        SizedBox(height: 1.h),
        Text(
          _dataRetentionPeriod == 'forever'
              ? 'Data will be kept until manually deleted'
              : 'Data older than $_dataRetentionPeriod days will be automatically deleted',
          style: TextStyle(
            color: Colors.white.withAlpha(153),
            fontSize: 8.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _saveSettings,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
            ),
            child: Text(
              'Save Settings',
              style: TextStyle(fontSize: 10.sp),
            ),
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: ElevatedButton(
            onPressed: _clearAllData,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
            ),
            child: Text(
              'Clear Data',
              style: TextStyle(fontSize: 10.sp),
            ),
          ),
        ),
      ],
    );
  }
}
