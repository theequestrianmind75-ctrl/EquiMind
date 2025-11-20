import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  TextInput,
  Alert,
  KeyboardAvoidingView,
  Platform,
  ActivityIndicator,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useRouter } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import api from '../lib/api';

interface Session {
  id: string;
  session_type: string;
  ride_type: string;
  anxiety_level: number | null;
  confidence_level: number | null;
  horse_energy_level: number | null;
  horse_focus_level: number | null;
  horse_responsiveness: number | null;
  horse_notes: string | null;
  completed: boolean;
}

export default function PostRide() {
  const router = useRouter();
  const [sessions, setSessions] = useState<Session[]>([]);
  const [selectedSession, setSelectedSession] = useState<Session | null>(null);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [anxietyLevel, setAnxietyLevel] = useState(5);
  const [confidenceLevel, setConfidenceLevel] = useState(5);
  const [notes, setNotes] = useState('');
  const [horseEnergyLevel, setHorseEnergyLevel] = useState(5);
  const [horseFocusLevel, setHorseFocusLevel] = useState(5);
  const [horseResponsiveness, setHorseResponsiveness] = useState(5);

  useEffect(() => {
    fetchIncompleteSessions();
  }, []);

  const fetchIncompleteSessions = async () => {
    try {
      const response = await api.get('/sessions?completed=false&limit=10');
      setSessions(response.data);
      if (response.data.length > 0) {
        const latestSession = response.data[0];
        setSelectedSession(latestSession);
        setAnxietyLevel(latestSession.anxiety_level || 5);
        setConfidenceLevel(latestSession.confidence_level || 5);
        setHorseEnergyLevel(latestSession.horse_energy_level || 5);
        setHorseFocusLevel(latestSession.horse_focus_level || 5);
        setHorseResponsiveness(latestSession.horse_responsiveness || 5);
      }
    } catch (error) {
      console.error('Error fetching sessions:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleComplete = async () => {
    if (!selectedSession) {
      Alert.alert('No Session', 'Please select or create a session first.');
      return;
    }

    setSaving(true);
    try {
      await api.patch(`/sessions/${selectedSession.id}`, {
        anxiety_level: anxietyLevel,
        confidence_level: confidenceLevel,
        notes: notes || null,
        completed: true,
      });
      Alert.alert('Success', 'Post-ride analysis saved!', [
        { text: 'OK', onPress: () => router.back() },
      ]);
    } catch (error: any) {
      Alert.alert('Error', error.message || 'Failed to save session');
    } finally {
      setSaving(false);
    }
  };

  const createNewSession = async () => {
    try {
      const response = await api.post('/sessions', {
        session_type: 'post-ride',
        ride_type: 'training',
        anxiety_level: anxietyLevel,
        confidence_level: confidenceLevel,
      });
      setSelectedSession(response.data);
      Alert.alert('Success', 'New post-ride session created');
    } catch (error: any) {
      Alert.alert('Error', error.message || 'Failed to create session');
    }
  };

  const getEnergyLabel = (level: number | null) => {
    if (!level) return 'Unknown';
    if (level <= 3) return 'Low';
    if (level <= 7) return 'Moderate';
    return 'High';
  };

  const getFocusLabel = (level: number | null) => {
    if (!level) return 'Unknown';
    if (level <= 3) return 'Distracted';
    if (level <= 7) return 'Moderate';
    return 'Focused';
  };

  const getResponsivenessLabel = (level: number | null) => {
    if (!level) return 'Unknown';
    if (level <= 3) return 'Low';
    if (level <= 7) return 'Moderate';
    return 'High';
  };

  if (loading) {
    return (
      <SafeAreaView style={styles.container} edges={['top']}>
        <View style={styles.loadingContainer}>
          <ActivityIndicator size="large" color="#000000" />
          <Text style={styles.loadingText}>Loading sessions...</Text>
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
        <Text style={styles.title}>Post-Ride Analysis</Text>
        <View style={styles.placeholder} />
      </View>

      <KeyboardAvoidingView
        behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
        style={styles.keyboardView}
      >
        <ScrollView style={styles.scrollView}>
          {!selectedSession ? (
            <View style={styles.noSessionCard}>
              <Ionicons name="document-text-outline" size={64} color="#000000" />
              <Text style={styles.noSessionTitle}>No Active Session</Text>
              <Text style={styles.noSessionText}>Create a post-ride session to track your progress</Text>
              <TouchableOpacity style={styles.createButton} onPress={createNewSession}>
                <Ionicons name="add-circle" size={24} color="#ffffff" />
                <Text style={styles.createButtonText}>Create Session</Text>
              </TouchableOpacity>
            </View>
          ) : (
            <>
              <View style={styles.sessionInfo}>
                <Ionicons name="shield" size={24} color="#000000" />
                <View style={styles.sessionInfoText}>
                  <Text style={styles.sessionInfoTitle}>Current Session</Text>
                  <Text style={styles.sessionInfoSubtitle}>
                    {selectedSession.ride_type.charAt(0).toUpperCase() + selectedSession.ride_type.slice(1)} •{' '}
                    {selectedSession.session_type}
                  </Text>
                </View>
              </View>

              {(selectedSession.horse_energy_level || selectedSession.horse_focus_level || selectedSession.horse_responsiveness) && (
                <View style={styles.horseCard}>
                  <View style={styles.horseHeader}>
                    <Ionicons name="shield" size={24} color="#000000" />
                    <Text style={styles.horseTitle}>YOUR HORSE</Text>
                  </View>
                  <View style={styles.horseStats}>
                    <View style={styles.horseStat}>
                      <Text style={styles.horseStatLabel}>Energy</Text>
                      <Text style={styles.horseStatValue}>
                        {selectedSession.horse_energy_level || 'N/A'} - {getEnergyLabel(selectedSession.horse_energy_level)}
                      </Text>
                    </View>
                    <View style={styles.horseStat}>
                      <Text style={styles.horseStatLabel}>Focus</Text>
                      <Text style={styles.horseStatValue}>
                        {selectedSession.horse_focus_level || 'N/A'} - {getFocusLabel(selectedSession.horse_focus_level)}
                      </Text>
                    </View>
                    <View style={styles.horseStat}>
                      <Text style={styles.horseStatLabel}>Responsiveness</Text>
                      <Text style={styles.horseStatValue}>
                        {selectedSession.horse_responsiveness || 'N/A'} - {getResponsivenessLabel(selectedSession.horse_responsiveness)}
                      </Text>
                    </View>
                  </View>
                  {selectedSession.horse_notes && (
                    <View style={styles.horseNotes}>
                      <Text style={styles.horseNotesLabel}>Pre-Ride Horse Notes:</Text>
                      <Text style={styles.horseNotesText}>{selectedSession.horse_notes}</Text>
                    </View>
                  )}
                </View>
              )}

              <View style={styles.section}>
                <Text style={styles.sectionTitle}>Post-Ride Anxiety Level: {anxietyLevel}/10</Text>
                <View style={styles.sliderContainer}>
                  <View style={styles.scaleButtons}>
                    {[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((level) => (
                      <TouchableOpacity
                        key={level}
                        style={[
                          styles.scaleButton,
                          anxietyLevel === level && styles.scaleButtonActive,
                        ]}
                        onPress={() => setAnxietyLevel(level)}
                      >
                        <Text
                          style={[
                            styles.scaleButtonText,
                            anxietyLevel === level && styles.scaleButtonTextActive,
                          ]}
                        >
                          {level}
                        </Text>
                      </TouchableOpacity>
                    ))}
                  </View>
                  <View style={styles.scaleLabels}>
                    <Text style={styles.scaleLabel}>Low</Text>
                    <Text style={styles.scaleLabel}>High</Text>
                  </View>
                </View>
              </View>

              <View style={styles.section}>
                <Text style={styles.sectionTitle}>Post-Ride Confidence Level: {confidenceLevel}/10</Text>
                <View style={styles.sliderContainer}>
                  <View style={styles.scaleButtons}>
                    {[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((level) => (
                      <TouchableOpacity
                        key={level}
                        style={[
                          styles.scaleButton,
                          confidenceLevel === level && styles.scaleButtonActive,
                        ]}
                        onPress={() => setConfidenceLevel(level)}
                      >
                        <Text
                          style={[
                            styles.scaleButtonText,
                            confidenceLevel === level && styles.scaleButtonTextActive,
                          ]}
                        >
                          {level}
                        </Text>
                      </TouchableOpacity>
                    ))}
                  </View>
                  <View style={styles.scaleLabels}>
                    <Text style={styles.scaleLabel}>Low</Text>
                    <Text style={styles.scaleLabel}>High</Text>
                  </View>
                </View>
              </View>

              <View style={styles.section}>
                <Text style={styles.sectionTitle}>Reflection Notes</Text>
                <TextInput
                  style={styles.notesInput}
                  placeholder="What went well? What could be improved? How do you feel?"
                  placeholderTextColor="#000000"
                  value={notes}
                  onChangeText={setNotes}
                  multiline
                  numberOfLines={6}
                />
              </View>

              <TouchableOpacity
                style={[styles.completeButton, saving && styles.completeButtonDisabled]}
                onPress={handleComplete}
                disabled={saving}
              >
                <Ionicons name="checkmark-circle" size={24} color="#ffffff" />
                <Text style={styles.completeButtonText}>
                  {saving ? 'Saving...' : 'Complete & Save Session'}
                </Text>
              </TouchableOpacity>
            </>
          )}
        </ScrollView>
      </KeyboardAvoidingView>
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
  },
  placeholder: {
    width: 40,
  },
  keyboardView: {
    flex: 1,
  },
  scrollView: {
    flex: 1,
    padding: 24,
  },
  noSessionCard: {
    backgroundColor: '#ffffff',
    padding: 48,
    borderRadius: 16,
    alignItems: 'center',
    borderWidth: 1,
    borderColor: '#375B50',
  },
  noSessionTitle: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#1e293b',
    marginTop: 16,
  },
  noSessionText: {
    fontSize: 14,
    color: '#000000',
    marginTop: 8,
    textAlign: 'center',
  },
  createButton: {
    flexDirection: 'row',
    backgroundColor: '#000000',
    padding: 16,
    borderRadius: 12,
    alignItems: 'center',
    marginTop: 24,
  },
  createButtonText: {
    fontSize: 16,
    fontWeight: '600',
    color: '#ffffff',
    marginLeft: 8,
  },
  sessionInfo: {
    flexDirection: 'row',
    backgroundColor: '#ffffff',
    padding: 16,
    borderRadius: 12,
    marginBottom: 24,
    borderWidth: 1,
    borderColor: '#375B50',
  },
  sessionInfoText: {
    marginLeft: 12,
    flex: 1,
  },
  sessionInfoTitle: {
    fontSize: 16,
    fontWeight: '600',
    color: '#1e293b',
  },
  sessionInfoSubtitle: {
    fontSize: 14,
    color: '#000000',
    marginTop: 4,
  },
  horseCard: {
    backgroundColor: '#ffffff',
    padding: 20,
    borderRadius: 12,
    marginBottom: 24,
    borderWidth: 1,
    borderColor: '#375B50',
  },
  horseHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 16,
  },
  horseTitle: {
    fontSize: 16,
    fontWeight: 'bold',
    color: '#000000',
    marginLeft: 12,
  },
  horseStats: {
    marginBottom: 12,
  },
  horseStat: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    paddingVertical: 8,
    borderBottomWidth: 1,
    borderBottomColor: '#e2e8f0',
  },
  horseStatLabel: {
    fontSize: 14,
    fontWeight: '600',
    color: '#000000',
  },
  horseStatValue: {
    fontSize: 14,
    color: '#1e293b',
    fontWeight: '500',
  },
  horseNotes: {
    marginTop: 12,
    padding: 12,
    backgroundColor: '#f8fafc',
    borderRadius: 8,
  },
  horseNotesLabel: {
    fontSize: 12,
    fontWeight: '600',
    color: '#000000',
    marginBottom: 4,
  },
  horseNotesText: {
    fontSize: 13,
    color: '#475569',
    lineHeight: 18,
  },
  section: {
    marginBottom: 32,
  },
  sectionTitle: {
    fontSize: 16,
    fontWeight: '600',
    color: '#1e293b',
    marginBottom: 16,
  },
  sliderContainer: {
    marginTop: 8,
  },
  scaleButtons: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  scaleButton: {
    width: 32,
    height: 32,
    borderRadius: 16,
    backgroundColor: '#ffffff',
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 2,
    borderColor: '#375B50',
  },
  scaleButtonActive: {
    backgroundColor: '#000000',
    borderColor: '#000000',
  },
  scaleButtonText: {
    fontSize: 12,
    fontWeight: '600',
    color: '#000000',
  },
  scaleButtonTextActive: {
    color: '#ffffff',
  },
  scaleLabels: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginTop: 8,
  },
  scaleLabel: {
    fontSize: 12,
    color: '#000000',
  },
  notesInput: {
    backgroundColor: '#ffffff',
    borderRadius: 12,
    padding: 16,
    color: '#1e293b',
    fontSize: 14,
    minHeight: 150,
    textAlignVertical: 'top',
    borderWidth: 1,
    borderColor: '#375B50',
  },
  completeButton: {
    flexDirection: 'row',
    backgroundColor: '#000000',
    borderRadius: 12,
    padding: 16,
    alignItems: 'center',
    justifyContent: 'center',
    marginTop: 16,
    marginBottom: 32,
  },
  completeButtonDisabled: {
    opacity: 0.6,
  },
  completeButtonText: {
    fontSize: 16,
    fontWeight: '600',
    color: '#ffffff',
    marginLeft: 8,
  },
});
