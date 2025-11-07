import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  Alert,
  ScrollView,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useRouter } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import * as Speech from 'expo-speech';
import api from '../lib/api';

interface Strategy {
  id: string;
  name: string;
  instructions: string;
}

export default function DuringRide() {
  const router = useRouter();
  const [isListening, setIsListening] = useState(false);
  const [lastAdvice, setLastAdvice] = useState('');
  const [strategies, setStrategies] = useState<Strategy[]>([]);
  const [isSpeaking, setIsSpeaking] = useState(false);

  useEffect(() => {
    fetchStrategies();
  }, []);

  const fetchStrategies = async () => {
    try {
      const response = await api.get('/mental-strategies');
      setStrategies(response.data);
    } catch (error) {
      console.error('Error fetching strategies:', error);
    }
  };

  const getRandomStrategy = () => {
    if (strategies.length === 0) return null;
    return strategies[Math.floor(Math.random() * strategies.length)];
  };

  const extractAudioScript = (instructions: string): string => {
    const match = instructions.match(/Audio Script:\s*([\s\S]*?)(?:\n\n|$)/);
    if (match && match[1]) {
      return match[1].trim();
    }
    // Fallback to micro script
    const microMatch = instructions.match(/Micro Script:\s*([\s\S]*?)(?:\n\n|Audio Script:|$)/);
    if (microMatch && microMatch[1]) {
      return microMatch[1].replace(/Coach:\s*/g, '').trim();
    }
    return instructions;
  };

  const speakAdvice = async () => {
    const strategy = getRandomStrategy();
    if (!strategy) {
      Alert.alert('No Strategies', 'No strategies available. Please try again later.');
      return;
    }

    const audioScript = extractAudioScript(strategy.instructions);
    setLastAdvice(`${strategy.name}: ${audioScript}`);
    setIsSpeaking(true);

    Speech.speak(audioScript, {
      language: 'en',
      pitch: 1.0,
      rate: 0.9,
      onDone: () => setIsSpeaking(false),
      onError: () => {
        setIsSpeaking(false);
        Alert.alert('Error', 'Failed to speak advice');
      },
    });
  };

  const stopSpeaking = () => {
    Speech.stop();
    setIsSpeaking(false);
  };

  const toggleListening = () => {
    if (isListening) {
      setIsListening(false);
    } else {
      setIsListening(true);
      Alert.alert(
        'Voice Trigger Active',
        'Say "advice" to get real-time coaching. For this demo, tap the "Get Advice" button.',
        [{ text: 'OK' }]
      );
    }
  };

  return (
    <SafeAreaView style={styles.container} edges={['top']}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()} style={styles.backButton}>
          <Ionicons name="arrow-back" size={24} color="#f1f5f9" />
        </TouchableOpacity>
        <Text style={styles.title}>During Ride Coaching</Text>
        <View style={styles.placeholder} />
      </View>

      <ScrollView style={styles.content}>
        <View style={styles.statusCard}>
          <View
            style={[
              styles.statusIndicator,
              { backgroundColor: isListening ? '#10b98120' : '#64748b20' },
            ]}
          >
            <Ionicons
              name={isListening ? 'mic' : 'mic-off'}
              size={48}
              color={isListening ? '#10b981' : '#64748b'}
            />
          </View>
          <Text style={styles.statusTitle}>
            {isListening ? 'Listening for "advice"' : 'Voice Trigger Inactive'}
          </Text>
          <Text style={styles.statusSubtitle}>
            {isListening
              ? 'Say "advice" to get real-time coaching'
              : 'Activate voice trigger to begin'}
          </Text>
        </View>

        <View style={styles.controls}>
          <TouchableOpacity
            style={[
              styles.controlButton,
              isListening ? styles.controlButtonActive : styles.controlButtonInactive,
            ]}
            onPress={toggleListening}
          >
            <Ionicons
              name={isListening ? 'mic' : 'mic-off'}
              size={28}
              color={isListening ? '#10b981' : '#64748b'}
            />
            <Text
              style={[
                styles.controlButtonText,
                isListening ? styles.controlButtonTextActive : styles.controlButtonTextInactive,
              ]}
            >
              {isListening ? 'Stop Listening' : 'Start Listening'}
            </Text>
          </TouchableOpacity>

          <TouchableOpacity
            style={[styles.adviceButton, isSpeaking && styles.adviceButtonActive]}
            onPress={isSpeaking ? stopSpeaking : speakAdvice}
            disabled={strategies.length === 0}
          >
            <Ionicons
              name={isSpeaking ? 'stop-circle' : 'play-circle'}
              size={32}
              color="#ffffff"
            />
            <Text style={styles.adviceButtonText}>
              {isSpeaking ? 'Stop Advice' : 'Get Advice Now'}
            </Text>
          </TouchableOpacity>
        </View>

        {lastAdvice ? (
          <View style={styles.adviceCard}>
            <View style={styles.adviceHeader}>
              <Ionicons name="information-circle" size={24} color="#3b82f6" />
              <Text style={styles.adviceTitle}>Last Advice</Text>
            </View>
            <Text style={styles.adviceText}>{lastAdvice}</Text>
          </View>
        ) : null}

        <View style={styles.infoCard}>
          <Ionicons name="lightbulb" size={32} color="#f59e0b" />
          <Text style={styles.infoTitle}>How It Works</Text>
          <Text style={styles.infoText}>
            1. Activate voice trigger{"\n"}
            2. Say "advice" during your ride{"\n"}
            3. Get real-time mental coaching via audio{"\n"}
            4. Or tap "Get Advice Now" for instant guidance
          </Text>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#0f172a',
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
    color: '#f1f5f9',
  },
  placeholder: {
    width: 40,
  },
  content: {
    flex: 1,
    padding: 24,
  },
  statusCard: {
    backgroundColor: '#1e293b',
    padding: 32,
    borderRadius: 16,
    alignItems: 'center',
    marginBottom: 24,
    borderWidth: 1,
    borderColor: '#334155',
  },
  statusIndicator: {
    width: 96,
    height: 96,
    borderRadius: 48,
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: 16,
  },
  statusTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#f1f5f9',
    marginBottom: 8,
  },
  statusSubtitle: {
    fontSize: 14,
    color: '#94a3b8',
    textAlign: 'center',
  },
  controls: {
    marginBottom: 24,
  },
  controlButton: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    padding: 16,
    borderRadius: 12,
    marginBottom: 12,
    borderWidth: 2,
  },
  controlButtonActive: {
    backgroundColor: '#10b98120',
    borderColor: '#10b981',
  },
  controlButtonInactive: {
    backgroundColor: '#1e293b',
    borderColor: '#334155',
  },
  controlButtonText: {
    fontSize: 16,
    fontWeight: '600',
    marginLeft: 8,
  },
  controlButtonTextActive: {
    color: '#10b981',
  },
  controlButtonTextInactive: {
    color: '#94a3b8',
  },
  adviceButton: {
    flexDirection: 'row',
    backgroundColor: '#3b82f6',
    padding: 20,
    borderRadius: 12,
    alignItems: 'center',
    justifyContent: 'center',
  },
  adviceButtonActive: {
    backgroundColor: '#ef4444',
  },
  adviceButtonText: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#ffffff',
    marginLeft: 12,
  },
  adviceCard: {
    backgroundColor: '#1e293b',
    padding: 20,
    borderRadius: 12,
    marginBottom: 24,
    borderWidth: 1,
    borderColor: '#334155',
  },
  adviceHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 12,
  },
  adviceTitle: {
    fontSize: 16,
    fontWeight: '600',
    color: '#f1f5f9',
    marginLeft: 8,
  },
  adviceText: {
    fontSize: 14,
    color: '#94a3b8',
    lineHeight: 22,
  },
  infoCard: {
    backgroundColor: '#1e293b',
    padding: 20,
    borderRadius: 12,
    alignItems: 'center',
    borderWidth: 1,
    borderColor: '#334155',
  },
  infoTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#f1f5f9',
    marginTop: 12,
    marginBottom: 12,
  },
  infoText: {
    fontSize: 14,
    color: '#94a3b8',
    lineHeight: 22,
    textAlign: 'left',
    width: '100%',
  },
});
