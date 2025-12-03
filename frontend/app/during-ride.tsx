import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  Alert,
  ScrollView,
  ActivityIndicator,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useRouter } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import * as Speech from 'expo-speech';
import api from '../lib/api';

interface Tool {
  id: string;
  name: string;
  category: string;
  instructions: string;
  reason: string;
}

interface Recommendations {
  session_id: string;
  start_of_ride: Tool | null;
  during_ride: Tool[];
  emergency: Tool | null;
  remaining_regular_tools: number;
  tools_accessed: any[];
}

export default function DuringRideNew() {
  const router = useRouter();
  const [currentSession, setCurrentSession] = useState<any>(null);
  const [recommendations, setRecommendations] = useState<Recommendations | null>(null);
  const [loading, setLoading] = useState(true);
  const [isSpeaking, setIsSpeaking] = useState(false);
  const [currentPlayingTool, setCurrentPlayingTool] = useState<string | null>(null);
  const [useFemaleVoice, setUseFemaleVoice] = useState(true);

  useEffect(() => {
    fetchCurrentSessionAndRecommendations();
  }, []);

  const fetchCurrentSessionAndRecommendations = async () => {
    try {
      // Get current active session (not completed)
      const sessionResponse = await api.get('/sessions?completed=false&limit=1');
      if (sessionResponse.data && sessionResponse.data.length > 0) {
        const session = sessionResponse.data[0];
        setCurrentSession(session);
        
        // Fetch smart recommendations
        const recsResponse = await api.get(`/during-ride/recommendations/${session.id}`);
        setRecommendations(recsResponse.data);
      } else {
        Alert.alert(
          'No Active Session',
          'Please start a pre-ride session first.',
          [{ text: 'OK', onPress: () => router.back() }]
        );
      }
    } catch (error) {
      console.error('Error fetching data:', error);
      Alert.alert('Error', 'Failed to load during-ride coaching');
    } finally {
      setLoading(false);
    }
  };

  const extractAudioScript = (instructions: string): string => {
    const match = instructions.match(/Audio Script:\s*([\s\S]*?)(?:\n\n|$)/);
    if (match && match[1]) {
      return match[1].trim();
    }
    const microMatch = instructions.match(/Micro Script:\s*([\s\S]*?)(?:\n\n|Audio Script:|$)/);
    if (microMatch && microMatch[1]) {
      return microMatch[1].replace(/Coach:\s*/g, '').trim();
    }
    return instructions;
  };

  const playTool = async (tool: Tool, isEmergency: boolean = false) => {
    if (!currentSession || !recommendations) return;

    // Check if regular tool limit reached
    if (!isEmergency && recommendations.remaining_regular_tools <= 0) {
      Alert.alert(
        'Tool Limit Reached',
        'You have used your 2 regular tools for this ride. You can still use the Emergency tool anytime.',
        [{ text: 'OK' }]
      );
      return;
    }

    // Track tool access
    try {
      const response = await api.post(
        `/during-ride/track-tool-access/${currentSession.id}?tool_id=${tool.id}&tool_name=${encodeURIComponent(tool.name)}&is_emergency=${isEmergency}`
      );
      
      // Update remaining count
      setRecommendations(prev => prev ? {
        ...prev,
        remaining_regular_tools: response.data.regular_tools_remaining
      } : null);

      // Play audio
      const audioScript = extractAudioScript(tool.instructions);
      setIsSpeaking(true);
      setCurrentPlayingTool(tool.id);

      // Get voice based on user selection
      const voices = await Speech.getAvailableVoicesAsync();
      let selectedVoice;
      
      if (useFemaleVoice) {
        selectedVoice = voices.find(v => 
          v.language.startsWith('en') && 
          (v.name.toLowerCase().includes('samantha') || 
           v.name.toLowerCase().includes('karen') ||
           v.name.toLowerCase().includes('moira') ||
           v.name.toLowerCase().includes('fiona') ||
           v.name.toLowerCase().includes('tessa'))
        ) || voices.find(v => 
          v.language.startsWith('en') && 
          v.quality === 'Enhanced'
        );
      } else {
        // Male voice selection
        selectedVoice = voices.find(v => 
          v.language.startsWith('en') && 
          (v.name.toLowerCase().includes('alex') || 
           v.name.toLowerCase().includes('daniel') ||
           v.name.toLowerCase().includes('tom') ||
           v.name.toLowerCase().includes('fred'))
        ) || voices.find(v => 
          v.language.startsWith('en')
        );
      }

      const voiceOptions: any = {
        language: 'en-US',
        pitch: useFemaleVoice ? 1.0 : 0.9,
        rate: 0.85,
        voice: selectedVoice?.identifier,
        onDone: () => {
          setIsSpeaking(false);
          setCurrentPlayingTool(null);
        },
        onError: () => {
          setIsSpeaking(false);
          setCurrentPlayingTool(null);
          Alert.alert('Error', 'Failed to play audio');
        },
      };

      Speech.speak(audioScript, voiceOptions);
    } catch (error: any) {
      Alert.alert('Error', error.response?.data?.detail || 'Failed to access tool');
    }
  };

  const stopSpeaking = () => {
    Speech.stop();
    setIsSpeaking(false);
    setCurrentPlayingTool(null);
  };

  if (loading) {
    return (
      <SafeAreaView style={styles.container} edges={['top']}>
        <View style={styles.loadingContainer}>
          <ActivityIndicator size="large" color="#375B50" />
          <Text style={styles.loadingText}>Loading coaching tools...</Text>
        </View>
      </SafeAreaView>
    );
  }

  if (!currentSession || !recommendations) {
    return (
      <SafeAreaView style={styles.container} edges={['top']}>
        <View style={styles.loadingContainer}>
          <Text style={styles.errorText}>No active session found</Text>
          <TouchableOpacity style={styles.backButtonFull} onPress={() => router.back()}>
            <Text style={styles.backButtonText}>Go Back</Text>
          </TouchableOpacity>
        </View>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView style={styles.container} edges={['top']}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()} style={styles.backButton}>
          <Ionicons name="arrow-back" size={24} color="#1e293b" />
        </TouchableOpacity>
        <Text style={styles.title}>During Ride Coaching</Text>
        <View style={styles.placeholder} />
      </View>

      <ScrollView style={styles.content}>
        {/* Rules/Instructions Box */}
        <View style={styles.rulesCard}>
          <Text style={styles.rulesTitle}>Voice-Activated Coaching Rules</Text>
          <Text style={styles.rulesDescription}>
            • Use <Text style={styles.bold}>Start of Ride</Text> tool when beginning your session to set intentions and ground yourself{'\n\n'}
            • Access <Text style={styles.bold}>During Your Ride</Text> tools when you need real-time support{'\n\n'}
            • Maximum <Text style={styles.bold}>2 regular tools per ride session</Text> to maintain focus and safety{'\n\n'}
            • Emergency tool is always available with no limits
          </Text>
        </View>

        {/* Voice Selection */}
        <View style={styles.voiceSelectionCard}>
          <Text style={styles.voiceSelectionTitle}>Voice Preference</Text>
          <View style={styles.voiceButtons}>
            <TouchableOpacity
              style={[styles.voiceButton, useFemaleVoice && styles.voiceButtonActive]}
              onPress={() => setUseFemaleVoice(true)}
            >
              <Ionicons name="woman" size={24} color={useFemaleVoice ? "#ffffff" : "#375B50"} />
              <Text style={[styles.voiceButtonText, useFemaleVoice && styles.voiceButtonTextActive]}>
                Female
              </Text>
            </TouchableOpacity>
            <TouchableOpacity
              style={[styles.voiceButton, !useFemaleVoice && styles.voiceButtonActive]}
              onPress={() => setUseFemaleVoice(false)}
            >
              <Ionicons name="man" size={24} color={!useFemaleVoice ? "#ffffff" : "#375B50"} />
              <Text style={[styles.voiceButtonText, !useFemaleVoice && styles.voiceButtonTextActive]}>
                Male
              </Text>
            </TouchableOpacity>
          </View>
        </View>

        {/* Tools Remaining Indicator */}
        <Text style={styles.toolsRemaining}>
          Regular Tools Remaining: {recommendations.remaining_regular_tools}/2
        </Text>

        {/* START OF RIDE Button & Tool */}
        {recommendations.start_of_ride && (
          <View style={styles.section}>
            <TouchableOpacity
              style={styles.mainButton}
              onPress={() => {
                if (currentPlayingTool === recommendations.start_of_ride?.id) {
                  stopSpeaking();
                } else {
                  playTool(recommendations.start_of_ride, false);
                }
              }}
              disabled={recommendations.remaining_regular_tools <= 0}
            >
              <Text style={styles.mainButtonText}>START OF RIDE</Text>
            </TouchableOpacity>
            {currentPlayingTool === recommendations.start_of_ride?.id && isSpeaking && (
              <View style={styles.toolDetailsCard}>
                <Text style={styles.toolDetailsTitle}>{recommendations.start_of_ride.name}</Text>
                <Text style={styles.toolDetailsCategory}>{recommendations.start_of_ride.category}</Text>
                <Text style={styles.toolDetailsReason}>{recommendations.start_of_ride.reason}</Text>
                <TouchableOpacity style={styles.stopButton} onPress={stopSpeaking}>
                  <Ionicons name="stop-circle" size={32} color="#ffffff" />
                  <Text style={styles.stopButtonText}>Stop Audio</Text>
                </TouchableOpacity>
              </View>
            )}
          </View>
        )}

        {/* DURING YOUR RIDE Button & Tools */}
        {recommendations.during_ride && recommendations.during_ride.length > 0 && (
          <View style={styles.section}>
            <TouchableOpacity
              style={[styles.mainButton, styles.duringRideButton]}
              onPress={() => {
                // Play the first available during-ride tool
                const tool = recommendations.during_ride[0];
                if (currentPlayingTool === tool.id) {
                  stopSpeaking();
                } else {
                  playTool(tool, false);
                }
              }}
              disabled={recommendations.remaining_regular_tools <= 0}
            >
              <Text style={styles.mainButtonText}>DURING YOUR RIDE</Text>
            </TouchableOpacity>
            {recommendations.during_ride.map((tool, index) => (
              currentPlayingTool === tool.id && isSpeaking && (
                <View key={tool.id} style={styles.toolDetailsCard}>
                  <Text style={styles.toolDetailsTitle}>{tool.name}</Text>
                  <Text style={styles.toolDetailsCategory}>{tool.category}</Text>
                  <Text style={styles.toolDetailsReason}>{tool.reason}</Text>
                  <TouchableOpacity style={styles.stopButton} onPress={stopSpeaking}>
                    <Ionicons name="stop-circle" size={32} color="#ffffff" />
                    <Text style={styles.stopButtonText}>Stop Audio</Text>
                  </TouchableOpacity>
                </View>
              )
            ))}
          </View>
        )}

        {/* EMERGENCY Tool */}
        {recommendations.emergency && (
          <View style={styles.section}>
            <Text style={styles.sectionTitleEmergency}>🚨 Emergency Tool</Text>
            <Text style={styles.emergencyNote}>Available anytime - no limits</Text>
            <View style={[styles.toolCard, styles.emergencyCard]}>
              <Text style={styles.toolName}>{recommendations.emergency.name}</Text>
              <Text style={styles.toolCategory}>{recommendations.emergency.category}</Text>
              <Text style={styles.toolReason}>{recommendations.emergency.reason}</Text>
              <TouchableOpacity
                style={[
                  styles.emergencyButton,
                  currentPlayingTool === recommendations.emergency.id && styles.emergencyButtonActive
                ]}
                onPress={() => {
                  if (currentPlayingTool === recommendations.emergency?.id) {
                    stopSpeaking();
                  } else {
                    playTool(recommendations.emergency, true);
                  }
                }}
              >
                <Ionicons
                  name={currentPlayingTool === recommendations.emergency.id ? 'stop-circle' : 'alert-circle'}
                  size={28}
                  color="#ffffff"
                />
                <Text style={styles.emergencyButtonText}>
                  {currentPlayingTool === recommendations.emergency.id ? 'Stop' : 'Use Emergency Tool'}
                </Text>
              </TouchableOpacity>
            </View>
          </View>
        )}

        {/* Info Card */}
        <View style={styles.infoCard}>
          <Ionicons name="information-circle" size={24} color="#375B50" />
          <Text style={styles.infoText}>
            These tools were selected based on your pre-ride state. Use them as needed during your ride for real-time support.
          </Text>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#A7D2BB',
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
  content: {
    flex: 1,
    padding: 20,
  },
  loadingContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 40,
  },
  loadingText: {
    marginTop: 16,
    fontSize: 16,
    color: '#1e293b',
  },
  errorText: {
    fontSize: 16,
    color: '#ef4444',
    marginBottom: 24,
  },
  backButtonFull: {
    backgroundColor: '#375B50',
    paddingHorizontal: 32,
    paddingVertical: 16,
    borderRadius: 12,
  },
  backButtonText: {
    color: '#ffffff',
    fontSize: 16,
    fontWeight: '600',
  },
  counterCard: {
    backgroundColor: '#ffffff',
    padding: 20,
    borderRadius: 12,
    marginBottom: 24,
    borderWidth: 2,
    borderColor: '#375B50',
    alignItems: 'center',
  },
  counterTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#1e293b',
    marginBottom: 8,
  },
  counterSubtitle: {
    fontSize: 14,
    color: '#64748b',
    textAlign: 'center',
  },
  section: {
    marginBottom: 32,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#1e293b',
    marginBottom: 12,
  },
  sectionTitleEmergency: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#ef4444',
    marginBottom: 8,
  },
  emergencyNote: {
    fontSize: 14,
    color: '#64748b',
    marginBottom: 12,
    fontStyle: 'italic',
  },
  toolCard: {
    backgroundColor: '#ffffff',
    padding: 20,
    borderRadius: 12,
    marginBottom: 16,
    borderWidth: 1,
    borderColor: '#375B50',
  },
  emergencyCard: {
    borderColor: '#ef4444',
    borderWidth: 2,
  },
  toolName: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#1e293b',
    marginBottom: 8,
  },
  toolCategory: {
    fontSize: 13,
    color: '#64748b',
    marginBottom: 12,
    fontWeight: '600',
  },
  toolReason: {
    fontSize: 14,
    color: '#475569',
    marginBottom: 16,
    lineHeight: 20,
  },
  playButton: {
    flexDirection: 'row',
    backgroundColor: '#375B50',
    padding: 16,
    borderRadius: 12,
    alignItems: 'center',
    justifyContent: 'center',
  },
  playButtonActive: {
    backgroundColor: '#ef4444',
  },
  playButtonDisabled: {
    backgroundColor: '#94a3b8',
    opacity: 0.6,
  },
  playButtonText: {
    fontSize: 16,
    fontWeight: '600',
    color: '#ffffff',
    marginLeft: 8,
  },
  emergencyButton: {
    flexDirection: 'row',
    backgroundColor: '#ef4444',
    padding: 20,
    borderRadius: 12,
    alignItems: 'center',
    justifyContent: 'center',
  },
  emergencyButtonActive: {
    backgroundColor: '#991b1b',
  },
  emergencyButtonText: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#ffffff',
    marginLeft: 12,
  },
  infoCard: {
    backgroundColor: '#ffffff',
    padding: 16,
    borderRadius: 12,
    flexDirection: 'row',
    alignItems: 'flex-start',
    marginBottom: 32,
  },
  infoText: {
    flex: 1,
    fontSize: 13,
    color: '#64748b',
    lineHeight: 18,
    marginLeft: 12,
  },
});
