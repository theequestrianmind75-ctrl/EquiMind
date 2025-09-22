import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../theme/app_theme.dart';

class ProfessionalConsultationWidget extends StatefulWidget {
  final VoidCallback onScheduleConsultation;

  const ProfessionalConsultationWidget({
    super.key,
    required this.onScheduleConsultation,
  });

  @override
  State<ProfessionalConsultationWidget> createState() =>
      _ProfessionalConsultationWidgetState();
}

class _ProfessionalConsultationWidgetState
    extends State<ProfessionalConsultationWidget> {
  String _selectedSpecialty = 'equestrian_psychologist';
  String _selectedUrgency = 'routine';
  final TextEditingController _concernsController = TextEditingController();
  bool _isSubmitting = false;

  final List<Map<String, dynamic>> _specialists = [
    {
      'id': 'equestrian_psychologist',
      'name': 'Equestrian Sports Psychologist',
      'description':
          'Licensed psychologist specializing in equestrian mental performance and rider psychology',
      'icon': Icons.psychology,
      'color': Colors.blue,
      'availability': 'Available within 1-2 weeks',
    },
    {
      'id': 'trauma_specialist',
      'name': 'Trauma-Informed Therapist',
      'description':
          'Specialized in riding-related trauma recovery and EMDR therapy for equestrians',
      'icon': Icons.healing,
      'color': Colors.green,
      'availability': 'Available within 3-5 days',
    },
    {
      'id': 'anxiety_specialist',
      'name': 'Anxiety Disorders Specialist',
      'description':
          'Expert in CBT and exposure therapy for riding fears and performance anxiety',
      'icon': Icons.spa,
      'color': Colors.purple,
      'availability': 'Available within 1 week',
    },
    {
      'id': 'equine_therapist',
      'name': 'Equine-Assisted Therapist',
      'description':
          'Certified in equine-assisted psychotherapy and therapeutic riding programs',
      'icon': Icons.pets,
      'color': Colors.orange,
      'availability': 'Available within 2-3 weeks',
    },
  ];

  @override
  void dispose() {
    _concernsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: 4.w),
          _buildSpecialtySelection(),
          SizedBox(height: 4.w),
          _buildUrgencySelection(),
          SizedBox(height: 4.w),
          _buildConcernsInput(),
          SizedBox(height: 4.w),
          _buildConsultationBenefits(),
          SizedBox(height: 4.w),
          _buildSubmitButton(),
          SizedBox(height: 4.w),
          _buildResourcesSection(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryLight.withValues(alpha: 0.1),
            AppTheme.accentLight.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(3.w),
      ),
      child: Row(
        children: [
          Icon(
            Icons.support_agent,
            color: AppTheme.primaryLight,
            size: 6.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Professional Consultation',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryLight,
                  ),
                ),
                Text(
                  'Connect with licensed mental health professionals specializing in equestrian psychology',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppTheme.textSecondaryLight,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialtySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Specialist Type',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryLight,
          ),
        ),
        SizedBox(height: 3.w),
        ..._specialists.map((specialist) => _buildSpecialistCard(specialist)),
      ],
    );
  }

  Widget _buildSpecialistCard(Map<String, dynamic> specialist) {
    final isSelected = _selectedSpecialty == specialist['id'];

    return Container(
      margin: EdgeInsets.only(bottom: 3.w),
      child: InkWell(
        onTap: () => setState(() => _selectedSpecialty = specialist['id']),
        borderRadius: BorderRadius.circular(3.w),
        child: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: isSelected
                ? specialist['color'].withValues(alpha: 0.1)
                : AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(3.w),
            border: Border.all(
              color: isSelected ? specialist['color'] : AppTheme.dividerLight,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: specialist['color'].withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Icon(
                  specialist['icon'],
                  color: specialist['color'],
                  size: 6.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      specialist['name'],
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? specialist['color']
                            : AppTheme.textPrimaryLight,
                      ),
                    ),
                    Text(
                      specialist['description'],
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppTheme.textSecondaryLight,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 1.w),
                    Text(
                      specialist['availability'],
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppTheme.successLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: specialist['color'],
                  size: 5.w,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUrgencySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Urgency Level',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryLight,
          ),
        ),
        SizedBox(height: 3.w),
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(2.w),
          ),
          child: Column(
            children: [
              RadioListTile<String>(
                title: Text('Routine Consultation'),
                subtitle: Text('Standard scheduling (1-2 weeks)'),
                value: 'routine',
                groupValue: _selectedUrgency,
                onChanged: (value) => setState(() => _selectedUrgency = value!),
                dense: true,
              ),
              RadioListTile<String>(
                title: Text('Urgent - Priority Scheduling'),
                subtitle: Text('Within 2-3 days'),
                value: 'urgent',
                groupValue: _selectedUrgency,
                onChanged: (value) => setState(() => _selectedUrgency = value!),
                dense: true,
              ),
              RadioListTile<String>(
                title: Text('Crisis - Immediate Support'),
                subtitle: Text('Within 24-48 hours'),
                value: 'crisis',
                groupValue: _selectedUrgency,
                onChanged: (value) => setState(() => _selectedUrgency = value!),
                dense: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConcernsInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Describe Your Concerns',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryLight,
          ),
        ),
        SizedBox(height: 2.w),
        Text(
          'Share any specific challenges, symptoms, or goals you\'d like to address',
          style: TextStyle(
            fontSize: 12.sp,
            color: AppTheme.textSecondaryLight,
          ),
        ),
        SizedBox(height: 3.w),
        TextField(
          controller: _concernsController,
          maxLines: 5,
          decoration: InputDecoration(
            hintText:
                'Example: I\'ve been experiencing increased anxiety before rides since my fall last month. Looking for help with confidence rebuilding and trauma processing...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.w),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConsultationBenefits() {
    final benefits = [
      {
        'icon': Icons.verified_user,
        'title': 'Licensed Professionals',
        'description':
            'All specialists are licensed mental health professionals',
      },
      {
        'icon': Icons.security,
        'title': 'Confidential Sessions',
        'description': 'HIPAA-compliant secure video consultations',
      },
      {
        'icon': Icons.psychology,
        'title': 'Specialized Expertise',
        'description': 'Deep understanding of equestrian-specific challenges',
      },
      {
        'icon': Icons.support,
        'title': 'Ongoing Support',
        'description': 'Follow-up care and intervention adjustments',
      },
    ];

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.successLight.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: AppTheme.successLight.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Consultation Benefits',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryLight,
            ),
          ),
          SizedBox(height: 3.w),
          ...benefits.map((benefit) => Container(
                margin: EdgeInsets.only(bottom: 2.w),
                child: Row(
                  children: [
                    Icon(
                      benefit['icon'] as IconData,
                      color: AppTheme.successLight,
                      size: 5.w,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            benefit['title'] as String,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimaryLight,
                            ),
                          ),
                          Text(
                            benefit['description'] as String,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppTheme.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isSubmitting ? null : _submitConsultationRequest,
        icon: _isSubmitting
            ? SizedBox(
                width: 4.w,
                height: 4.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppTheme.onPrimaryLight),
                ),
              )
            : Icon(Icons.send),
        label: Text(
          _isSubmitting ? 'Submitting Request...' : 'Request Consultation',
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 4.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.w),
          ),
        ),
      ),
    );
  }

  Widget _buildResourcesSection() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.warningLight.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: AppTheme.warningLight.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppTheme.warningLight,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Immediate Support Resources',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryLight,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.w),
          Text(
            'If you\'re experiencing a mental health emergency:',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppTheme.textPrimaryLight,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.w),
          Text(
            '• Crisis Text Line: Text HOME to 741741\n• National Suicide Prevention Lifeline: 988\n• Emergency Services: 911',
            style: TextStyle(
              fontSize: 11.sp,
              color: AppTheme.textSecondaryLight,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitConsultationRequest() async {
    if (_concernsController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please describe your concerns'),
          backgroundColor: AppTheme.warningLight,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Simulate consultation request submission
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Consultation request submitted successfully!'),
            backgroundColor: AppTheme.successLight,
            duration: const Duration(seconds: 4),
          ),
        );

        // Clear form
        _concernsController.clear();
        setState(() {
          _selectedSpecialty = 'equestrian_psychologist';
          _selectedUrgency = 'routine';
        });

        widget.onScheduleConsultation();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting request: ${e.toString()}'),
            backgroundColor: AppTheme.errorLight,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}
