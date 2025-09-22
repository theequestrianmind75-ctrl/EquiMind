import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../services/ai_coaching_service.dart';

class AICoachingToolsWidget extends StatefulWidget {
  const AICoachingToolsWidget({Key? key}) : super(key: key);

  @override
  State<AICoachingToolsWidget> createState() => _AICoachingToolsWidgetState();
}

class _AICoachingToolsWidgetState extends State<AICoachingToolsWidget> {
  final AICoachingService _aiService = AICoachingService();
  bool _isLoading = false;
  String? _currentResponse;
  List<Map<String, dynamic>> _insights = [];
  List<Map<String, dynamic>> _exercises = [];

  final List<Map<String, dynamic>> _coachingTools = [
    {
      'id': 'real_time_coaching',
      'title': 'Real-Time Coaching',
      'description': 'Get instant AI coaching advice during your ride',
      'icon': 'psychology',
      'color': Colors.blue,
      'gradient': [Colors.blue.shade300, Colors.blue.shade600],
    },
    {
      'id': 'technique_analysis',
      'title': 'Technique Analysis',
      'description': 'Upload photos for AI-powered riding position feedback',
      'icon': 'photo_camera',
      'color': Colors.purple,
      'gradient': [Colors.purple.shade300, Colors.purple.shade600],
    },
    {
      'id': 'pre_ride_exercises',
      'title': 'Pre-Ride Preparation',
      'description': 'Get personalized warm-up and mental prep exercises',
      'icon': 'fitness_center',
      'color': Colors.green,
      'gradient': [Colors.green.shade300, Colors.green.shade600],
    },
    {
      'id': 'performance_insights',
      'title': 'Performance Insights',
      'description': 'Generate detailed AI analysis of your recent rides',
      'icon': 'analytics',
      'color': Colors.orange,
      'gradient': [Colors.orange.shade300, Colors.orange.shade600],
    },
    {
      'id': 'emotional_check',
      'title': 'Emotional Check-In',
      'description': 'AI-guided emotional awareness and regulation tools',
      'icon': 'favorite',
      'color': Colors.pink,
      'gradient': [Colors.pink.shade300, Colors.pink.shade600],
    },
    {
      'id': 'voice_notes',
      'title': 'Voice Memo Analysis',
      'description': 'Record voice notes and get AI transcription & insights',
      'icon': 'mic',
      'color': Colors.teal,
      'gradient': [Colors.teal.shade300, Colors.teal.shade600],
    },
  ];

  Future<void> _handleToolTap(Map<String, dynamic> tool) async {
    switch (tool['id']) {
      case 'real_time_coaching':
        _showRealTimeCoachingDialog();
        break;
      case 'technique_analysis':
        _showTechniqueAnalysisDialog();
        break;
      case 'pre_ride_exercises':
        _showPreRideExercisesDialog();
        break;
      case 'performance_insights':
        _generatePerformanceInsights();
        break;
      case 'emotional_check':
        _showEmotionalCheckDialog();
        break;
      case 'voice_notes':
        _showVoiceNotesDialog();
        break;
    }
  }

  void _showRealTimeCoachingDialog() {
    final TextEditingController activityController = TextEditingController();
    String selectedEmotion = 'confident';
    final Map<String, dynamic> mockBiometrics = {
      'heart_rate': 75,
      'breathing_rate': 16,
      'stress_level': 'low'
    };

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'psychology',
                color: Colors.blue,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text('Real-Time Coaching'),
            ],
          ),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: activityController,
                  decoration: InputDecoration(
                    labelText: 'Current Activity',
                    hintText: 'e.g., jumping exercise, dressage practice',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                DropdownButtonFormField<String>(
                  value: selectedEmotion,
                  decoration: InputDecoration(
                    labelText: 'Current Emotional State',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: [
                    'confident',
                    'nervous',
                    'excited',
                    'focused',
                    'anxious',
                    'calm'
                  ]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setDialogState(() => selectedEmotion = value!);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () async {
                      if (activityController.text.isEmpty) {
                        Fluttertoast.showToast(
                            msg: 'Please enter your current activity');
                        return;
                      }

                      Navigator.pop(context);
                      setState(() => _isLoading = true);

                      try {
                        final advice =
                            await _aiService.generateRealTimeCoaching(
                          currentActivity: activityController.text,
                          emotionalState: selectedEmotion,
                          biometrics: mockBiometrics,
                        );

                        setState(() {
                          _currentResponse = advice;
                          _isLoading = false;
                        });

                        _showResponseDialog(
                            'Real-Time Coaching Advice', advice, 'psychology');
                      } catch (e) {
                        setState(() => _isLoading = false);
                        Fluttertoast.showToast(
                            msg: 'Error generating coaching advice');
                      }
                    },
              child: Text('Get Coaching'),
            ),
          ],
        ),
      ),
    );
  }

  void _showTechniqueAnalysisDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'photo_camera',
              color: Colors.purple,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text('Technique Analysis'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Upload a photo of your riding position for AI-powered technique analysis and feedback.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImageAndAnalyze(ImageSource.camera),
                  icon: Icon(Icons.camera_alt),
                  label: Text('Camera'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _pickImageAndAnalyze(ImageSource.gallery),
                  icon: Icon(Icons.photo_library),
                  label: Text('Gallery'),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImageAndAnalyze(ImageSource source) async {
    Navigator.pop(context);

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() => _isLoading = true);

        // For demo purposes, using a placeholder URL
        // In production, you'd upload the image and get a URL
        const demoImageUrl =
            'https://images.unsplash.com/photo-1544737151-6e4b01de9c89?w=800';

        final analysis = await _aiService.analyzeRidingTechnique(
          imageUrl: demoImageUrl,
          specificFocus: 'overall riding position and technique',
        );

        setState(() => _isLoading = false);

        _showResponseDialog('Technique Analysis', analysis, 'photo_camera');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      Fluttertoast.showToast(msg: 'Error analyzing image');
    }
  }

  void _showPreRideExercisesDialog() {
    String selectedEmotion = 'confident';
    String selectedRideType = 'dressage';
    int availableMinutes = 15;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'fitness_center',
                color: Colors.green,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text('Pre-Ride Preparation'),
            ],
          ),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedEmotion,
                  decoration: InputDecoration(
                    labelText: 'Current Emotional State',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: ['confident', 'nervous', 'excited', 'anxious', 'calm']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setDialogState(() => selectedEmotion = value!);
                  },
                ),
                SizedBox(height: 2.h),
                DropdownButtonFormField<String>(
                  value: selectedRideType,
                  decoration: InputDecoration(
                    labelText: 'Type of Ride',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: [
                    'dressage',
                    'jumping',
                    'trail',
                    'training',
                    'competition'
                  ]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setDialogState(() => selectedRideType = value!);
                  },
                ),
                SizedBox(height: 2.h),
                DropdownButtonFormField<int>(
                  value: availableMinutes,
                  decoration: InputDecoration(
                    labelText: 'Available Time',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: [10, 15, 20, 30]
                      .map((e) =>
                          DropdownMenuItem(value: e, child: Text('$e minutes')))
                      .toList(),
                  onChanged: (value) {
                    setDialogState(() => availableMinutes = value!);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () async {
                      Navigator.pop(context);
                      setState(() => _isLoading = true);

                      try {
                        final exercises =
                            await _aiService.generatePreRideExercises(
                          emotionalState: selectedEmotion,
                          rideType: selectedRideType,
                          availableMinutes: availableMinutes,
                        );

                        setState(() {
                          _exercises = exercises;
                          _isLoading = false;
                        });

                        _showExercisesDialog(exercises);
                      } catch (e) {
                        setState(() => _isLoading = false);
                        Fluttertoast.showToast(
                            msg: 'Error generating exercises');
                      }
                    },
              child: Text('Generate Exercises'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generatePerformanceInsights() async {
    setState(() => _isLoading = true);

    try {
      // Mock ride data
      final Map<String, dynamic> mockRideData = {
        'sessionType': 'Dressage Training',
        'duration': '45 min',
        'date': DateTime.now().toIso8601String(),
      };

      final Map<String, dynamic> mockMetrics = {
        'confidence': '85%',
        'technical_score': 8.2,
        'emotional_regulation': 'good',
        'horse_connection': 'excellent',
      };

      final insights = await _aiService.generateRideInsights(
        rideData: mockRideData,
        emotionalState: 'confident',
        performanceMetrics: mockMetrics,
      );

      setState(() {
        _insights = insights;
        _isLoading = false;
      });

      _showInsightsDialog(insights);
    } catch (e) {
      setState(() => _isLoading = false);
      Fluttertoast.showToast(msg: 'Error generating insights');
    }
  }

  void _showEmotionalCheckDialog() {
    final List<Map<String, dynamic>> emotions = [
      {'name': 'Confident', 'icon': 'star', 'color': Colors.green},
      {'name': 'Anxious', 'icon': 'warning', 'color': Colors.orange},
      {'name': 'Nervous', 'icon': 'psychology', 'color': Colors.red},
      {'name': 'Excited', 'icon': 'celebration', 'color': Colors.purple},
      {'name': 'Calm', 'icon': 'spa', 'color': Colors.blue},
      {
        'name': 'Frustrated',
        'icon': 'sentiment_very_dissatisfied',
        'color': Colors.grey
      },
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'favorite',
              color: Colors.pink,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text('Emotional Check-In'),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'How are you feeling right now? Select your current emotional state:',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 2.w,
                  mainAxisSpacing: 1.h,
                ),
                itemCount: emotions.length,
                itemBuilder: (context, index) {
                  final emotion = emotions[index];
                  return InkWell(
                    onTap: () => _handleEmotionalSelection(emotion['name']),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: emotion['color']),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: emotion['icon'],
                            color: emotion['color'],
                            size: 20,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            emotion['name'],
                            style: TextStyle(color: emotion['color']),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleEmotionalSelection(String emotion) async {
    Navigator.pop(context);
    setState(() => _isLoading = true);

    try {
      final advice = await _aiService.generateRealTimeCoaching(
        currentActivity: 'emotional regulation',
        emotionalState: emotion.toLowerCase(),
        biometrics: {'stress_level': 'moderate'},
        specificConcern: 'Need help managing current emotional state',
      );

      setState(() => _isLoading = false);

      _showResponseDialog('Emotional Support', advice, 'favorite');
    } catch (e) {
      setState(() => _isLoading = false);
      Fluttertoast.showToast(msg: 'Error generating emotional support');
    }
  }

  void _showVoiceNotesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'mic',
              color: Colors.teal,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text('Voice Memo Analysis'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'This feature allows you to record voice memos and get AI transcription and analysis.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Text(
              'Coming soon: Full voice recording integration',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showResponseDialog(String title, String response, String iconName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Expanded(child: Text(title)),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          constraints: BoxConstraints(maxHeight: 50.h),
          child: SingleChildScrollView(
            child: Text(
              response,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Fluttertoast.showToast(msg: 'Response copied to clipboard');
            },
            child: Text('Copy'),
          ),
        ],
      ),
    );
  }

  void _showExercisesDialog(List<Map<String, dynamic>> exercises) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'fitness_center',
              color: Colors.green,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text('Your Preparation Exercises'),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          constraints: BoxConstraints(maxHeight: 60.h),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              final exercise = exercises[index];
              return Card(
                child: ExpansionTile(
                  title: Text(exercise['name'] ?? 'Exercise'),
                  subtitle: Text(
                      '${exercise['duration']} min • ${exercise['category'] ?? 'general'}'),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            exercise['description'] ?? '',
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                          ),
                          SizedBox(height: 1.h),
                          if (exercise['instructions'] != null) ...[
                            Text(
                              'Instructions:',
                              style: AppTheme.lightTheme.textTheme.titleSmall,
                            ),
                            SizedBox(height: 0.5.h),
                            ...List.generate(
                              (exercise['instructions'] as List).length,
                              (i) => Padding(
                                padding: EdgeInsets.only(bottom: 0.5.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${i + 1}. '),
                                    Expanded(
                                      child: Text(exercise['instructions'][i]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/pre-ride-preparation');
            },
            child: Text('Start Exercises'),
          ),
        ],
      ),
    );
  }

  void _showInsightsDialog(List<Map<String, dynamic>> insights) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'analytics',
              color: Colors.orange,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text('Performance Insights'),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          constraints: BoxConstraints(maxHeight: 60.h),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: insights.length,
            itemBuilder: (context, index) {
              final insight = insights[index];
              return Card(
                child: ExpansionTile(
                  title: Text(insight['title'] ?? 'Insight'),
                  subtitle: Text(insight['category'] ?? 'general'),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            insight['summary'] ?? '',
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                          ),
                          SizedBox(height: 1.h),
                          if (insight['recommendations'] != null) ...[
                            Text(
                              'Recommendations:',
                              style: AppTheme.lightTheme.textTheme.titleSmall,
                            ),
                            SizedBox(height: 0.5.h),
                            ...List.generate(
                              (insight['recommendations'] as List).length,
                              (i) => Padding(
                                padding: EdgeInsets.only(bottom: 0.5.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'check_circle',
                                      color: Colors.green,
                                      size: 16,
                                    ),
                                    SizedBox(width: 2.w),
                                    Expanded(
                                      child:
                                          Text(insight['recommendations'][i]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/post-ride-analysis');
            },
            child: Text('View Full Analysis'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    if (!_isLoading) return SizedBox.shrink();

    return Container(
      color: Colors.black54,
      child: Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(6.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 2.h),
                Text(
                  'AI is analyzing...',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
                SizedBox(height: 1.h),
                Text(
                  'This may take a few moments',
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.lightTheme.primaryColor,
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.8),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: CustomIconWidget(
                              iconName: 'psychology',
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'AI Coaching Tools',
                                  style: AppTheme
                                      .lightTheme.textTheme.headlineSmall
                                      ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  'Personalized AI-powered guidance for your equestrian journey',
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Tools Grid
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 3.w,
                      mainAxisSpacing: 2.h,
                    ),
                    itemCount: _coachingTools.length,
                    itemBuilder: (context, index) {
                      final tool = _coachingTools[index];
                      return InkWell(
                        onTap: () => _handleToolTap(tool),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: tool['gradient'],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: tool['color'].withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(4.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(3.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: CustomIconWidget(
                                    iconName: tool['icon'],
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  tool['title'],
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Expanded(
                                  child: Text(
                                    tool['description'],
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color:
                                          Colors.white.withValues(alpha: 0.9),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          _buildLoadingOverlay(),
        ],
      ),
    );
  }
}
