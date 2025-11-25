import React, { useEffect, useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  ActivityIndicator,
  Platform,
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
  metadata: any;
}

export default function StrategyDetail() {
  const router = useRouter();
  const { id } = useLocalSearchParams();
  const [strategy, setStrategy] = useState<Strategy | null>(null);
  const [loading, setLoading] = useState(true);
  const [isSpeaking, setIsSpeaking] = useState(false);

  useEffect(() => {
    if (id) {
      fetchStrategy();
    }
  }, [id]);

  const fetchStrategy = async () => {
    try {
      const response = await api.get(`/mental-strategies/${id}`);
      setStrategy(response.data);
    } catch (error) {
      console.error('Error fetching strategy:', error);
    } finally {
      setLoading(false);
    }
  };

  const extractAudioScript = (instructions: string): string => {
    const match = instructions.match(/Audio Script:\s*([\s\S]*?)(?:\n\n|$)/);
    if (match && match[1]) {
      return match[1].trim();
    }
    return instructions;
  };

  const handlePlayAudio = async () => {
    if (!strategy) return;

    const audioScript = extractAudioScript(strategy.instructions);
    setIsSpeaking(true);

    try {
      // Get all available voices on the device
      const voices = await Speech.getAvailableVoicesAsync();
      
      // Find a natural female voice
      // Priority order: enhanced quality female voices, then any female voice
      const femaleVoice = voices.find(v => 
        v.language.startsWith('en') && 
        (v.name.toLowerCase().includes('samantha') || 
         v.name.toLowerCase().includes('karen') ||
         v.name.toLowerCase().includes('moira') ||
         v.name.toLowerCase().includes('fiona') ||
         v.name.toLowerCase().includes('tessa'))
      ) || voices.find(v => 
        v.language.startsWith('en') && 
        v.quality === 'Enhanced'
      ) || voices.find(v => 
        v.language.startsWith('en')
      );

      // Configure voice options for natural-sounding female voice
      const voiceOptions: any = {
        language: 'en-US',
        pitch: 1.0,  // Natural pitch
        rate: 0.85,  // Slightly slower for clarity and natural sound
        voice: femaleVoice?.identifier,
        onDone: () => setIsSpeaking(false),
        onError: () => setIsSpeaking(false),
      };

      Speech.speak(audioScript, voiceOptions);
    } catch (error) {
      // Fallback if voice selection fails
      Speech.speak(audioScript, {
        language: 'en-US',
        pitch: 1.0,
        rate: 0.85,
        onDone: () => setIsSpeaking(false),
        onError: () => setIsSpeaking(false),
      });
    }
  };

  const handleStopAudio = () => {
    Speech.stop();
    setIsSpeaking(false);
  };

  const getCategoryColor = (category: string) => {
    if (category.includes('Mindfulness')) return '#10b981';
    if (category.includes('Breathing')) return '#000000';
    if (category.includes('Somatic')) return '#8b5cf6';
    if (category.includes('Activation')) return '#f59e0b';
    if (category.includes('Cognitive')) return '#06b6d4';
    return '#6366f1';
  };

  if (loading) {
    return (
      <SafeAreaView style={styles.container} edges={['top']}>
        <View style={styles.loadingContainer}>
          <ActivityIndicator size="large" color="#000000" />
          <Text style={styles.loadingText}>Loading strategy...</Text>
        </View>
      </SafeAreaView>
    );
  }

  if (!strategy) {
    return (
      <SafeAreaView style={styles.container} edges={['top']}>
        <View style={styles.header}>
          <TouchableOpacity onPress={() => router.back()} style={styles.backButton}>
            <Ionicons name="arrow-back" size={24} color="#f1f5f9" />
          </TouchableOpacity>
          <Text style={styles.title}>Strategy Not Found</Text>
          <View style={styles.placeholder} />
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
        <Text style={styles.title}>Strategy Details</Text>
        <View style={styles.placeholder} />
      </View>

      <ScrollView style={styles.content}>
        <View style={styles.strategyHeader}>
          <Text style={styles.strategyName}>{strategy.name}</Text>
        </View>

        <TouchableOpacity
          style={[styles.audioButton, isSpeaking && styles.audioButtonActive]}
          onPress={isSpeaking ? handleStopAudio : handlePlayAudio}
        >
          <Ionicons
            name={isSpeaking ? 'stop-circle' : 'play-circle'}
            size={28}
            color="#ffffff"
          />
          <Text style={styles.audioButtonText}>
            {isSpeaking ? 'Stop Audio Guidance' : 'Play Audio Guidance'}
          </Text>
        </TouchableOpacity>

        <View style={styles.section}>
          <View style={styles.instructionsCard}>
            <Text style={styles.instructionsText}>{strategy.instructions}</Text>
          </View>
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
  content: {
    flex: 1,
    padding: 24,
  },
  strategyHeader: {
    marginBottom: 32,
  },
  strategyName: {
    fontSize: 32,
    fontWeight: 'bold',
    color: '#1e293b',
    lineHeight: 40,
    textAlign: 'center',
  },
  audioButton: {
    flexDirection: 'row',
    backgroundColor: '#375B50',
    padding: 20,
    borderRadius: 12,
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: 32,
  },
  audioButtonActive: {
    backgroundColor: '#ef4444',
  },
  audioButtonText: {
    fontSize: 18,
    fontWeight: '600',
    color: '#ffffff',
    marginLeft: 8,
  },
  section: {
    marginBottom: 24,
  },
  instructionsCard: {
    backgroundColor: '#ffffff',
    padding: 24,
    borderRadius: 12,
    borderWidth: 1,
    borderColor: '#375B50',
  },
  instructionsText: {
    fontSize: 16,
    color: '#000000',
    lineHeight: 26,
  },
});
