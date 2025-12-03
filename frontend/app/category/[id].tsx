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
  Image,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useRouter, useLocalSearchParams } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
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
  is_crisis_tool?: boolean;
}

const CATEGORIES: any = {
  mindfulness: {
    title: 'Mindfulness & Flow',
    color: '#10b981',
    keywords: ['mindfulness & flow'],
  },
  breathing: {
    title: 'Breathing / Heart Rate Variability',
    color: '#375B50',
    keywords: ['breathing / hrv'],
  },
  grounding: {
    title: 'Activation / Grounding',
    color: '#06b6d4',
    keywords: ['activation / grounding'],
  },
  somatic: {
    title: 'Body Reset',
    color: '#8b5cf6',
    keywords: ['body reset'],
  },
  tapping: {
    title: 'Tapping / EFT',
    color: '#ec4899',
    keywords: ['tapping / eft'],
    description: 'EFT (Emotional Freedom Technique) combines modern psychology with ancient Chinese acupressure. By tapping on specific meridian points while focusing on your concerns, you send calming signals to your brain, helping release stress, anxiety, and emotional blocks. Perfect for pre-ride nerves, competition anxiety, or processing difficult experiences.',
  },
  distress: {
    title: 'Distress Tolerance',
    color: '#ef4444',
    keywords: ['distress tolerance'],
    description: 'Evidence-based crisis tools for high-stress moments. These techniques from DBT, ACT, and sports psychology help you stay safe and regulated when emotions feel overwhelming. Use these tools when anxiety is high, panic is present, or you need to make a wise decision about whether to ride.',
  },
};

const ADMIN_PASSWORD = 'equimind2025';

export default function CategoryDetail() {
  const router = useRouter();
  const { id } = useLocalSearchParams();
  const [strategies, setStrategies] = useState<Strategy[]>([]);
  const [loading, setLoading] = useState(true);
  const [editMode, setEditMode] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [editedStrategy, setEditedStrategy] = useState<Strategy | null>(null);
  const [saving, setSaving] = useState(false);
  const [showPasswordPrompt, setShowPasswordPrompt] = useState(false);
  const [passwordInput, setPasswordInput] = useState('');
  const [showCrisisOnly, setShowCrisisOnly] = useState(false);
  const [showTools, setShowTools] = useState(false);

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

      // Filter strategies by exact category match
      const filtered = allStrategies.filter((s: Strategy) => {
        const categoryLower = s.category.toLowerCase().trim();
        
        // Check if strategy category exactly matches any of the keywords
        const matchesCategory = category.keywords.some((keyword: string) =>
          categoryLower === keyword.toLowerCase().trim()
        );
        
        return matchesCategory;
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

  // Audio functionality removed - tools are now text-only for riders to read

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
          <ActivityIndicator size="large" color={category?.color || '#000000'} />
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
            {id === 'distress' && (
              <TouchableOpacity
                style={[styles.guideButton, styles.crisisButton, showCrisisOnly && styles.crisisButtonActive]}
                onPress={() => setShowCrisisOnly(!showCrisisOnly)}
              >
                <Ionicons name="alert-circle" size={20} color="#ffffff" />
                <Text style={styles.guideButtonText}>
                  {showCrisisOnly ? 'Show All Tools' : 'Crisis Tools'}
                </Text>
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
        
        {id === 'mindfulness' && (
          <View style={styles.wiseMindCard}>
            <Text style={styles.wiseMindTitle}>🧠 Understanding Wise Mind</Text>
            <Text style={styles.wiseMindDescription}>
              Wise Mind is the balance between Emotional Mind (feelings, intuition) and Thinking Mind (logic, reason). 
              It's where you make your best decisions - integrating both emotion and logic.
            </Text>
            <Image 
              source={require('../../assets/images/wise-mind-diagram.png')} 
              style={styles.wiseMindImage}
              resizeMode="contain"
            />
            <View style={styles.wiseMindLegend}>
              <View style={styles.legendItem}>
                <View style={[styles.legendDot, { backgroundColor: '#ef4444' }]} />
                <Text style={styles.legendText}>Emotional Mind: Feelings-driven decisions</Text>
              </View>
              <View style={styles.legendItem}>
                <View style={[styles.legendDot, { backgroundColor: '#3b82f6' }]} />
                <Text style={styles.legendText}>Thinking Mind: Logic-driven decisions</Text>
              </View>
              <View style={styles.legendItem}>
                <View style={[styles.legendDot, { backgroundColor: '#10b981' }]} />
                <Text style={styles.legendText}>Wise Mind: Balanced, integrated decisions</Text>
              </View>
            </View>
          </View>
        )}
        
        {editMode && (
          <View style={styles.editModeIndicator}>
            <Ionicons name="create" size={20} color="#ef4444" />
            <Text style={styles.editModeText}>Edit Mode Active - Click any tool to edit</Text>
          </View>
        )}

        <Text style={styles.subtitle}>
          {showCrisisOnly 
            ? `${strategies.filter(s => s.is_crisis_tool).length} crisis tools` 
            : `${strategies.length} tools available`}
        </Text>

        {/* Tools Section Box */}
        <View style={styles.toolsSectionBox}>
          <View style={styles.toolsSectionHeader}>
            <Ionicons name="list" size={24} color="#375B50" />
            <Text style={styles.toolsSectionTitle}>Tools</Text>
          </View>
        </View>

        {strategies
          .filter(strategy => !showCrisisOnly || strategy.is_crisis_tool)
          .map((strategy) => (
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
                    <Ionicons name="time-outline" size={16} color="#000000" />
                    <Text style={styles.durationText}>{strategy.duration_minutes} min</Text>
                  </View>
                </View>

                <View style={styles.instructionsContainer}>
                  <Text style={styles.instructionsText}>{cleanInstructions(strategy.instructions)}</Text>
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
    color: '#000000',
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
    color: '#000000',
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
  crisisButton: {
    backgroundColor: '#ef4444',
    borderWidth: 2,
    borderColor: '#dc2626',
  },
  crisisButtonActive: {
    backgroundColor: '#dc2626',
    borderColor: '#b91c1c',
  },
  guideButtonText: {
    color: '#ffffff',
    fontSize: 14,
    fontWeight: '600',
    marginLeft: 8,
  },
  wiseMindCard: {
    backgroundColor: '#ffffff',
    padding: 20,
    borderRadius: 12,
    marginBottom: 16,
    borderWidth: 1,
    borderColor: '#10b981',
  },
  wiseMindTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#1e293b',
    marginBottom: 12,
  },
  wiseMindDescription: {
    fontSize: 14,
    color: '#000000',
    lineHeight: 22,
    marginBottom: 16,
  },
  wiseMindImage: {
    width: '100%',
    height: 200,
    marginBottom: 16,
  },
  wiseMindLegend: {
    marginTop: 8,
  },
  legendItem: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 8,
  },
  legendDot: {
    width: 12,
    height: 12,
    borderRadius: 6,
    marginRight: 8,
  },
  legendText: {
    fontSize: 13,
    color: '#000000',
    flex: 1,
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
    color: '#000000',
    marginBottom: 16,
  },
  toolsSectionBox: {
    backgroundColor: '#ffffff',
    padding: 16,
    borderRadius: 12,
    marginBottom: 20,
    borderWidth: 2,
    borderColor: '#375B50',
  },
  toolsSectionHeader: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  toolsSectionTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#1e293b',
    marginLeft: 12,
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
    borderColor: '#000000',
    borderWidth: 2,
  },
  toolCardEditing: {
    backgroundColor: '#f0f9ff',
    borderColor: '#000000',
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
    color: '#000000',
  },
  instructionsContainer: {
    marginBottom: 16,
  },
  instructionsText: {
    fontSize: 14,
    color: '#000000',
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
    backgroundColor: '#000000',
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
    backgroundColor: '#000000',
  },
  modalButtonText: {
    fontSize: 16,
    fontWeight: '600',
    color: '#000000',
  },
  modalSubmitButtonText: {
    color: '#ffffff',
  },
});
