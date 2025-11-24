import React, { useEffect, useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  ActivityIndicator,
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

  const handlePlayAudio = () => {
    if (!strategy) return;

    const audioScript = extractAudioScript(strategy.instructions);
    setIsSpeaking(true);

    Speech.speak(audioScript, {
      language: 'en-GB',
      pitch: 1.0,
      rate: 0.85,
      // British female voice similar to Emma Thompson - sophisticated and warm
      voice: 'com.apple.speech.synthesis.voice.Kate', // Premium British female voice (iOS)
      quality: Speech.VoiceQuality.Enhanced,
      onDone: () => setIsSpeaking(false),
      onError: () => setIsSpeaking(false),
    });
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
          <View
            style={[
              styles.categoryBadge,
              { backgroundColor: getCategoryColor(strategy.category) + '20' },
            ]}
          >
            <Text style={[styles.categoryText, { color: getCategoryColor(strategy.category) }]}>
              {strategy.category.split(',')[0].trim()}
            </Text>
          </View>
          <Text style={styles.strategyName}>{strategy.name}</Text>
        </View>

        <View style={styles.metaRow}>
          <View style={styles.metaCard}>
            <Ionicons name="time" size={24} color="#000000" />
            <Text style={styles.metaValue}>{strategy.duration_minutes}</Text>
            <Text style={styles.metaLabel}>Minutes</Text>
          </View>
          <View style={styles.metaCard}>
            <Ionicons name="star" size={24} color="#f59e0b" />
            <Text style={styles.metaValue}>{strategy.effectiveness_rating.toFixed(1)}</Text>
            <Text style={styles.metaLabel}>Rating</Text>
          </View>
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
          <Text style={styles.sectionTitle}>Target Levels</Text>
          <View style={styles.levelRow}>
            <View style={styles.levelCard}>
              <Ionicons name="pulse" size={20} color="#ef4444" />
              <Text style={styles.levelLabel}>Anxiety</Text>
              <Text style={styles.levelValue}>
                {Math.min(...strategy.anxiety_level)}-{Math.max(...strategy.anxiety_level)}/10
              </Text>
            </View>
            <View style={styles.levelCard}>
              <Ionicons name="shield-checkmark" size={20} color="#10b981" />
              <Text style={styles.levelLabel}>Confidence</Text>
              <Text style={styles.levelValue}>
                {Math.min(...strategy.confidence_level)}-{Math.max(...strategy.confidence_level)}/10
              </Text>
            </View>
          </View>
        </View>

        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Instructions</Text>
          <View style={styles.instructionsCard}>
            <Text style={styles.instructionsText}>{strategy.instructions}</Text>
          </View>
        </View>

        {strategy.metadata?.phases && (
          <View style={styles.section}>
            <Text style={styles.sectionTitle}>Best Used During</Text>
            <View style={styles.tagContainer}>
              {strategy.metadata.phases.map((phase: string, index: number) => (
                <View key={index} style={styles.tag}>
                  <Text style={styles.tagText}>{phase}</Text>
                </View>
              ))}
            </View>
          </View>
        )}
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
    marginBottom: 24,
  },
  categoryBadge: {
    alignSelf: 'flex-start',
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 8,
    marginBottom: 12,
  },
  categoryText: {
    fontSize: 12,
    fontWeight: '600',
  },
  strategyName: {
    fontSize: 28,
    fontWeight: 'bold',
    color: '#1e293b',
    lineHeight: 36,
  },
  metaRow: {
    flexDirection: 'row',
    marginBottom: 24,
  },
  metaCard: {
    flex: 1,
    backgroundColor: '#ffffff',
    padding: 20,
    borderRadius: 12,
    alignItems: 'center',
    marginHorizontal: 6,
    borderWidth: 1,
    borderColor: '#375B50',
  },
  metaValue: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#1e293b',
    marginTop: 8,
  },
  metaLabel: {
    fontSize: 12,
    color: '#000000',
    marginTop: 4,
  },
  audioButton: {
    flexDirection: 'row',
    backgroundColor: '#375B50',
    padding: 16,
    borderRadius: 12,
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: 24,
  },
  audioButtonActive: {
    backgroundColor: '#ef4444',
  },
  audioButtonText: {
    fontSize: 16,
    fontWeight: '600',
    color: '#ffffff',
    marginLeft: 8,
  },
  section: {
    marginBottom: 24,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#1e293b',
    marginBottom: 12,
  },
  levelRow: {
    flexDirection: 'row',
  },
  levelCard: {
    flex: 1,
    backgroundColor: '#ffffff',
    padding: 16,
    borderRadius: 12,
    marginHorizontal: 6,
    borderWidth: 1,
    borderColor: '#375B50',
  },
  levelLabel: {
    fontSize: 12,
    color: '#000000',
    marginTop: 8,
  },
  levelValue: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#1e293b',
    marginTop: 4,
  },
  instructionsCard: {
    backgroundColor: '#ffffff',
    padding: 20,
    borderRadius: 12,
    borderWidth: 1,
    borderColor: '#375B50',
  },
  instructionsText: {
    fontSize: 14,
    color: '#000000',
    lineHeight: 24,
  },
  tagContainer: {
    flexDirection: 'row',
    flexWrap: 'wrap',
  },
  tag: {
    backgroundColor: '#ffffff',
    paddingHorizontal: 12,
    paddingVertical: 8,
    borderRadius: 8,
    marginRight: 8,
    marginBottom: 8,
    borderWidth: 1,
    borderColor: '#375B50',
  },
  tagText: {
    fontSize: 12,
    color: '#000000',
    fontWeight: '600',
  },
});
