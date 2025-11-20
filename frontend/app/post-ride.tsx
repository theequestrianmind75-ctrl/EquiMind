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
  Image,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useRouter } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import api from '../lib/api';

interface Session {
  id: string;
  session_type: string;
  ride_type: string;
  rider_name: string | null;
  anxiety_level: number | null;
  confidence_level: number | null;
  horse_name: string | null;
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
        horse_energy_level: horseEnergyLevel,
        horse_focus_level: horseFocusLevel,
        horse_responsiveness: horseResponsiveness,
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

  const generateRecommendations = () => {
    const recommendations: string[] = [];
    
    // Analyze anxiety patterns
    const preAnxiety = selectedSession?.anxiety_level || 5;
    const postAnxiety = anxietyLevel;
    const anxietyChange = postAnxiety - preAnxiety;
    
    // Analyze confidence patterns
    const preConfidence = selectedSession?.confidence_level || 5;
    const postConfidence = confidenceLevel;
    const confidenceChange = postConfidence - preConfidence;
    
    // Analyze horse metrics
    const horseEnergy = horseEnergyLevel;
    const horseFocus = horseFocusLevel;
    
    // High post-ride anxiety (7+)
    if (postAnxiety >= 7) {
      recommendations.push("🧘 Try 'Box Breath' or '4:8 Tension Melt Exhale' from BODY RESET before your next ride to regulate your nervous system.");
      recommendations.push("💡 Consider practicing 'The Safe Seat Reset' during rides when anxiety spikes - it activates your parasympathetic nervous system.");
    }
    
    // Anxiety increased during ride
    if (anxietyChange >= 2) {
      recommendations.push("🎯 Your anxiety increased during the ride. Try 'Cognitive Grounding Through Sensory Anchors' (identify 3 things you see, 2 things you feel) to stay present.");
      recommendations.push("💭 Practice 'Thought Labeling + Releasing' - name the anxious thought and separate from it: 'That's an anxious thought, I don't have to act on it.'");
    }
    
    // Low confidence (≤4)
    if (postConfidence <= 4) {
      recommendations.push("💪 Build confidence with 'Micro-Goal Cueing' - set small achievable goals like '5 steady strides' or 'one smooth corner.'");
      recommendations.push("🌟 Try EFT Tapping sequences specifically for confidence building - research shows tapping reduces cortisol by 24%.");
    }
    
    // Confidence decreased
    if (confidenceChange <= -2) {
      recommendations.push("🔄 Your confidence dropped during this ride. This is normal! Review what went well first, then identify one specific skill to practice next time.");
      recommendations.push("📚 Consider the 'Peripheral Vision Expansion' technique - widening your gaze reduces amygdala activation and improves calm focus.");
    }
    
    // High anxiety + Low confidence combination
    if (postAnxiety >= 6 && postConfidence <= 4) {
      recommendations.push("⚠️ High anxiety + low confidence pattern detected. This is a common cycle. Start with 'Breath-Sync Regulation' (3-count inhale, 4-5 count exhale) to interrupt the stress response.");
      recommendations.push("🐴 Practice 'Co-Regulation' - match your breathing to your horse's rhythm. Research shows horses' calm state can regulate rider's nervous system.");
    }
    
    // High horse energy + low rider confidence
    if (horseEnergy >= 7 && postConfidence <= 4) {
      recommendations.push("🐎 Your horse's high energy may be overwhelming your confidence. Practice 'Interoception Check-In' - notice where tension lives in your body and soften by 5%.");
      recommendations.push("💡 Use 'Dual Awareness' statements: 'My horse has energy AND I can stay grounded.' This DBT technique prevents catastrophic thinking.");
    }
    
    // Low horse focus
    if (horseFocus <= 4) {
      recommendations.push("👁️ Your horse's focus was low. Try the 'Micro-Shake Release' for yourself between exercises - releasing your tension helps your horse regulate too.");
      recommendations.push("🎯 Consider shorter, more varied exercises next session. Horses' attention spans are 10-15 minutes - break training into smaller chunks.");
    }
    
    // Great performance! Anxiety low + confidence high
    if (postAnxiety <= 3 && postConfidence >= 7) {
      recommendations.push("✨ Excellent session! Low anxiety + high confidence. Document what you did in pre-ride prep - this is your optimal state formula.");
      recommendations.push("🎊 Consider this your 'flow state' session. Research shows this anxiety-confidence combo predicts peak performance. Repeat your pre-ride routine!");
    }
    
    // Good improvement
    if (anxietyChange <= -2 && confidenceChange >= 2) {
      recommendations.push("📈 Great progress! Your anxiety decreased AND confidence increased. You're building emotional resilience - this is the goal of mental training.");
    }
    
    // Horse metrics all good
    if (horseEnergy >= 5 && horseEnergy <= 7 && horseFocus >= 6 && horseResponsiveness >= 6) {
      recommendations.push("🐴 Your horse showed optimal metrics (balanced energy, good focus, strong responsiveness). Your mental state likely contributed to this - keep doing what you're doing!");
    }
    
    // Default recommendation if no specific patterns
    if (recommendations.length === 0) {
      recommendations.push("💭 Great job completing your session! Review the Rider Tools library for techniques that match your specific goals.");
      recommendations.push("📊 Track patterns over multiple sessions to identify your optimal pre-ride preparation routine.");
    }
    
    return recommendations.slice(0, 4); // Return max 4 recommendations
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
                <Image 
                  source={require('../../assets/images/horse-head-logo.png')} 
                  style={styles.sessionLogo}
                />
                <View style={styles.sessionInfoText}>
                  <Text style={styles.sessionInfoTitle}>Current Session</Text>
                  <Text style={styles.sessionInfoSubtitle}>
                    {selectedSession.ride_type.charAt(0).toUpperCase() + selectedSession.ride_type.slice(1)} •{' '}
                    {selectedSession.session_type}
                  </Text>
                </View>
              </View>

              <View style={styles.divider} />
              <Text style={styles.sectionHeader}>{selectedSession.rider_name ? selectedSession.rider_name.toUpperCase() : 'RIDER'}</Text>

              <View style={styles.section}>
                <Text style={styles.sectionTitle}>Anxiety Level: {anxietyLevel}/10</Text>
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
                <Text style={styles.sectionTitle}>Confidence Level: {confidenceLevel}/10</Text>
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

              <View style={styles.divider} />
              <Text style={styles.sectionHeader}>{selectedSession.horse_name ? selectedSession.horse_name.toUpperCase() : 'YOUR HORSE'}</Text>

              <View style={styles.section}>
                <Text style={styles.sectionTitle}>Energy Level: {horseEnergyLevel}/10</Text>
                <View style={styles.sliderContainer}>
                  <View style={styles.scaleButtons}>
                    {[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((level) => (
                      <TouchableOpacity
                        key={level}
                        style={[
                          styles.scaleButton,
                          horseEnergyLevel === level && styles.scaleButtonActive,
                        ]}
                        onPress={() => setHorseEnergyLevel(level)}
                      >
                        <Text
                          style={[
                            styles.scaleButtonText,
                            horseEnergyLevel === level && styles.scaleButtonTextActive,
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
                <Text style={styles.sectionTitle}>Focus Level: {horseFocusLevel}/10</Text>
                <View style={styles.sliderContainer}>
                  <View style={styles.scaleButtons}>
                    {[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((level) => (
                      <TouchableOpacity
                        key={level}
                        style={[
                          styles.scaleButton,
                          horseFocusLevel === level && styles.scaleButtonActive,
                        ]}
                        onPress={() => setHorseFocusLevel(level)}
                      >
                        <Text
                          style={[
                            styles.scaleButtonText,
                            horseFocusLevel === level && styles.scaleButtonTextActive,
                          ]}
                        >
                          {level}
                        </Text>
                      </TouchableOpacity>
                    ))}
                  </View>
                  <View style={styles.scaleLabels}>
                    <Text style={styles.scaleLabel}>Distracted</Text>
                    <Text style={styles.scaleLabel}>Focused</Text>
                  </View>
                </View>
              </View>

              <View style={styles.section}>
                <Text style={styles.sectionTitle}>Responsiveness: {horseResponsiveness}/10</Text>
                <View style={styles.sliderContainer}>
                  <View style={styles.scaleButtons}>
                    {[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((level) => (
                      <TouchableOpacity
                        key={level}
                        style={[
                          styles.scaleButton,
                          horseResponsiveness === level && styles.scaleButtonActive,
                        ]}
                        onPress={() => setHorseResponsiveness(level)}
                      >
                        <Text
                          style={[
                            styles.scaleButtonText,
                            horseResponsiveness === level && styles.scaleButtonTextActive,
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

              <View style={styles.recommendationsCard}>
                <View style={styles.recommendationsHeader}>
                  <Ionicons name="bulb" size={24} color="#f59e0b" />
                  <Text style={styles.recommendationsTitle}>Personalized Recommendations</Text>
                </View>
                <Text style={styles.recommendationsSubtitle}>
                  Evidence-based strategies from sports performance research
                </Text>
                {generateRecommendations().map((rec, index) => (
                  <View key={index} style={styles.recommendationItem}>
                    <Text style={styles.recommendationText}>{rec}</Text>
                  </View>
                ))}
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
  divider: {
    height: 1,
    backgroundColor: '#334155',
    marginVertical: 32,
  },
  sectionHeader: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#000000',
    marginBottom: 24,
    textAlign: 'center',
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
