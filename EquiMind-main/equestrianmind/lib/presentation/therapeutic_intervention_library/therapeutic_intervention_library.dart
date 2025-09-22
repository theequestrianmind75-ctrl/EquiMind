import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/therapeutic_intervention_service.dart';
import '../../theme/app_theme.dart';
import './widgets/book_integration_widget.dart';
import './widgets/intervention_card_widget.dart';
import './widgets/intervention_category_tabs_widget.dart';
import './widgets/professional_consultation_widget.dart';
import './widgets/progress_tracker_widget.dart';

class TherapeuticInterventionLibrary extends StatefulWidget {
  const TherapeuticInterventionLibrary({super.key});

  @override
  State<TherapeuticInterventionLibrary> createState() =>
      _TherapeuticInterventionLibraryState();
}

class _TherapeuticInterventionLibraryState
    extends State<TherapeuticInterventionLibrary>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TherapeuticInterventionService _interventionService =
      TherapeuticInterventionService();
  bool _isLoading = false;
  String _selectedCategory = 'CBT';
  Map<String, dynamic>? _activeIntervention;
  List<Map<String, dynamic>> _personalizedInterventions = [];

  final List<Map<String, dynamic>> _interventionCategories = [
    {
      'id': 'CBT',
      'name': 'CBT Techniques',
      'icon': Icons.psychology_outlined,
      'color': Colors.blue,
      'description':
          'Cognitive Behavioral Therapy protocols for equestrian-specific concerns',
      'techniques': [
        'Thought Records',
        'Behavioral Experiments',
        'Cognitive Restructuring'
      ]
    },
    {
      'id': 'MINDFULNESS',
      'name': 'Mindfulness Practices',
      'icon': Icons.self_improvement_outlined,
      'color': Colors.green,
      'description': 'Present-moment awareness and mindful riding techniques',
      'techniques': ['Body Awareness', 'Breath Work', 'Horse Connection']
    },
    {
      'id': 'EXPOSURE',
      'name': 'Exposure Therapy',
      'icon': Icons.trending_up_outlined,
      'color': Colors.orange,
      'description': 'Systematic desensitization protocols for riding fears',
      'techniques': [
        'Gradual Exposure',
        'Systematic Desensitization',
        'Fear Hierarchy'
      ]
    },
    {
      'id': 'EQUINE_ASSISTED',
      'name': 'Equine-Assisted Interventions',
      'icon': Icons.pets_outlined,
      'color': Colors.purple,
      'description': 'Therapeutic protocols leveraging horse-human connection',
      'techniques': [
        'Ground Work',
        'Relationship Building',
        'Emotional Mirroring'
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _loadPersonalizedInterventions();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadPersonalizedInterventions() async {
    setState(() => _isLoading = true);

    try {
      // Load interventions based on assessment results and user profile
      await Future.delayed(
          const Duration(milliseconds: 800)); // Simulated AI processing

      if (mounted) {
        setState(() {
          _personalizedInterventions = _generateSampleInterventions();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading interventions: ${e.toString()}'),
            backgroundColor: AppTheme.errorLight,
          ),
        );
      }
    }
  }

  List<Map<String, dynamic>> _generateSampleInterventions() {
    // This would be replaced with actual AI-generated interventions
    return [
      {
        'id': 'cbt_anxiety_protocol',
        'title': 'Pre-Ride Anxiety Management',
        'category': 'CBT',
        'duration': 15,
        'difficulty': 'Beginner',
        'effectiveness': 4.5,
        'description':
            'Evidence-based CBT protocol for managing pre-ride anxiety using thought records and behavioral experiments',
        'bookChapter': 'Chapter 6: Cognitive Restructuring for Riders',
        'steps': [
          'Identify anxious thoughts about riding',
          'Rate anxiety level (1-10)',
          'Challenge negative predictions',
          'Generate balanced alternatives',
          'Test new thoughts through action'
        ],
        'professionalGuidance': true,
        'audioAvailable': true,
      },
      {
        'id': 'mindfulness_connection',
        'title': 'Horse-Human Connection Meditation',
        'category': 'MINDFULNESS',
        'duration': 20,
        'difficulty': 'Intermediate',
        'effectiveness': 4.8,
        'description':
            'Mindfulness practice designed to deepen the emotional and energetic connection with your horse',
        'bookChapter': 'Chapter 8: Mindful Riding Techniques',
        'steps': [
          'Ground yourself beside your horse',
          'Synchronize breathing with horse',
          'Practice present-moment awareness',
          'Notice horse\'s emotional state',
          'Cultivate mutual trust and calm'
        ],
        'professionalGuidance': true,
        'audioAvailable': true,
      }
    ];
  }

  Future<void> _startIntervention(Map<String, dynamic> intervention) async {
    setState(() {
      _activeIntervention = intervention;
      _isLoading = true;
    });

    try {
      // Generate personalized protocol using AI
      late Map<String, dynamic> protocol;

      switch (intervention['category']) {
        case 'CBT':
          protocol = await _interventionService.generateCBTIntervention(
            targetConcern: intervention['title'],
            assessmentResults: {'anxiety': 7, 'confidence': 4},
            riderLevel: 'intermediate',
            specificTriggers: ['mounting', 'jumping', 'trail riding'],
          );
          break;
        case 'MINDFULNESS':
          protocol = await _interventionService.generateMindfulnessIntervention(
            ridingContext: intervention['title'],
            emotionalState: 'anxious',
            sessionDuration: intervention['duration'],
            includeAudioGuidance: intervention['audioAvailable'],
          );
          break;
        case 'EXPOSURE':
          protocol = await _interventionService.generateExposureTherapyProtocol(
            specificFear: intervention['title'],
            fearIntensity: 'moderate',
            avoidanceBehaviors: {'mounting': true, 'cantering': false},
            safetyResources: 'Certified instructor, calm horse, enclosed arena',
          );
          break;
        case 'EQUINE_ASSISTED':
          protocol =
              await _interventionService.generateEquineAssistedIntervention(
            therapeuticGoals: intervention['title'],
            horseTemperament: 'calm and responsive',
            riderExperience: 'intermediate',
            environmentalFactors: 'indoor arena, quiet setting',
          );
          break;
        default:
          protocol = {'error': 'Unknown intervention category'};
      }

      await Navigator.pushNamed(
        context,
        '/intervention-session',
        arguments: {
          'intervention': intervention,
          'protocol': protocol,
        },
      );

      // Refresh progress tracking
      await _loadPersonalizedInterventions();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error starting intervention: ${e.toString()}'),
          backgroundColor: AppTheme.errorLight,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildProfessionalHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryLight, AppTheme.secondaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.local_hospital_outlined,
                  color: AppTheme.onPrimaryLight,
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Therapeutic Intervention Library',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.onPrimaryLight,
                        ),
                      ),
                      Text(
                        'Professional-Grade • Evidence-Based • Book-Integrated',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppTheme.onPrimaryLight.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.psychology,
                  color: AppTheme.accentLight,
                  size: 6.w,
                ),
              ],
            ),
            SizedBox(height: 3.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.w),
              decoration: BoxDecoration(
                color: AppTheme.onPrimaryLight.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.auto_stories,
                    color: AppTheme.accentLight,
                    size: 4.w,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'AI-powered interventions seamlessly integrated with specialized book content and clinical protocols',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppTheme.onPrimaryLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildInterventionsTab(),
        _buildProgressTab(),
        _buildBookIntegrationTab(),
        _buildCrisisTab(),
        _buildConsultationTab(),
      ],
    );
  }

  Widget _buildInterventionsTab() {
    return Column(
      children: [
        InterventionCategoryTabsWidget(
          categories: _interventionCategories,
          selectedCategory: _selectedCategory,
          onCategorySelected: (category) {
            setState(() => _selectedCategory = category);
          },
        ),
        Expanded(
          child: _isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.primaryLight),
                      ),
                      SizedBox(height: 4.w),
                      Text(
                        'Generating personalized interventions...',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppTheme.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(4.w),
                  itemCount: _personalizedInterventions.length,
                  itemBuilder: (context, index) {
                    final intervention = _personalizedInterventions[index];
                    return InterventionCardWidget(
                      intervention: intervention,
                      onStart: () => _startIntervention(intervention),
                      onBookmark: () => _bookmarkIntervention(intervention),
                      onShare: () => _shareIntervention(intervention),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildProgressTab() {
    return ProgressTrackerWidget(
      interventions: _personalizedInterventions,
    );
  }

  Widget _buildBookIntegrationTab() {
    return BookIntegrationWidget(
      selectedCategory: _selectedCategory,
    );
  }

  Widget _buildCrisisTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.errorLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(3.w),
              border: Border.all(color: AppTheme.errorLight, width: 2),
            ),
            child: Column(
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
                    Text(
                      'Crisis Intervention Resources',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.errorLight,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.w),
                Text(
                  'Immediate access to grounding techniques, panic management protocols, and emergency contact systems.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppTheme.textPrimaryLight,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 4.w),
                _buildCrisisButton('Grounding Techniques', Icons.spa,
                    () => _showGroundingTechniques()),
                SizedBox(height: 2.w),
                _buildCrisisButton('Panic Management', Icons.favorite,
                    () => _showPanicProtocol()),
                SizedBox(height: 2.w),
                _buildCrisisButton('Emergency Contacts', Icons.phone,
                    () => _showEmergencyContacts()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsultationTab() {
    return ProfessionalConsultationWidget(
      onScheduleConsultation: _scheduleConsultation,
    );
  }

  Widget _buildCrisisButton(
      String title, IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(title),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.errorLight,
          foregroundColor: AppTheme.onErrorLight,
          padding: EdgeInsets.symmetric(vertical: 4.w),
        ),
      ),
    );
  }

  void _showGroundingTechniques() {
    // Implementation for grounding techniques modal
  }

  void _showPanicProtocol() {
    // Implementation for panic management protocol
  }

  void _showEmergencyContacts() {
    // Implementation for emergency contacts
  }

  void _bookmarkIntervention(Map<String, dynamic> intervention) {
    // Implementation for bookmarking interventions
  }

  void _shareIntervention(Map<String, dynamic> intervention) {
    // Implementation for sharing interventions
  }

  void _scheduleConsultation() {
    // Implementation for scheduling professional consultation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Column(
        children: [
          _buildProfessionalHeader(),
          Container(
            color: AppTheme.surfaceLight,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: const [
                Tab(icon: Icon(Icons.psychology), text: 'Interventions'),
                Tab(icon: Icon(Icons.trending_up), text: 'Progress'),
                Tab(icon: Icon(Icons.book), text: 'Book Content'),
                Tab(icon: Icon(Icons.emergency), text: 'Crisis'),
                Tab(icon: Icon(Icons.support_agent), text: 'Consultation'),
              ],
            ),
          ),
          Expanded(
            child: _buildTabContent(),
          ),
        ],
      ),
    );
  }
}
