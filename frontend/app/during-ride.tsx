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
  remaining_breathing_tools: number;
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

  // Stop any playing speech when voice preference changes
  useEffect(() => {
    if (isSpeaking) {
      console.log('🔄 Voice preference changed! Stopping current audio to apply new voice.');
      Speech.stop();
      setIsSpeaking(false);
      setCurrentPlayingTool(null);
      
      // Show alert to user
      Alert.alert(
        'Voice Changed',
        `Voice preference updated to ${useFemaleVoice ? 'Female' : 'Male'}. Play a tool to hear the new voice.`,
        [{ text: 'OK' }]
      );
    }
  }, [useFemaleVoice]);

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
        // No active session - still load emergency tool
        // Fetch a default emergency tool from the database
        const strategiesResponse = await api.get('/mental-strategies');
        const allStrategies = strategiesResponse.data;
        
        // Find an emergency/distress tolerance tool
        const emergencyTool = allStrategies.find((s: any) => 
          s.category === "Distress Tolerance" || s.is_crisis_tool
        );
        
        if (emergencyTool) {
          setRecommendations({
            session_id: 'no-session',
            start_of_ride: null,
            during_ride: [],
            emergency: {
              id: emergencyTool._id || emergencyTool.id,
              name: emergencyTool.name,
              category: emergencyTool.category,
              instructions: emergencyTool.instructions,
              reason: 'Available anytime for immediate support - no session required'
            },
            remaining_regular_tools: 0,
            remaining_breathing_tools: 0,
            tools_accessed: []
          });
        }
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
    if (!recommendations) return;

    // Check if regular tool limit reached (only if we have a session)
    if (currentSession && !isEmergency && recommendations.remaining_regular_tools <= 0) {
      Alert.alert(
        'Tool Limit Reached',
        'You have used your 2 regular tools for this ride. You can still use the Emergency tool anytime.',
        [{ text: 'OK' }]
      );
      return;
    }

    // Track tool access (only if we have a session)
    try {
      if (currentSession) {
        const response = await api.post(
          `/during-ride/track-tool-access/${currentSession.id}?tool_id=${tool.id}&tool_name=${encodeURIComponent(tool.name)}&tool_category=${encodeURIComponent(tool.category)}&is_emergency=${isEmergency}`
        );
        
        // Update remaining counts
        setRecommendations(prev => prev ? {
          ...prev,
          remaining_regular_tools: response.data.regular_tools_remaining,
          remaining_breathing_tools: response.data.breathing_tools_remaining
        } : null);
      }

      // Play audio
      const audioScript = extractAudioScript(tool.instructions);
      setIsSpeaking(true);
      setCurrentPlayingTool(tool.id);

      // Get voice based on user selection
      const voices = await Speech.getAvailableVoicesAsync();
      console.log('🎤 ============ VOICE SELECTION START ============');
      console.log('🎤 Current voice preference:', useFemaleVoice ? 'FEMALE' : 'MALE');
      console.log('🎤 Playing tool:', tool.name);
      console.log('🎵 Total available voices:', voices.length);
      console.log('📋 First 10 voices:', voices.slice(0, 10).map(v => `${v.name} (${v.language})`));
      
      let selectedVoice;
      let voiceLanguage = 'en-US';
      
      if (useFemaleVoice) {
        // FEMALE voice selection with extensive fallbacks
        // iOS Priority: Samantha (US), Karen (Australian), Moira (Irish)
        // Android Priority: Any high-quality female voice
        
        // Try 1: US female voices
        selectedVoice = voices.find(v => 
          v.language === 'en-US' && 
          (v.name.toLowerCase().includes('samantha') || 
           v.name.toLowerCase().includes('allison') ||
           v.name.toLowerCase().includes('ava') ||
           v.name.toLowerCase().includes('susan') ||
           v.name.toLowerCase().includes('zoe'))
        );
        
        // Try 2: British female voices
        if (!selectedVoice) {
          selectedVoice = voices.find(v => 
            v.language === 'en-GB' && 
            (v.name.toLowerCase().includes('kate') || 
             v.name.toLowerCase().includes('serena') ||
             v.name.toLowerCase().includes('stephanie'))
          );
          if (selectedVoice) voiceLanguage = 'en-GB';
        }
        
        // Try 3: Australian female voices
        if (!selectedVoice) {
          selectedVoice = voices.find(v => 
            v.language === 'en-AU' && 
            v.name.toLowerCase().includes('karen')
          );
          if (selectedVoice) voiceLanguage = 'en-AU';
        }
        
        // Try 4: Any enhanced quality English voice (higher quality = likely female default)
        if (!selectedVoice) {
          selectedVoice = voices.find(v => 
            v.language.startsWith('en') && 
            v.quality === 'Enhanced'
          );
          if (selectedVoice) voiceLanguage = selectedVoice.language;
        }
        
        // Try 5: First English voice (system default)
        if (!selectedVoice) {
          selectedVoice = voices.find(v => v.language.startsWith('en'));
          if (selectedVoice) voiceLanguage = selectedVoice.language;
        }
      } else {
        // MALE voice selection - OPTIMIZED FOR iPHONE
        // iPhone has "Alex" pre-installed - it's high quality and perfect for male voice
        // Priority: Alex (iOS premium voice) > Other US males > Australian > British
        
        // Try 1: ALEX - iPhone's premium male voice (BEST QUALITY)
        selectedVoice = voices.find(v => 
          v.name.toLowerCase() === 'alex' || 
          v.name.toLowerCase().includes('alex')
        );
        
        if (selectedVoice) {
          console.log('✨ Found Alex (iPhone premium male voice)');
          voiceLanguage = selectedVoice.language;
        }
        
        // Try 2: Other US male voices with Enhanced quality
        if (!selectedVoice) {
          selectedVoice = voices.find(v => 
            v.language === 'en-US' && 
            v.quality === 'Enhanced' &&
            (v.name.toLowerCase().includes('fred') ||
             v.name.toLowerCase().includes('daniel') ||
             v.name.toLowerCase().includes('tom'))
          );
        }
        
        // Try 3: Any US male voices (not just enhanced)
        if (!selectedVoice) {
          selectedVoice = voices.find(v => 
            v.language === 'en-US' && 
            (v.name.toLowerCase().includes('fred') ||
             v.name.toLowerCase().includes('daniel') ||
             v.name.toLowerCase().includes('tom'))
          );
        }
        
        // Try 4: Australian male voices (Gordon is high quality)
        if (!selectedVoice) {
          selectedVoice = voices.find(v => 
            v.language === 'en-AU' && 
            (v.name.toLowerCase().includes('gordon') || 
             v.name.toLowerCase().includes('lee'))
          );
          if (selectedVoice) voiceLanguage = 'en-AU';
        }
        
        // Try 5: British male voices
        if (!selectedVoice) {
          selectedVoice = voices.find(v => 
            v.language === 'en-GB' && 
            (v.name.toLowerCase().includes('daniel') || 
             v.name.toLowerCase().includes('oliver'))
          );
          if (selectedVoice) voiceLanguage = 'en-GB';
        }
        
        // Try 6: Any Enhanced quality English voice (excluding common female names)
        if (!selectedVoice) {
          selectedVoice = voices.find(v => 
            v.language.startsWith('en') &&
            v.quality === 'Enhanced' &&
            !v.name.toLowerCase().includes('samantha') &&
            !v.name.toLowerCase().includes('kate') &&
            !v.name.toLowerCase().includes('karen') &&
            !v.name.toLowerCase().includes('fiona') &&
            !v.name.toLowerCase().includes('moira') &&
            !v.name.toLowerCase().includes('ava') &&
            !v.name.toLowerCase().includes('allison') &&
            !v.name.toLowerCase().includes('susan') &&
            !v.name.toLowerCase().includes('zoe') &&
            !v.name.toLowerCase().includes('serena') &&
            !v.name.toLowerCase().includes('stephanie')
          );
          if (selectedVoice) voiceLanguage = selectedVoice.language;
        }
        
        // Try 7: Any English voice (not female names)
        if (!selectedVoice) {
          selectedVoice = voices.find(v => 
            v.language.startsWith('en') &&
            !v.name.toLowerCase().includes('samantha') &&
            !v.name.toLowerCase().includes('kate') &&
            !v.name.toLowerCase().includes('karen') &&
            !v.name.toLowerCase().includes('fiona') &&
            !v.name.toLowerCase().includes('moira') &&
            !v.name.toLowerCase().includes('ava') &&
            !v.name.toLowerCase().includes('allison') &&
            !v.name.toLowerCase().includes('susan') &&
            !v.name.toLowerCase().includes('zoe') &&
            !v.name.toLowerCase().includes('serena') &&
            !v.name.toLowerCase().includes('stephanie')
          );
          if (selectedVoice) voiceLanguage = selectedVoice.language;
        }
        
        // Try 8: Last resort - any English voice
        if (!selectedVoice) {
          selectedVoice = voices.find(v => v.language.startsWith('en'));
          if (selectedVoice) voiceLanguage = selectedVoice.language;
        }
      }

      console.log('✅ FINAL SELECTED VOICE:', selectedVoice?.name, '(', selectedVoice?.language, ')');
      console.log('🔊 Voice quality:', selectedVoice?.quality);
      console.log('🔊 Voice identifier:', selectedVoice?.identifier);
      console.log('🎤 ============ VOICE SELECTION END ============');
      
      // Optimized parameters for iPhone voices
      // Alex (male) and Samantha (female) are iOS premium voices with best quality
      const voiceOptions: any = {
        language: voiceLanguage,
        pitch: useFemaleVoice ? 1.08 : 1.0,  // Female slightly higher, male neutral for Alex
        rate: useFemaleVoice ? 0.88 : 0.92,  // Male slightly faster for more natural flow
        onDone: () => {
          setIsSpeaking(false);
          setCurrentPlayingTool(null);
        },
        onError: (error) => {
          console.error('🔴 TTS Error:', error);
          setIsSpeaking(false);
          setCurrentPlayingTool(null);
          Alert.alert('Error', 'Failed to play audio');
        },
      };
      
      // Only set voice identifier if we found one
      if (selectedVoice?.identifier) {
        voiceOptions.voice = selectedVoice.identifier;
        console.log('🎙️ Using voice:', selectedVoice.name, 'with pitch:', voiceOptions.pitch, 'rate:', voiceOptions.rate);
      } else {
        // If no specific voice found, let system choose but guide with pitch
        console.log('⚠️ No specific voice found, using system default with pitch:', voiceOptions.pitch);
      }

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
        {/* No Session Warning */}
        {!currentSession && (
          <View style={styles.warningCard}>
            <Ionicons name="information-circle" size={32} color="#f59e0b" />
            <Text style={styles.warningTitle}>No Active Ride Session</Text>
            <Text style={styles.warningText}>
              Start a pre-ride session to access personalized coaching tools. The Emergency Tool is always available below.
            </Text>
          </View>
        )}

        {/* Rules/Instructions Box - Only show with active session */}
        {currentSession && (
          <View style={styles.rulesCard}>
            <Text style={styles.rulesTitle}>Voice-Activated Coaching Rules</Text>
            <Text style={styles.rulesDescription}>
              • Use <Text style={styles.bold}>Start of Ride</Text> tool when beginning your session to set intentions and ground yourself <Text style={styles.bold}>before you get on your horse</Text>{'\n\n'}
              • Access <Text style={styles.bold}>During Your Ride</Text> tools when you need real-time support: <Text style={styles.bold}>give your phone to your coach</Text> OR <Text style={styles.bold}>stop your horse in the middle of the ring and click on the "During Your Ride" button</Text> to listen to the tool{'\n\n'}
              • Maximum <Text style={styles.bold}>2 regular tools per ride session</Text> to maintain focus and safety{'\n\n'}
              • Emergency tool is always available with no limits
            </Text>
          </View>
        )}

        {/* Voice Selection */}
        <View style={styles.voiceSelectionCard}>
          <Text style={styles.voiceSelectionTitle}>Voice Preference</Text>
          <Text style={styles.voiceSelectionSubtitle}>
            Next tool will play with: <Text style={styles.voiceSelectionHighlight}>{useFemaleVoice ? 'Female' : 'Male'} Voice</Text>
          </Text>
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

        {/* Tools Remaining Indicator - Only show with active session */}
        {currentSession && (
          <View style={styles.toolsRemainingContainer}>
            <Text style={styles.toolsRemaining}>
              Regular Tools Remaining: {recommendations.remaining_regular_tools}/2
            </Text>
            <Text style={styles.toolsRemaining}>
              Breathing Tools Remaining: {recommendations.remaining_breathing_tools}/4
            </Text>
          </View>
        )}

        {/* START OF RIDE Button & Tool */}
        {currentSession && recommendations.start_of_ride && (
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
        {currentSession && recommendations.during_ride && recommendations.during_ride.length > 0 && (
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
          <View style={styles.emergencySection}>
            <TouchableOpacity
              style={styles.emergencyMainButton}
              onPress={() => {
                if (currentPlayingTool === recommendations.emergency?.id) {
                  stopSpeaking();
                } else {
                  playTool(recommendations.emergency, true);
                }
              }}
            >
              <Text style={styles.emergencyMainButtonText}>
                {currentPlayingTool === recommendations.emergency.id ? 'STOP' : 'EMERGENCY TOOL'}
              </Text>
            </TouchableOpacity>
            {currentPlayingTool === recommendations.emergency.id && isSpeaking && (
              <View style={styles.toolDetailsCard}>
                <Text style={styles.toolDetailsTitle}>{recommendations.emergency.name}</Text>
                <Text style={styles.toolDetailsCategory}>{recommendations.emergency.category}</Text>
                <Text style={styles.toolDetailsReason}>{recommendations.emergency.reason}</Text>
                <TouchableOpacity style={styles.stopButton} onPress={stopSpeaking}>
                  <Ionicons name="stop-circle" size={32} color="#ffffff" />
                  <Text style={styles.stopButtonText}>Stop Audio</Text>
                </TouchableOpacity>
              </View>
            )}
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
  rulesCard: {
    backgroundColor: '#ffffff',
    padding: 20,
    borderRadius: 12,
    marginBottom: 20,
    borderWidth: 2,
    borderColor: '#375B50',
  },
  rulesTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#1e293b',
    marginBottom: 16,
    textAlign: 'center',
  },
  rulesDescription: {
    fontSize: 14,
    color: '#000000',
    lineHeight: 22,
  },
  bold: {
    fontWeight: 'bold',
    color: '#375B50',
  },
  voiceSelectionCard: {
    backgroundColor: '#ffffff',
    padding: 20,
    borderRadius: 12,
    marginBottom: 20,
    borderWidth: 2,
    borderColor: '#375B50',
  },
  voiceSelectionTitle: {
    fontSize: 16,
    fontWeight: 'bold',
    color: '#1e293b',
    marginBottom: 8,
    textAlign: 'center',
  },
  voiceSelectionSubtitle: {
    fontSize: 13,
    color: '#64748b',
    marginBottom: 12,
    textAlign: 'center',
  },
  voiceSelectionHighlight: {
    fontWeight: 'bold',
    color: '#375B50',
  },
  voiceButtons: {
    flexDirection: 'row',
    justifyContent: 'space-around',
  },
  voiceButton: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: '#ffffff',
    borderWidth: 2,
    borderColor: '#375B50',
    padding: 12,
    borderRadius: 12,
    marginHorizontal: 8,
  },
  voiceButtonActive: {
    backgroundColor: '#375B50',
  },
  voiceButtonText: {
    fontSize: 14,
    fontWeight: '600',
    color: '#375B50',
    marginLeft: 8,
  },
  voiceButtonTextActive: {
    color: '#ffffff',
  },
  toolsRemainingContainer: {
    marginBottom: 24,
    alignItems: 'center',
  },
  toolsRemaining: {
    fontSize: 14,
    color: '#1e293b',
    textAlign: 'center',
    marginBottom: 4,
    fontWeight: '600',
  },
  mainButton: {
    backgroundColor: '#375B50',
    padding: 20,
    borderRadius: 12,
    alignItems: 'center',
    marginBottom: 16,
  },
  duringRideButton: {
    backgroundColor: '#375B50',
  },
  mainButtonText: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#ffffff',
  },
  toolDetailsCard: {
    backgroundColor: '#ffffff',
    padding: 20,
    borderRadius: 12,
    marginTop: 16,
    borderWidth: 1,
    borderColor: '#375B50',
  },
  toolDetailsTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#1e293b',
    marginBottom: 8,
  },
  toolDetailsCategory: {
    fontSize: 13,
    color: '#64748b',
    marginBottom: 12,
    fontWeight: '600',
  },
  toolDetailsReason: {
    fontSize: 14,
    color: '#475569',
    marginBottom: 16,
    lineHeight: 20,
  },
  stopButton: {
    flexDirection: 'row',
    backgroundColor: '#375B50',
    padding: 16,
    borderRadius: 12,
    alignItems: 'center',
    justifyContent: 'center',
  },
  stopButtonText: {
    fontSize: 16,
    fontWeight: '600',
    color: '#ffffff',
    marginLeft: 12,
  },
  warningCard: {
    backgroundColor: '#fff7ed',
    padding: 20,
    borderRadius: 12,
    marginBottom: 20,
    borderWidth: 2,
    borderColor: '#f59e0b',
    alignItems: 'center',
  },
  warningTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#1e293b',
    marginTop: 12,
    marginBottom: 8,
  },
  warningText: {
    fontSize: 14,
    color: '#000000',
    textAlign: 'center',
    lineHeight: 20,
  },
  section: {
    marginBottom: 32,
  },
  emergencySection: {
    marginBottom: 32,
    alignItems: 'center',
  },
  emergencyTitle: {
    fontSize: 28,
    fontWeight: 'bold',
    color: '#dc2626',
    marginBottom: 8,
    textAlign: 'center',
  },
  emergencyMainButton: {
    backgroundColor: '#ffffff',
    paddingVertical: 24,
    paddingHorizontal: 40,
    borderRadius: 12,
    alignItems: 'center',
    minWidth: '80%',
    borderWidth: 3,
    borderColor: '#dc2626',
  },
  emergencyMainButtonText: {
    fontSize: 22,
    fontWeight: 'bold',
    color: '#dc2626',
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
