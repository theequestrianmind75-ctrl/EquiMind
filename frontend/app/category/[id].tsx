import React, { useEffect, useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  ActivityIndicator,
  TextInput,
  Alert,
  Modal,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useRouter, useLocalSearchParams } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import * as Speech from 'expo-speech';
import api from '../../lib/api';

interface Strategy {
  id: string;
  name: string;
  category: string;
  description: string | null;
  duration_minutes: number;
  instructions: string;
  anxiety_level: number[];
  confidence_level: number[];
  effectiveness_rating: number;
}

const CATEGORIES: any = {
  mindfulness: {
    title: 'Mindfulness and Flow',
    color: '#10b981',
    keywords: ['mindfulness', 'flow'],
    excludeKeywords: ['tapping', 'eft'],
  },
  breathing: {
    title: 'Breathing',
    color: '#375B50',
    keywords: ['breathing'],
    excludeKeywords: ['tapping', 'eft'],
  },
  emotional: {
    title: 'Emotional Regulation',
    color: '#f59e0b',
    keywords: ['activation', 'emotional', 'regulation'],
    excludeKeywords: ['tapping', 'eft'],
  },
  grounding: {
    title: 'Grounding',
    color: '#06b6d4',
    keywords: ['grounding'],
    excludeKeywords: ['tapping', 'eft'],
  },
  somatic: {
    title: 'Somatic Tools',
    color: '#8b5cf6',
    keywords: ['somatic'],
    excludeKeywords: ['tapping', 'eft'],
  },
  tapping: {
    title: 'Tapping',
    color: '#ec4899',
    keywords: ['tapping', 'eft'],
    description: 'EFT (Emotional Freedom Technique) or "tapping" uses gentle tapping on specific acupressure points to reduce stress and anxiety. This technique helps calm your nervous system before riding, during challenging moments, or after a difficult session.',
  },
  'horse-rider': {
    title: 'Horse-Rider Connection',
    color: '#14b8a6',
    keywords: ['co-regulation', 'cueing', 'connection', 'horse-rider'],
    description: 'These tools focus on strengthening the bond between you and your horse. By understanding co-regulation, improving communication through cueing, and building trust, you create a partnership that enhances both performance and the riding experience.',
    excludeKeywords: ['tapping', 'eft'],
  },
};

const ADMIN_PASSWORD = 'equimind2025';

export default function CategoryDetail() {
  const router = useRouter();
  const { id } = useLocalSearchParams();
  const [strategies, setStrategies] = useState<Strategy[]>([]);
  const [loading, setLoading] = useState(true);
  const [playingId, setPlayingId] = useState<string | null>(null);
  const [editMode, setEditMode] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [editedStrategy, setEditedStrategy] = useState<Strategy | null>(null);
  const [saving, setSaving] = useState(false);
  const [showPasswordPrompt, setShowPasswordPrompt] = useState(false);
  const [passwordInput, setPasswordInput] = useState('');

  const category = CATEGORIES[id as string];

  useEffect(() => {
    if (id && category) {
      fetchStrategies();
    }
  }, [id]);

  const fetchStrategies = async () => {
    try {
      const response = await api.get('/mental-strategies');
      const allStrategies = response.data;

      // Filter strategies by category keywords and exclude keywords
      const filtered = allStrategies.filter((s: Strategy) => {
        const categoryLower = s.category.toLowerCase();
        const nameLower = s.name.toLowerCase();
        const instructionsLower = s.instructions.toLowerCase();
        
        // Check if strategy matches category keywords
        const matchesCategory = category.keywords.some((keyword: string) =>
          categoryLower.includes(keyword.toLowerCase()) ||
          nameLower.includes(keyword.toLowerCase()) ||
          instructionsLower.includes(keyword.toLowerCase())
        );
        
        // Check if strategy should be excluded (e.g., tapping in non-tapping categories)
        const shouldExclude = category.excludeKeywords && category.excludeKeywords.some((keyword: string) =>
          categoryLower.includes(keyword.toLowerCase()) ||
          nameLower.includes(keyword.toLowerCase()) ||
          instructionsLower.includes(keyword.toLowerCase())
        );
        
        return matchesCategory && !shouldExclude;
      });

      // Remove duplicates by using a Map keyed by strategy ID
      const uniqueStrategies = Array.from(
        new Map(filtered.map((s: Strategy) => [s.id, s])).values()
      );

      setStrategies(uniqueStrategies);
    } catch (error) {
      console.error('Error fetching strategies:', error);
    } finally {
      setLoading(false);
    }
  };

  const cleanInstructions = (instructions: string): string => {
    // Remove "Micro Script:" and "Audio Script:" labels
    let cleaned = instructions
      .replace(/Micro Script:\s*/gi, '')
      .replace(/Audio Script:\s*/gi, '')
      .replace(/Coach:\s*/gi, '')
      .trim();
    
    // Split by double newlines to get paragraphs
    const paragraphs = cleaned.split(/\n\n+/);
    
    // If there are multiple paragraphs, skip the first one (description) and return the rest
    if (paragraphs.length > 1) {
      // Remove the first paragraph and join the rest
      return paragraphs.slice(1).join('\n\n').trim();
    }
    
    return cleaned;
  };

  const extractAudioScript = (instructions: string): string => {
    // Try to find audio script section
    const match = instructions.match(/Audio Script:\s*([\s\S]*?)(?:\n\n|$)/);
    if (match && match[1]) {
      return match[1].replace(/Coach:\s*/gi, '').trim();
    }
    
    // If no audio script found, try to find text after "Micro Script:"
    const microMatch = instructions.match(/Micro Script:\s*([\s\S]*?)(?:\n\n|Audio Script:|$)/);
    if (microMatch && microMatch[1]) {
      return microMatch[1].replace(/Coach:\s*/gi, '').trim();
    }
    
    return instructions.replace(/Coach:\s*/gi, '').trim();
  };

  const handlePlayAudio = (strategy: Strategy) => {
    if (playingId === strategy.id) {
      Speech.stop();
      setPlayingId(null);
      return;
    }

    const audioScript = extractAudioScript(strategy.instructions);
    setPlayingId(strategy.id);

    Speech.speak(audioScript, {
      language: 'en',
      pitch: 1.0,
      rate: 0.9,
      onDone: () => setPlayingId(null),
      onError: () => setPlayingId(null),
    });
  };

  const handleEditModeToggle = () => {
    if (!editMode) {
      setShowPasswordPrompt(true);
    } else {
      setEditMode(false);
      setEditingId(null);
      setEditedStrategy(null);
    }
  };

  const handlePasswordSubmit = () => {
    if (passwordInput === ADMIN_PASSWORD) {
      setEditMode(true);
      setShowPasswordPrompt(false);
      setPasswordInput('');
      Alert.alert('Edit Mode Enabled', 'Click any tool to edit it');
    } else {
      Alert.alert('Incorrect Password', 'Please try again');
      setPasswordInput('');
    }
  };

  const handleEditClick = (strategy: Strategy) => {
    if (!editMode) return;
    setEditingId(strategy.id);
    setEditedStrategy({...strategy});
  };

  const handleCancelEdit = () => {
    setEditingId(null);
    setEditedStrategy(null);
  };

  const handleSaveEdit = async () => {
    if (!editedStrategy) return;

    setSaving(true);
    try {
      await api.patch(`/mental-strategies/${editedStrategy.id}`, {
        name: editedStrategy.name,
        instructions: editedStrategy.instructions,
        duration_minutes: editedStrategy.duration_minutes,
        category: editedStrategy.category,
      });

      // Update local state
      setStrategies(strategies.map(s => 
        s.id === editedStrategy.id ? editedStrategy : s
      ));
      
      setEditingId(null);
      setEditedStrategy(null);
      Alert.alert('Success', 'Tool updated successfully!');
    } catch (error: any) {
      Alert.alert('Error', error.message || 'Failed to update tool');
    } finally {
      setSaving(false);
    }
  };

  if (loading) {
    return (
      <SafeAreaView style={styles.container} edges={['top']}>
        <View style={styles.loadingContainer}>
          <ActivityIndicator size="large" color={category?.color || '#3b82f6'} />
          <Text style={styles.loadingText}>Loading tools...</Text>
        </View>
      </SafeAreaView>
    );
  }

  if (!category) {
    return (
      <SafeAreaView style={styles.container} edges={['top']}>
        <View style={styles.header}>
          <TouchableOpacity onPress={() => router.back()} style={styles.backButton}>
            <Ionicons name="arrow-back" size={24} color="#f1f5f9" />
          </TouchableOpacity>
          <Text style={styles.title}>Category Not Found</Text>
        </View>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView style={styles.container} edges={['top']}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()} style={styles.backButton}>
          <Ionicons name="arrow-back" size={24} color="#f1f5f9" />
        </TouchableOpacity>
        <Text style={styles.title}>{category.title}</Text>
        <TouchableOpacity onPress={handleEditModeToggle} style={styles.editButton}>
          <Ionicons 
            name={editMode ? 'close-circle' : 'create'} 
            size={24} 
            color={editMode ? '#ef4444' : '#375B50'} 
          />
        </TouchableOpacity>
      </View>

      <ScrollView style={styles.scrollView}>
        {category.description && (
          <View style={styles.descriptionCard}>
            <Text style={styles.descriptionText}>{category.description}</Text>
            {id === 'tapping' && (
              <TouchableOpacity
                style={styles.guideButton}
                onPress={() => router.push('/tapping-guide' as any)}
              >
                <Ionicons name="book" size={20} color="#ffffff" />
                <Text style={styles.guideButtonText}>View Full Tapping Guide</Text>
              </TouchableOpacity>
            )}
            {id === 'horse-rider' && (
              <TouchableOpacity
                style={[styles.guideButton, { backgroundColor: '#14b8a6' }]}
                onPress={() => router.push('/horse-rider-connection' as any)}
              >
                <Ionicons name="clipboard" size={20} color="#ffffff" />
                <Text style={styles.guideButtonText}>Complete Rider Profile</Text>
              </TouchableOpacity>
            )}
          </View>
        )}
        
        {editMode && (
          <View style={styles.editModeIndicator}>
            <Ionicons name="create" size={20} color="#ef4444" />
            <Text style={styles.editModeText}>Edit Mode Active - Click any tool to edit</Text>
          </View>
        )}

        <Text style={styles.subtitle}>{strategies.length} tools available</Text>

        {strategies.map((strategy) => (
          <TouchableOpacity
            key={strategy.id}
            style={[
              styles.toolCard,
              editMode && styles.toolCardEditable,
              editingId === strategy.id && styles.toolCardEditing,
            ]}
            onPress={() => editMode && handleEditClick(strategy)}
            activeOpacity={editMode ? 0.7 : 1}
          >
            {editingId === strategy.id && editedStrategy ? (
              // Edit Mode
              <View style={styles.editContainer}>
                <Text style={styles.editLabel}>Tool Name:</Text>
                <TextInput
                  style={styles.editInput}
                  value={editedStrategy.name}
                  onChangeText={(text) => setEditedStrategy({...editedStrategy, name: text})}
                  multiline
                />

                <Text style={styles.editLabel}>Duration (minutes):</Text>
                <TextInput
                  style={styles.editInput}
                  value={String(editedStrategy.duration_minutes)}
                  onChangeText={(text) => setEditedStrategy({
                    ...editedStrategy, 
                    duration_minutes: parseInt(text) || 0
                  })}
                  keyboardType="numeric"
                />

                <Text style={styles.editLabel}>Instructions:</Text>
                <TextInput
                  style={[styles.editInput, styles.editInputLarge]}
                  value={editedStrategy.instructions}
                  onChangeText={(text) => setEditedStrategy({...editedStrategy, instructions: text})}
                  multiline
                  numberOfLines={8}
                />

                <View style={styles.editActions}>
                  <TouchableOpacity
                    style={[styles.editActionButton, styles.cancelButton]}
                    onPress={handleCancelEdit}
                  >
                    <Ionicons name="close" size={20} color="#ffffff" />
                    <Text style={styles.editActionText}>Cancel</Text>
                  </TouchableOpacity>

                  <TouchableOpacity
                    style={[styles.editActionButton, styles.saveButton, saving && styles.saveButtonDisabled]}
                    onPress={handleSaveEdit}
                    disabled={saving}
                  >
                    <Ionicons name="checkmark" size={20} color="#ffffff" />
                    <Text style={styles.editActionText}>{saving ? 'Saving...' : 'Save'}</Text>
                  </TouchableOpacity>
                </View>
              </View>
            ) : (
              // View Mode
              <>
                <View style={styles.toolHeader}>
                  <Text style={styles.toolName}>{strategy.name}</Text>
                  <View style={styles.duration}>
                    <Ionicons name="time-outline" size={16} color="#64748b" />
                    <Text style={styles.durationText}>{strategy.duration_minutes} min</Text>
                  </View>
                </View>

                <View style={styles.instructionsContainer}>
                  <Text style={styles.instructionsText}>{cleanInstructions(strategy.instructions)}</Text>
                </View>

                <View style={styles.toolActions}>
                  <TouchableOpacity
                    style={[styles.audioButton, playingId === strategy.id && styles.audioButtonActive]}
                    onPress={() => handlePlayAudio(strategy)}
                  >
                    <Ionicons
                      name={playingId === strategy.id ? 'stop-circle' : 'play-circle'}
                      size={20}
                      color="#ffffff"
                    />
                    <Text style={styles.audioButtonText}>
                      {playingId === strategy.id ? 'Stop Audio' : 'Play Audio'}
                    </Text>
                  </TouchableOpacity>
                </View>
              </>
            )}
          </TouchableOpacity>
        ))}
      </ScrollView>

      {/* Password Modal */}
      <Modal
        visible={showPasswordPrompt}
        transparent={true}
        animationType="fade"
        onRequestClose={() => setShowPasswordPrompt(false)}
      >
        <View style={styles.modalOverlay}>
          <View style={styles.modalContent}>
            <Text style={styles.modalTitle}>Enter Admin Password</Text>
            <TextInput
              style={styles.passwordInput}
              value={passwordInput}
              onChangeText={setPasswordInput}
              secureTextEntry
              placeholder="Password"
              placeholderTextColor="#94a3b8"
              autoFocus
            />
            <View style={styles.modalActions}>
              <TouchableOpacity
                style={[styles.modalButton, styles.modalCancelButton]}
                onPress={() => {
                  setShowPasswordPrompt(false);
                  setPasswordInput('');
                }}
              >
                <Text style={styles.modalButtonText}>Cancel</Text>
              </TouchableOpacity>
              <TouchableOpacity
                style={[styles.modalButton, styles.modalSubmitButton]}
                onPress={handlePasswordSubmit}
              >
                <Text style={[styles.modalButtonText, styles.modalSubmitButtonText]}>Submit</Text>
              </TouchableOpacity>
            </View>
          </View>
        </View>
      </Modal>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#A7D2BB',
  },
  loadingContainer: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  loadingText: {
    marginTop: 16,
    color: '#64748b',
    fontSize: 16,
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    padding: 16,
    paddingTop: 8,
  },
  backButton: {
    padding: 8,
  },
  title: {
    fontSize: 18,
    fontWeight: '600',
    color: '#1e293b',
    flex: 1,
    textAlign: 'center',
  },
  editButton: {
    padding: 8,
  },
  scrollView: {
    flex: 1,
    padding: 24,
  },
  descriptionCard: {
    backgroundColor: '#ffffff',
    padding: 16,
    borderRadius: 12,
    marginBottom: 16,
    borderWidth: 1,
    borderColor: '#375B50',
  },
  descriptionText: {
    fontSize: 14,
    color: '#64748b',
    lineHeight: 22,
    marginBottom: 12,
  },
  guideButton: {
    flexDirection: 'row',
    backgroundColor: '#ec4899',
    paddingVertical: 12,
    paddingHorizontal: 16,
    borderRadius: 8,
    alignItems: 'center',
    justifyContent: 'center',
    marginTop: 12,
  },
  guideButtonText: {
    color: '#ffffff',
    fontSize: 14,
    fontWeight: '600',
    marginLeft: 8,
  },
  editModeIndicator: {
    flexDirection: 'row',
    backgroundColor: '#fef2f2',
    padding: 12,
    borderRadius: 8,
    marginBottom: 16,
    alignItems: 'center',
    borderWidth: 1,
    borderColor: '#ef4444',
  },
  editModeText: {
    marginLeft: 8,
    fontSize: 14,
    color: '#ef4444',
    fontWeight: '600',
  },
  subtitle: {
    fontSize: 14,
    color: '#64748b',
    marginBottom: 24,
  },
  toolCard: {
    backgroundColor: '#ffffff',
    padding: 20,
    borderRadius: 12,
    marginBottom: 16,
    borderWidth: 1,
    borderColor: '#375B50',
  },
  toolCardEditable: {
    borderColor: '#3b82f6',
    borderWidth: 2,
  },
  toolCardEditing: {
    backgroundColor: '#f0f9ff',
    borderColor: '#3b82f6',
  },
  toolHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
    marginBottom: 16,
  },
  toolName: {
    flex: 1,
    fontSize: 18,
    fontWeight: '600',
    color: '#1e293b',
    marginRight: 12,
  },
  duration: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  durationText: {
    marginLeft: 4,
    fontSize: 14,
    color: '#64748b',
  },
  instructionsContainer: {
    marginBottom: 16,
  },
  instructionsText: {
    fontSize: 14,
    color: '#64748b',
    lineHeight: 22,
  },
  toolActions: {
    flexDirection: 'row',
  },
  audioButton: {
    flexDirection: 'row',
    backgroundColor: '#375B50',
    paddingVertical: 10,
    paddingHorizontal: 16,
    borderRadius: 8,
    alignItems: 'center',
  },
  audioButtonActive: {
    backgroundColor: '#ef4444',
  },
  audioButtonText: {
    color: '#ffffff',
    fontSize: 14,
    fontWeight: '600',
    marginLeft: 8,
  },
  editContainer: {
    width: '100%',
  },
  editLabel: {
    fontSize: 14,
    fontWeight: '600',
    color: '#1e293b',
    marginBottom: 8,
  },
  editInput: {
    backgroundColor: '#ffffff',
    borderWidth: 1,
    borderColor: '#cbd5e1',
    borderRadius: 8,
    padding: 12,
    fontSize: 14,
    color: '#1e293b',
    marginBottom: 16,
  },
  editInputLarge: {
    minHeight: 200,
    textAlignVertical: 'top',
  },
  editActions: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginTop: 8,
  },
  editActionButton: {
    flexDirection: 'row',
    flex: 1,
    paddingVertical: 12,
    paddingHorizontal: 16,
    borderRadius: 8,
    alignItems: 'center',
    justifyContent: 'center',
    marginHorizontal: 4,
  },
  cancelButton: {
    backgroundColor: '#64748b',
  },
  saveButton: {
    backgroundColor: '#10b981',
  },
  saveButtonDisabled: {
    opacity: 0.6,
  },
  editActionText: {
    color: '#ffffff',
    fontSize: 14,
    fontWeight: '600',
    marginLeft: 8,
  },
  modalOverlay: {
    flex: 1,
    backgroundColor: 'rgba(0, 0, 0, 0.5)',
    justifyContent: 'center',
    alignItems: 'center',
    padding: 20,
  },
  modalContent: {
    backgroundColor: '#ffffff',
    borderRadius: 16,
    padding: 24,
    width: '100%',
    maxWidth: 400,
  },
  modalTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#1e293b',
    marginBottom: 20,
    textAlign: 'center',
  },
  passwordInput: {
    backgroundColor: '#f8fafc',
    borderWidth: 1,
    borderColor: '#cbd5e1',
    borderRadius: 8,
    padding: 12,
    fontSize: 16,
    color: '#1e293b',
    marginBottom: 20,
  },
  modalActions: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  modalButton: {
    flex: 1,
    paddingVertical: 12,
    paddingHorizontal: 16,
    borderRadius: 8,
    alignItems: 'center',
    marginHorizontal: 4,
  },
  modalCancelButton: {
    backgroundColor: '#f1f5f9',
  },
  modalSubmitButton: {
    backgroundColor: '#3b82f6',
  },
  modalButtonText: {
    fontSize: 16,
    fontWeight: '600',
    color: '#64748b',
  },
  modalSubmitButtonText: {
    color: '#ffffff',
  },
});
