import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../theme/app_theme.dart';

class ClinicalNotesWidget extends StatefulWidget {
  const ClinicalNotesWidget({super.key});

  @override
  State<ClinicalNotesWidget> createState() => _ClinicalNotesWidgetState();
}

class _ClinicalNotesWidgetState extends State<ClinicalNotesWidget> {
  final TextEditingController _noteController = TextEditingController();
  final List<Map<String, dynamic>> _notes = [];
  bool _isAddingNote = false;

  @override
  void initState() {
    super.initState();
    _loadExistingNotes();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _loadExistingNotes() {
    // Sample clinical notes - would be loaded from secure storage
    setState(() {
      _notes.addAll([
        {
          'id': '1',
          'date': DateTime.now().subtract(const Duration(days: 3)),
          'content':
              'Pre-ride anxiety significantly reduced after implementing Chapter 6 breathing techniques. Horse responded positively to calmer energy.',
          'category': 'Progress',
          'assessmentRef': 'GAD-7 (Score: 6)',
          'tags': ['anxiety', 'breathing', 'improvement'],
        },
        {
          'id': '2',
          'date': DateTime.now().subtract(const Duration(days: 7)),
          'content':
              'Challenging session with new horse. Triggered past fear responses. Applied CBT techniques from intervention library. Need to continue exposure therapy protocol.',
          'category': 'Setback',
          'assessmentRef': 'EQCS (Score: 4)',
          'tags': ['fear', 'exposure', 'cbt'],
        },
        {
          'id': '3',
          'date': DateTime.now().subtract(const Duration(days: 14)),
          'content':
              'Breakthrough moment during ground work exercise. Felt genuine connection and trust with horse. Confidence building exercises showing measurable impact.',
          'category': 'Milestone',
          'assessmentRef': 'HHRQ (Score: 9)',
          'tags': ['breakthrough', 'connection', 'confidence'],
        },
      ]);
    });
  }

  void _addNote() {
    if (_noteController.text.trim().isEmpty) return;

    setState(() {
      _notes.insert(0, {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'date': DateTime.now(),
        'content': _noteController.text.trim(),
        'category': 'General',
        'assessmentRef': null,
        'tags': [],
      });
      _noteController.clear();
      _isAddingNote = false;
    });
  }

  void _deleteNote(String noteId) {
    setState(() {
      _notes.removeWhere((note) => note['id'] == noteId);
    });
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Progress':
        return AppTheme.successLight;
      case 'Setback':
        return AppTheme.warningLight;
      case 'Milestone':
        return AppTheme.primaryLight;
      default:
        return AppTheme.textSecondaryLight;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Progress':
        return Icons.trending_up;
      case 'Setback':
        return Icons.warning_amber;
      case 'Milestone':
        return Icons.flag;
      default:
        return Icons.note;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        if (_isAddingNote) _buildNoteInput(),
        Expanded(
          child: _notes.isEmpty ? _buildEmptyState() : _buildNotesList(),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.dividerLight,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.note_add,
            color: AppTheme.primaryLight,
            size: 6.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Clinical Notes',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryLight,
                  ),
                ),
                Text(
                  'Secure documentation with timestamp tracking',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          FloatingActionButton.small(
            onPressed: () => setState(() => _isAddingNote = !_isAddingNote),
            backgroundColor: AppTheme.primaryLight,
            foregroundColor: AppTheme.onPrimaryLight,
            child: Icon(_isAddingNote ? Icons.close : Icons.add),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteInput() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.dividerLight,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Clinical Note',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryLight,
            ),
          ),
          SizedBox(height: 2.w),
          TextField(
            controller: _noteController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText:
                  'Document therapeutic progress, setbacks, insights, or observations...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2.w),
              ),
            ),
          ),
          SizedBox(height: 3.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => setState(() => _isAddingNote = false),
                child: const Text('Cancel'),
              ),
              SizedBox(width: 2.w),
              ElevatedButton(
                onPressed: _addNote,
                child: const Text('Add Note'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.note_alt_outlined,
            size: 20.w,
            color: AppTheme.textSecondaryLight,
          ),
          SizedBox(height: 4.w),
          Text(
            'No Clinical Notes Yet',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondaryLight,
            ),
          ),
          SizedBox(height: 2.w),
          Text(
            'Start documenting your therapeutic journey',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppTheme.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesList() {
    return ListView.builder(
      padding: EdgeInsets.all(4.w),
      itemCount: _notes.length,
      itemBuilder: (context, index) {
        final note = _notes[index];
        return _buildNoteCard(note);
      },
    );
  }

  Widget _buildNoteCard(Map<String, dynamic> note) {
    final category = note['category'] as String;
    final date = note['date'] as DateTime;

    return Container(
      margin: EdgeInsets.only(bottom: 3.w),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3.w),
          side: BorderSide(
            color: _getCategoryColor(category).withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(category).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(1.5.w),
                    ),
                    child: Icon(
                      _getCategoryIcon(category),
                      color: _getCategoryColor(category),
                      size: 4.w,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: _getCategoryColor(category),
                          ),
                        ),
                        Text(
                          '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppTheme.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _deleteNote(note['id']),
                    icon: Icon(
                      Icons.delete_outline,
                      color: AppTheme.errorLight,
                      size: 5.w,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.w),
              Text(
                note['content'],
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppTheme.textPrimaryLight,
                  height: 1.4,
                ),
              ),
              if (note['assessmentRef'] != null) ...[
                SizedBox(height: 3.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(1.w),
                  ),
                  child: Text(
                    'Assessment: ${note['assessmentRef']}',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppTheme.primaryLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
              if (note['tags'] != null &&
                  (note['tags'] as List).isNotEmpty) ...[
                SizedBox(height: 2.w),
                Wrap(
                  spacing: 1.w,
                  children: (note['tags'] as List<String>)
                      .map(
                        (tag) => Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.w),
                          decoration: BoxDecoration(
                            color: AppTheme.textSecondaryLight
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(1.w),
                          ),
                          child: Text(
                            '#$tag',
                            style: TextStyle(
                              fontSize: 9.sp,
                              color: AppTheme.textSecondaryLight,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
